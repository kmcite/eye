import 'package:eye/business/app_status_notifier.dart';
import 'package:eye/business/sync_notifier.dart';
import 'package:eye/ui/app.dart';
import 'package:eye/utils/objectbox.dart';
import 'package:eye/utils/hive_box.dart';
import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';

export 'package:eye/utils/infrastructure.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter('eye');
  hiveBoxProvider.override(await Hive.openBox('eye'));
  objectBoxStoreProvider.override(await openObjectBox());
  syncNotifierProvider().start();
  appStatusNotifierProvider().start();
  runApp(const EyeApp());
}
