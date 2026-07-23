import 'package:eye/main.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:spark/spark.dart';

final pocketbaseRM = RM.inject(
  () => PocketBase(
    'http://127.0.0.1:8090',
    authStore: AsyncAuthStore(
      save: (value) async => await boxRM().put('authStore', value),
      initial: boxRM().get('authStore', defaultValue: null),
    ),
  ),
);
