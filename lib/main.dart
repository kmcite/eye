import 'package:eye/business/users.dart';
import 'package:eye/features/auth/authentication.dart';
import 'package:eye/features/auth/authentication_state.dart';
import 'package:eye/features/home/home.dart';
import 'package:eye/objectbox.g.dart' hide Box;
import 'package:eye/main.dart';
import 'package:eye/utils/db.dart';
import 'package:eye/utils/hive.dart';
import 'package:eye/utils/navigator.dart';
export 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
// ignore: unnecessary_import
import 'package:objectbox/objectbox.dart' hide Box;
import 'package:yaru/yaru.dart';
export 'package:states_rebuilder/states_rebuilder.dart';
import 'package:hive_flutter/hive_flutter.dart';

export 'package:signals/signals.dart';

late Store store;
late Box cache;

void main() async {
  FlutterNativeSplash.preserve(
    widgetsBinding: WidgetsFlutterBinding.ensureInitialized(),
  );
  await Hive.initFlutter();
  cache = await Hive.openBox('cache');
  await ensureInitialized();
  await RM.storageInitializer(HiveStorage());
  runApp(const EyeApp());
}

final dark = computed(() => user()?.dark);

class EyeApp extends UI {
  const EyeApp({super.key});
  void init(_) {
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // routeInformationParser: router.routeInformationParser,
      // routerDelegate: router.routerDelegate,
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      themeMode: dark().choose<ThemeMode>(
        ThemeMode.dark,
        ThemeMode.light,
        ThemeMode.system,
      ),
      theme: yaruLight,
      darkTheme: yaruDark,
      home: authenticated().choose(
        HomePage(),
        AutheticationPage(),
      ),
    );
  }
}

extension BoolNullableExtensions on bool? {
  T choose<T>(T whenTrue, T whenFalse, T whenNull) {
    if (this != null) {
      if (this!) {
        return whenTrue;
      } else {
        return whenFalse;
      }
    } else {
      return whenNull;
    }
  }
}

extension BoolExtensions on bool {
  T choose<T>(T whenTrue, T whenFalse) {
    if (this) {
      return whenTrue;
    } else {
      return whenFalse;
    }
  }
}
