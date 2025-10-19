import 'package:eye/domain/api/user_repository.dart';
import 'package:eye/domain/models/app_user.dart';
import 'package:eye/features/login/login_page.dart';
import 'package:eye/features/home/home_page.dart';
import 'package:eye/objectbox.g.dart';
import 'package:eye/main.dart';
import 'package:eye/utils/api.dart';
export 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:manager/dark/dark_repository.dart';
export 'package:forui/forui.dart';
export 'package:manager/manager.dart';
export 'package:states_rebuilder/states_rebuilder.dart';

void main() async {
  FlutterNativeSplash.preserve(
    widgetsBinding: WidgetsFlutterBinding.ensureInitialized(),
  );

  manager(
    const EyeApp(),
    openStore: openStore,
  );
}

bool get authenticated => userRepository.authenticated;
AppUser get user =>
    // usersRepository.one(userRepository.id) ??
    AppUser();
bool get dark => darkRepository.state;

class EyeApp extends UI {
  const EyeApp({super.key});
  @override
  void didMountWidget(_) {
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigator.navigatorKey,
      themeMode: dark ? ThemeMode.dark : ThemeMode.light,
      builder: (_, child) => FTheme(
        data: dark ? FThemes.yellow.dark : FThemes.yellow.light,
        child: child!,
      ),
      home: authenticated ? const HomePage() : LoginPage(),
    );
  }
}
