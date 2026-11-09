import 'package:eye/business/app_status_notifier.dart';
import 'package:eye/domain/repositories/superuser_repository.dart';
import 'package:eye/utils/pocketbase_config.dart';
import 'package:eye/utils/pocketbase_health.dart';
import 'package:eye/utils/infrastructure.dart';

final syncCloudReadinessRepositoryProvider = provider(
  () => SyncCloudReadinessRepository(
    pocketBaseConfigProvider(),
    appStatusNotifierProvider(),
    superuserRepositoryProvider(),
  ),
);

/// Health, admin credentials, and PocketBase schema gate before sync or cloud setup.
class SyncCloudReadinessRepository {
  SyncCloudReadinessRepository(
    this._config,
    this._status,
    this._superuser,
  );

  final PocketBaseConfig _config;
  final AppStatusNotifier _status;
  final SuperuserRepository _superuser;

  Future<bool> ensureReady() async {
    final reachable = await checkPocketBaseHealth(_config.baseUrl);
    _status.pocketBaseReachable.value = reachable;
    if (!reachable) {
      _config.refreshSetupRequired(cloudReachable: false);
      return false;
    }

    _config.refreshSetupRequired(cloudReachable: true);

    if (!_config.hasAdminCredentials) {
      return false;
    }

    if (_config.isSchemaCurrent) {
      _config.setupRequired.value = false;
      return true;
    }

    try {
      await _superuser.ensureSchema();
      _config.markSchemaProvisioned();
      _config.setupRequired.value = false;
      return true;
    } catch (_) {
      _config.clearSchemaProvisioned();
      _config.setupRequired.value = true;
      return false;
    }
  }
}
