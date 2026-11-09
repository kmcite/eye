import 'package:eye/utils/hive_box.dart';
import 'package:eye/utils/infrastructure.dart';
import 'package:eye/utils/pocketbase_config.dart';
import 'package:pocketbase/pocketbase.dart';

final pocketBaseProvider = provider(
  () => PocketBase(
    pocketBaseConfigProvider().baseUrl,
    authStore: _authStoreProvider(),
  ),
);

void reloadPocketBaseClient() {
  invalidateProvider(pocketBaseProvider);
}

final _authStoreProvider = provider(
  () => AsyncAuthStore(
    save: (data) async => hiveBoxProvider().put('pb_auth', data),
    initial: hiveBoxProvider().get('pb_auth') as String?,
  ),
);
