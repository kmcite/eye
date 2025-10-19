import 'package:eye/domain/models/app_user.dart';
import 'package:eye/main.dart';

final usersRepository = UsersRepository();

class UsersRepository extends CRUD<AppUser> {
  AppUser? getByEmail(String email) {
    final result = getAll().where((user) => user.email == email);
    return result.firstOrNull;
  }

  bool authenticated(String email, String password) {
    final user = getByEmail(email);
    final result = user != null && user.password == password;
    return result;
  }

  bool isEmailExists(String email) {
    final result = getByEmail(email) != null;
    return result;
  }
}
