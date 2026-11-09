import 'package:eye/utils/hive_box.dart';
import 'package:eye/utils/infrastructure.dart';
import 'package:eye/utils/pocketbase_health.dart';

const pocketBaseSchemaVersion = 1;

const _keyBaseUrl = 'pb_base_url';
const _keyAdminEmail = 'pb_admin_email';
const _keyAdminPassword = 'pb_admin_password';
const _keySchemaVersion = 'pb_schema_version';

const defaultPocketBaseBaseUrl = 'http://127.0.0.1:8090';

final pocketBaseConfigProvider = provider(() => PocketBaseConfig());

class PocketBaseConfig {
  final setupRequired = signal(false);

  dynamic get _box => hiveBoxProvider();

  String get baseUrl {
    final stored = _box.get(_keyBaseUrl) as String?;
    if (stored == null || stored.trim().isEmpty) return defaultPocketBaseBaseUrl;
    return normalizePocketBaseUrl(stored);
  }

  String? get adminEmail {
    final v = _box.get(_keyAdminEmail) as String?;
    return v == null || v.trim().isEmpty ? null : v.trim();
  }

  String? get adminPassword {
    final v = _box.get(_keyAdminPassword) as String?;
    return v == null || v.isEmpty ? null : v;
  }

  bool get hasAdminCredentials =>
      adminEmail != null && adminPassword != null;

  int get schemaVersion => _box.get(_keySchemaVersion) as int? ?? 0;

  bool get isSchemaCurrent => schemaVersion >= pocketBaseSchemaVersion;

  void setBaseUrl(String url) {
    _box.put(_keyBaseUrl, normalizePocketBaseUrl(url));
  }

  void setAdminCredentials({required String email, required String password}) {
    _box.put(_keyAdminEmail, email.trim());
    _box.put(_keyAdminPassword, password);
  }

  void markSchemaProvisioned() {
    _box.put(_keySchemaVersion, pocketBaseSchemaVersion);
  }

  void clearSchemaProvisioned() {
    _box.put(_keySchemaVersion, 0);
  }

  void refreshSetupRequired({required bool cloudReachable}) {
    if (!cloudReachable) {
      setupRequired.value = false;
      return;
    }
    setupRequired.value = !hasAdminCredentials || !isSchemaCurrent;
  }
}
