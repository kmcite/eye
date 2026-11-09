import 'package:eye/domain/repositories/superuser_repository.dart';
import 'package:eye/utils/infrastructure.dart';
import 'package:eye/utils/pocketbase_config.dart';

final superuserProvider = provider(
  () => SuperuserProvider(superuserRepositoryProvider()),
);

class SuperuserProvider {
  SuperuserProvider(this._repository);

  final SuperuserRepository _repository;

  final isLoggedIn = signal(false);
  final isBusy = signal(false);
  final error = nullSignal<Object>();

  Future<void> initialize() async {
    if (isLoggedIn()) return;
    await login();
  }

  Future<void> login() async {
    if (isBusy()) return;
    isBusy.value = true;
    error.value = null;
    try {
      await _repository.login();
      isLoggedIn.value = true;
    } catch (e) {
      error.value = e;
      rethrow;
    } finally {
      isBusy.value = false;
    }
  }

  Future<void> logout() async {
    if (!isLoggedIn()) return;
    await _repository.logout();
    isLoggedIn.value = false;
  }

  Future<void> ensureSchema() async {
    await initialize();
    await _repository.ensureSchema();
    pocketBaseConfigProvider().markSchemaProvisioned();
    pocketBaseConfigProvider().setupRequired.value = false;
  }
}
