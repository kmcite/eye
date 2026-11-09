import 'package:eye/domain/repositories/users_repository.dart';
import 'package:eye/domain/models/app_user.dart';
import 'package:eye/utils/infrastructure.dart';

final usersNotifierProvider = provider(
  () => UsersNotifier(
    usersRepositoryProvider(),
  ),
);

class UsersNotifier(
  final UsersRepository usersRepository,
) {
  final users = signal(<AppUser>[]);
  final loading = signal(false);
  final error = signal('');

  Future<void> loadUsers() async {
    loading.value = true;
    error.value = '';
    try {
      users.value = await usersRepository.getUsers();
    } catch (e) {
      error.value = e.toString().replaceAll('Exception: ', '');
    } finally {
      loading.value = false;
    }
  }

  Future<void> remove(int id) async {
    error.value = '';
    try {
      await usersRepository.deleteUser(id);
      users.value = users().where((u) => u.id != id).toList();
    } catch (e) {
      error.value = e.toString().replaceAll('Exception: ', '');
    }
  }
}
