import 'package:eye/domain/models/app_user.dart';
import 'package:eye/features/home/home.dart';
import 'package:eye/features/auth/authentication.dart';
import 'package:eye/utils/object_box.dart';
import 'package:eye/utils/router.dart';

import '../../main.dart';

/// SOURCE OF TRUTH
final authenticationRM = RM.inject<int?>(
  () => null,
  persist: () => PersistState(key: 'id'),
  sideEffects: SideEffects(
    onSetState: (snap) {
      if (snap.state == null) {
        router.toAndRemoveUntil(AutheticationPage.route);

        /// also refresh login state
      } else {
        router.toAndRemoveUntil(HomePage.route);
      }
    },
  ),
  debugPrintWhenNotifiedPreMessage: 'AUTHENTICATION|ID',
);

/// STATE MANAGER

bool get authenticated => authentication != null;
int? get authentication => authenticationRM.state;
AppUser? get safeUser => users.getById(authentication ?? -1);

final users = Users();

class Users with ObjectBox<AppUser> {
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
