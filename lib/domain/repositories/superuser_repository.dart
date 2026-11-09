import 'package:eye/domain/repositories/sync_events.dart';
import 'package:eye/utils/infrastructure.dart';
import 'package:eye/utils/pocketbase.dart';
import 'package:eye/utils/pocketbase_config.dart';
import 'package:pocketbase/pocketbase.dart';

final superuserRepositoryProvider = provider(
  () => SuperuserRepository(
    pocketBaseProvider(),
    pocketBaseConfigProvider(),
  ),
);

class SuperuserRepository {
  SuperuserRepository(this.pb, this._config);

  final PocketBase pb;
  final PocketBaseConfig _config;

  bool get isLoggedIn => pb.authStore.isValid;

  Future<void> login() async {
    if (isLoggedIn) return;

    final email = _config.adminEmail;
    final password = _config.adminPassword;
    if (email == null || password == null) {
      throw StateError('PocketBase admin credentials are not configured.');
    }
    await pb.admins.authWithPassword(email, password);
  }

  Future<void> logout() async {
    pb.authStore.clear();
  }

  Future<void> ensureSchema() async {
    await login();
    await ensureSyncEventsCollection();
  }

  Future<void> ensureSyncEventsCollection() async {
    try {
      await pb.collections.getOne(syncEventsCollection);
      return;
    } catch (_) {}

    await pb.collections.create(
      body: {
        'name': syncEventsCollection,
        'type': 'base',
        'fields': [
          _textField('deviceId', required: true),
          _textField('entityType', required: true),
          _textField('entityKey', required: true),
          _textField('operation', required: true),
          _jsonField('payload', required: true),
        ],
      },
    );
  }

  static Map<String, dynamic> _textField(String name, {bool required = false}) {
    return {
      'name': name,
      'type': 'text',
      'required': required,
      'presentable': false,
      'unique': false,
      'options': {'min': null, 'max': null, 'pattern': ''},
    };
  }

  static Map<String, dynamic> _jsonField(String name, {bool required = false}) {
    return {
      'name': name,
      'type': 'json',
      'required': required,
      'presentable': false,
      'unique': false,
      'options': {'maxSize': 2000000},
    };
  }
}
