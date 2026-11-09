import 'dart:async';

import 'package:eye/features/screen/auth_gate.dart';
import 'package:eye/utils/infrastructure.dart';
import 'package:eye/ui/overlay.dart';
import 'package:eye/ui/page.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

extension RouterExtension on SignalConsumer {
  AppRouter get router => appRouter();
}

final appRouter = provider(() => AppRouter(const AuthGate()));

class AppRouter(
  final SignalConsumer home,
) implements RouterConfig<List<SignalConsumer>> {
  @override
  final backButtonDispatcher = RootBackButtonDispatcher();

  @override
  final routeInformationParser = null;

  @override
  final routeInformationProvider = null;

  @override
  final AppDelegate routerDelegate = AppDelegate(home);

  void go(SignalConsumer page) => routerDelegate.go(page);
  void push(SignalConsumer page) => routerDelegate.push(page);
  void pop<T extends Object?>([T? result]) => routerDelegate.pop<T>(result);
  void popToRoot() => routerDelegate.popToRoot();

  bool canPop() => routerDelegate.canPop();

  void presentDialog(
    Widget dialog, {
    bool barrierDismissible = true,
  }) =>
      routerDelegate.presentDialog(dialog, barrierDismissible: barrierDismissible);

  void presentSheet(Widget sheet) => routerDelegate.presentSheet(sheet);

  Future<bool?> confirm({
    required String title,
    required String message,
    String confirm = 'OK',
    String cancel = 'Cancel',
    bool isDestructive = false,
  }) {
    final completer = Completer<bool?>();
    presentDialog(
      EyeConfirmDialog(
        title: title,
        message: message,
        confirm: confirm,
        cancel: cancel,
        isDestructive: isDestructive,
        onClose: completer.complete,
      ),
    );
    return completer.future;
  }

  Future<void> handleBack() async {
    if (canPop()) {
      pop();
      return;
    }
    final exit = await confirm(
      title: 'Exit Eye?',
      message: 'Close the app?',
      confirm: 'Exit',
      cancel: 'Stay',
      isDestructive: true,
    );
    if (exit == true) await SystemNavigator.pop();
  }
}

class AppDelegate extends RouterDelegate<List<SignalConsumer>>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<List<SignalConsumer>> {
  AppDelegate(SignalConsumer home)
    : _pages = [EyePage<void>(key: UniqueKey(), child: home)];

  final List<Page<void>> _pages;
  var _syncing = false;

  @override
  final navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) appRouter().handleBack();
      },
      child: Navigator(
        key: navigatorKey,
        pages: List<Page<void>>.of(_pages),
        onDidRemovePage: (page) {
          if (_syncing || _pages.length <= 1 || !_pages.contains(page)) return;
          _pages.remove(page);
          notifyListeners();
        },
      ),
    );
  }

  @override
  Future<void> setNewRoutePath(configuration) async {}

  void go(SignalConsumer page) {
    _syncing = true;
    _pages
      ..clear()
      ..add(EyePage<void>(key: UniqueKey(), child: page));
    notifyListeners();
    _syncing = false;
  }

  void push(SignalConsumer page) {
    _syncing = true;
    _pages.add(EyePage<void>(key: UniqueKey(), child: page));
    notifyListeners();
    _syncing = false;
  }

  void presentDialog(
    Widget dialog, {
    bool barrierDismissible = true,
  }) {
    _syncing = true;
    _pages.add(
      EyeDialogPage<void>(
        key: UniqueKey(),
        barrierDismissible: barrierDismissible,
        child: dialog,
      ),
    );
    notifyListeners();
    _syncing = false;
  }

  void presentSheet(Widget sheet) {
    _syncing = true;
    _pages.add(EyeSheetPage<void>(key: UniqueKey(), child: sheet));
    notifyListeners();
    _syncing = false;
  }

  void pop<T extends Object?>([T? result]) {
    if (_pages.length <= 1) return;
    _syncing = true;
    _pages.removeLast();
    notifyListeners();
    _syncing = false;
  }

  void popToRoot() {
    if (_pages.length <= 1) return;
    _syncing = true;
    final root = _pages.first;
    _pages
      ..clear()
      ..add(root);
    notifyListeners();
    _syncing = false;
  }

  bool canPop() => _pages.length > 1;
}
