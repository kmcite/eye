import 'dart:async' show FutureOr;

import 'package:flutter/widgets.dart';

// ─── Tracking context ──────────────────────────────────────────────

final consumerStack = <Consumer>[];
Consumer? get activeConsumer =>
    consumerStack.isEmpty ? null : consumerStack.last;

// ─── Notifier: anything that can be read/depended-on ──────────────

class Notifier {
  final consumers = <Consumer>{};

  T link<T>(T value) {
    final consumer = activeConsumer;
    if (consumer != null && !consumer.notifiers.contains(this)) {
      consumers.add(consumer);
      consumer.notifiers.add(this);
    }
    return value;
  }

  void notify() {
    for (final consumer in consumers.toList()) {
      consumer.onNotify();
    }
  }
}

// ─── Consumer: anything that depends on notifiers ──────────────────

abstract mixin class Consumer {
  final notifiers = <Notifier>{};

  T track<T>(T Function() run) {
    final prevNotifiers = notifiers.toSet(); // snapshot before re-tracking
    notifiers.clear();
    consumerStack.add(this);
    try {
      return run();
    } finally {
      consumerStack.removeLast();
      // dynamic pruning: drop edges not re-linked this run (dead if/else branch)
      for (final stale in prevNotifiers.difference(notifiers)) {
        stale.consumers.remove(this);
      }
    }
  }

  // Getter everywhere (Computed and Effect both implement it this way)
  // so the two don't clash on method-vs-getter override shape.
  void onNotify();

  void dispose() {
    for (final notifier in notifiers) {
      notifier.consumers.remove(this);
    }
    notifiers.clear();
  }
}

// ─── Signal: writable leaf notifier ─────────────────────────────────

class Signal<T> extends Notifier {
  Signal(this._value);
  T _value;

  T get value => link(_value);
  T call([T Function(T)? updater]) {
    if (updater != null) {
      value = updater(_value);
    }
    return value;
  }

  set value(T newValue) {
    if (_value == newValue) return;
    _value = newValue;
    notify();
  }

  void set(T newValue) => value = newValue;
}

// ─── Computed: derived value — both Notifier and Consumer ──────────

class Computed<T> extends Notifier with Consumer {
  Computed(this._compute);
  final T Function() _compute;

  T? _cache;
  bool dirty = true;
  bool _hasValue = false;

  T get value {
    if (dirty) {
      final newValue = track(_compute);
      dirty = false;
      if (!_hasValue || newValue != _cache) {
        _cache = newValue;
        _hasValue = true;
        notify(); // propagate only if the recomputed value actually changed
      }
    }
    return link(_cache as T);
  }

  T call() => value;

  @override
  void onNotify() {
    if (dirty)
      return; // diamond dep: already marked, skip duplicate propagation
    dirty = true;
    notify(); // eager dirty-push to dependents; lazy recompute on next read
  }

  @override
  void dispose() {
    for (final notifier in notifiers) {
      notifier.consumers.remove(this);
    }
    notifiers.clear();
    consumers.clear();
  }
}

// ─── Effect: side-effecting consumer, disposable ────────────────────

class Effect with Consumer {
  Effect(this._effect) {
    track(() {
      _effect();
      return null;
    });
  }
  final VoidCallback _effect;
  bool _disposed = false;

  @override
  void onNotify() {
    if (_disposed) return; // may still be in a notify() snapshot post-disposal
    track(() {
      _effect();
      return null;
    });
  }

  @override
  T track<T>(T Function() run) {
    if (_disposed) return null as T; // never re-link after disposal
    return super.track(run);
  }

  @override
  void dispose() {
    if (_disposed) return; // idempotent
    _disposed = true;
    super.dispose();
  }
}

// ─── Convenience constructors ────────────────────────────────────────

Signal<T?> nullSignal<T>() => Signal(null);
Signal<T> signal<T>(T initialValue) => Signal(initialValue);

Computed<T> computed<T>(T Function() compute) => Computed(compute);

VoidCallback effect(VoidCallback runEffect) => Effect(runEffect).dispose;

// ─── Widget integration ──────────────────────────────────────────────

SignalConsumer consumer(
  Widget Function(BuildContext) builder, {
  Key? key,
}) {
  return _ConcreteSignalConsumerWidget(builder, key: key);
}

class _ConcreteSignalConsumerWidget extends SignalConsumer {
  _ConcreteSignalConsumerWidget(this.builder, {super.key});

  final Widget Function(BuildContext) builder;

  @override
  Widget build(BuildContext context) => builder(context);
}

abstract class SignalConsumer extends StatelessWidget {
  const SignalConsumer({super.key});

  @override
  Widget build(BuildContext context);

  @override
  StatelessElement createElement() => _SignalElement(this);
}

class _SignalElement extends StatelessElement with Consumer {
  _SignalElement(super.widget);

  @override
  Widget build() => track(super.build);

  @override
  void onNotify() => markNeedsBuild();

  @override
  void unmount() {
    dispose();
    super.unmount();
  }
}

// ─── Minimal DI container ────────────────────────────────────────────

class ProviderContainer {
  static final cache = <Provider, dynamic>{};

  static T resolve<T>(Provider<T> provider) {
    if (cache.containsKey(provider)) {
      return cache[provider] as T;
    }
    final create = provider.create;
    if (create == null) {
      throw UnimplementedError(
        'Need to override lazyProvider<$T> before usage',
      );
    }
    return cache[provider] = create();
  }

  static void put<T>(Provider<T> key, T value) {
    cache[key] = value;
  }
}

Provider<T> provider<T>(T Function() create) => Provider(create);
LazyProvider<T> lazyProvider<T>([T Function()? create]) => LazyProvider(create);

class Provider<T> {
  Provider(this.create);
  final T Function()? create;

  T call() => ProviderContainer.resolve(this);
  Override<T> override(T value) => Override(this, value);
}

class LazyProvider<T> extends Provider<T> {
  LazyProvider([super.create]);
}

class Override<T> {
  Override(Provider<T> key, T value) {
    ProviderContainer.put(key, value);
  }
}

void invalidateProvider(Provider<dynamic> provider) {
  ProviderContainer.cache.remove(provider);
}

// ─── Bloc-style event dispatch ───────────────────────────────────────

typedef Handler<E> = FutureOr<void> Function(E event);

/// A lightweight mixin for direct callback event handling.
class Bloc<Event> {
  final Map<Type, Function> _handlers = {};

  /// Registers a handler for event subtype [E].
  /// Overwrites any previously registered handler for the same type.
  void on<E extends Event>(Handler<E> handler) {
    _handlers[E] = handler;
  }

  /// Immediately invokes the registered handler for [event].
  FutureOr<void> call<E extends Event>(E event) {
    final handler = _handlers[E];

    if (handler case final Handler<E> fn) {
      try {
        return fn(event);
      } catch (error, stackTrace) {
        onError(error, stackTrace);
      }
    }
  }

  /// Override to capture uncaught exceptions during handler execution.
  void onError(Object error, StackTrace stackTrace) {
    assert(() {
      debugPrint('[$runtimeType] Error processing event: $error\n$stackTrace');
      return true;
    }());
  }

  /// Clears all registered event handlers.
  void closeEvents() {
    _handlers.clear();
  }
}

// ─── Loading/error mixin for ChangeNotifier-based controllers ───────

mixin LoadingErrorSignals on ChangeNotifier {
  var loading = false;
  Object? error;
  bool get hasError => error != null;

  Future<void> run(
    FutureOr<void> Function() runnable, [
    void Function(Object error, StackTrace st)? onError,
  ]) async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      await runnable();
    } catch (e, st) {
      error = e;
      onError?.call(e, st);
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}

/// Async work tracked with [Signal]s (for controllers without [ChangeNotifier]).
mixin SignalAsync {
  final loading = signal(false);
  final error = nullSignal<Object>();

  Future<void> run(
    FutureOr<void> Function() runnable, [
    void Function(Object error, StackTrace st)? onError,
  ]) async {
    loading.value = true;
    error.value = null;
    try {
      await runnable();
    } catch (e, st) {
      error.value = e;
      onError?.call(e, st);
    } finally {
      loading.value = false;
    }
  }
}
