import 'package:eye/authentication/login/login_page.dart';
import 'package:eye/main.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:forui/forui.dart';
import 'dashboard/dashboard_page.dart';
import 'dependency_injection.dart';
export 'package:manager/manager.dart';

void main() async {
  FlutterNativeSplash.preserve(
    widgetsBinding: WidgetsFlutterBinding.ensureInitialized(),
  );
  await RM.storageInitializer(HiveStorage());
  runApp(const EyeApp());
}

final _eye = EyeBloc();

class EyeBloc extends Bloc {
  bool get authenticated => usersRepository.isUserAuthenticated;
  GlobalKey<NavigatorState> get key => navigation.key;
  bool get isDark => themeMode == ThemeMode.dark;
  ThemeMode get themeMode => usersRepository.currentUser.themeMode;
}

class EyeApp extends UI {
  const EyeApp({super.key});
  @override
  void didMountWidget(BuildContext context) {
    super.didMountWidget(context);
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: _eye.key,
      themeMode: _eye.themeMode,
      builder: (_, child) => FTheme(
        data: _eye.isDark ? FThemes.yellow.dark : FThemes.yellow.light,
        child: child!,
      ),
      home: _eye.authenticated ? const DashboardPage() : LoginPage(),
    );
  }
}
