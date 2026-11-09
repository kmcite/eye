import 'dart:async';
import 'dart:io';

import 'package:eye/domain/models/sync_outbox_entry.dart';
import 'package:eye/utils/infrastructure.dart';
import 'package:eye/utils/objectbox.dart';
import 'package:eye/utils/pocketbase_config.dart';
import 'package:eye/utils/pocketbase_health.dart';

final appStatusNotifierProvider = provider(
  () => AppStatusNotifier(pocketBaseConfigProvider()),
);

class AppStatusNotifier {
  AppStatusNotifier(this._config);

  final PocketBaseConfig _config;
  static const _poll = Duration(seconds: 8);

  final networkOnline = signal(true);
  final pocketBaseReachable = signal(false);
  final syncQueueCount = signal(0);
  final syncActive = signal(false);

  Timer? _timer;

  void start() {
    _timer?.cancel();
    unawaited(refresh());
    _timer = Timer.periodic(_poll, (_) => unawaited(refresh()));
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
  }

  void refreshQueueCount() {
    syncQueueCount.value = objectBox<SyncOutboxEntry>().count();
  }

  void setSyncActive(bool active) {
    syncActive.value = active;
  }

  Future<void> refresh() async {
    refreshQueueCount();
    await Future.wait([
      _checkNetwork(),
      _checkPocketBase(),
    ]);
  }

  Future<void> _checkNetwork() async {
    try {
      final result = await InternetAddress.lookup(
        'one.one.one.one',
      ).timeout(const Duration(seconds: 4));
      networkOnline.value =
          result.isNotEmpty && result.first.rawAddress.isNotEmpty;
    } catch (_) {
      networkOnline.value = false;
    }
  }

  Future<void> _checkPocketBase() async {
    final base = _config.baseUrl;
    pocketBaseReachable.value = await checkPocketBaseHealth(base);
    _config.refreshSetupRequired(
      cloudReachable: pocketBaseReachable(),
    );
  }
}
