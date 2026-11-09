import 'package:eye/business/authentication_notifier.dart';
import 'package:eye/features/screen/authentication/screen.dart';
import 'package:eye/features/screen/home/home.dart';
import 'package:eye/utils/infrastructure.dart';
import 'package:eye/utils/router.dart';
import 'package:flutter/widgets.dart';

/// Root route: switches between auth and home; clears stack on sign-out.
class AuthGate extends SignalConsumer {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final authentication = authenticationNotifierProvider();
    final authed = authentication.authenticated();

    if (!authed && router.canPop()) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!authentication.authenticated()) {
          router.popToRoot();
        }
      });
    }

    return authed ? const HomePage() : const AuthenticationScreen();
  }
}
