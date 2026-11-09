import 'package:eye/business/app_status_notifier.dart';
import 'package:eye/domain/repositories/sync_readiness.dart';
import 'package:eye/domain/repositories/sync_repository.dart';
import 'package:eye/domain/repositories/superuser_repository.dart';
import 'package:eye/utils/infrastructure.dart';
import 'package:eye/utils/pocketbase.dart';
import 'package:eye/utils/pocketbase_config.dart';
import 'package:eye/utils/pocketbase_errors.dart';
import 'package:eye/utils/pocketbase_health.dart';
import 'package:pocketbase/pocketbase.dart';

final cloudBootstrapNotifierProvider = provider(
  () => CloudBootstrapNotifier(
    config: pocketBaseConfigProvider(),
    pocketBase: pocketBaseProvider(),
    superuser: superuserRepositoryProvider(),
    appStatus: appStatusNotifierProvider(),
    cloudReadiness: syncCloudReadinessRepositoryProvider(),
    onSyncClientsInvalidated: () {
      invalidateProvider(syncRepositoryProvider);
      invalidateProvider(superuserRepositoryProvider);
      reloadPocketBaseClient();
    },
  ),
);

class CloudBootstrapNotifier {
  CloudBootstrapNotifier({
    required PocketBaseConfig config,
    required PocketBase pocketBase,
    required SuperuserRepository superuser,
    required AppStatusNotifier appStatus,
    required SyncCloudReadinessRepository cloudReadiness,
    required void Function() onSyncClientsInvalidated,
  }) : _config = config,
       _pocketBase = pocketBase,
       _superuser = superuser,
       _appStatus = appStatus,
       _cloudReadiness = cloudReadiness,
       _onSyncClientsInvalidated = onSyncClientsInvalidated;

  final PocketBaseConfig _config;
  final PocketBase _pocketBase;
  final SuperuserRepository _superuser;
  final AppStatusNotifier _appStatus;
  final SyncCloudReadinessRepository _cloudReadiness;
  final void Function() _onSyncClientsInvalidated;

  final busy = signal(false);
  final lastError = nullSignal<Object>();

  /// PocketBase reachable, admin creds set, and sync schema provisioned.
  Future<bool> ensureSyncCloudReady() => _cloudReadiness.ensureReady();

  Future<void> completeSetup({
    required String baseUrl,
    required String adminEmail,
    required String adminPassword,
  }) async {
    busy.value = true;
    lastError.value = null;
    try {
      _config.setBaseUrl(baseUrl);
      _config.setAdminCredentials(email: adminEmail, password: adminPassword);
      _onSyncClientsInvalidated();

      _pocketBase.authStore.clear();
      _config.clearSchemaProvisioned();

      final url = _config.baseUrl;
      if (!await checkPocketBaseHealth(url)) {
        throw StateError(
          'Cannot reach PocketBase at $url. '
          'Confirm Termux is running `./pocketbase serve` and the URL is correct '
          '(on this device try $defaultPocketBaseBaseUrl).',
        );
      }

      try {
        await _superuser.ensureSchema();
      } catch (e) {
        throw StateError(pocketBaseErrorMessage(e));
      }

      _config.markSchemaProvisioned();
      _config.setupRequired.value = false;
      await _appStatus.refresh();
      await ensureSyncCloudReady();
    } catch (e) {
      lastError.value = e;
      rethrow;
    } finally {
      busy.value = false;
    }
  }
}
