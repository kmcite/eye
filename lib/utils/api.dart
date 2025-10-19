import 'package:states_rebuilder/states_rebuilder.dart' as api;

// class _Injected<T> {
//   late final api.Injected<T> injected;
//   _Injected.value(
//     T value, {
//     bool autoDispose = true,
//   }) {
//     injected = api.RM.inject<T>(
//       () => value,
//       autoDisposeWhenNotUsed: autoDispose,
//     );
//   }
//   _Injected.stream(
//     Stream<T> Function() value,
//   ) {
//     injected = api.RM.injectStream<T>(value);
//   }
//   _Injected.future(
//     Future<T> Function() value,
//   ) {
//     injected = api.RM.injectFuture<T>(value);
//   }

//   bool get loading => injected.isWaiting;
//   bool get error => injected.hasError;
//   bool get success => injected.hasData;

//   T call([T? val]) {
//     if (val != null) {
//       injected
//         ..state = val
//         ..notify();
//     }
//     return injected.state;
//   }
// }

// _Injected<T> value<T>(T value) => _Injected.value(value);
// _Injected<T> stream<T>(Stream<T> Function() value) => _Injected.stream(value);
// _Injected<T> future<T>(Future<T> Function() value) => _Injected.future(value);
// typedef UI = api.ReactiveStatelessWidget;
// typedef Modifier<T> = T Function([T? value]);

final navigator = api.RM.navigate;
final scaffold = api.RM.scaffold;
