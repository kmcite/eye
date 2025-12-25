import 'package:eye/domain/api/users.dart';
import 'package:eye/objectbox.g.dart' hide Box;
import 'package:eye/main.dart';
import 'package:eye/utils/hive.dart';
import 'package:eye/utils/router.dart';
export 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
// ignore: unnecessary_import
import 'package:objectbox/objectbox.dart' hide Box;
import 'package:path_provider/path_provider.dart';
import 'package:yaru/yaru.dart';
export 'package:states_rebuilder/states_rebuilder.dart';
import 'package:hive_flutter/hive_flutter.dart';

late Store store;
late Box cache;

void main() async {
  FlutterNativeSplash.preserve(
    widgetsBinding: WidgetsFlutterBinding.ensureInitialized(),
  );
  final documentsDirectory = await getApplicationDocumentsDirectory();
  await Hive.initFlutter();
  cache = await Hive.openBox('cache');
  store = await openStore(
    directory: documentsDirectory.path + '/eye',
  );
  await RM.storageInitializer(HiveStorage());
  runApp(const EyeApp());
}

bool get safeDark => safeUser?.dark ?? false;
typedef UI = ReactiveStatelessWidget;

class EyeApp extends UI {
  const EyeApp({super.key});
  @override
  void didMountWidget(_) {
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routeInformationParser: router.routeInformationParser,
      routerDelegate: router.routerDelegate,
      debugShowCheckedModeBanner: false,
      themeMode: safeDark ? ThemeMode.dark : ThemeMode.light,
      theme: yaruLight,
      darkTheme: yaruDark,
    );
  }
}
