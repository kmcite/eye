import 'package:flutter/material.dart';

import 'package:eye/utils/infrastructure.dart';
import 'package:eye/utils/router.dart';
import 'package:eye/ui/branding/eye_splash_gate.dart';
import 'package:eye/ui/glass.dart';
import 'package:eye/ui/keyboard.dart';
import 'package:eye/ui/theme.dart';

/// Global chrome around routed content: splash → keyboard → glass backdrop.
class EyeAppChrome extends StatelessWidget {
  const EyeAppChrome({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return EyeSplashGate(
      child: EyeKeyboardDismiss(
        child: GlassBackground(child: child),
      ),
    );
  }
}

class EyeApp extends SignalConsumer {
  const EyeApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = appRouter();
    final bootstrap = resolveEyeThemeData();

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: bootstrap.toMaterialTheme(),
      routerConfig: router,
      builder: (context, child) {
        final eye = resolveEyeThemeData(context);
        return EyeTheme(
          data: eye,
          child: Theme(
            data: eye.toMaterialTheme(),
            child: EyeAppChrome(child: child ?? const SizedBox.shrink()),
          ),
        );
      },
    );
  }
}
