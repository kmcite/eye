import 'package:eye/authentication/users/new_user_dialog.dart';
import 'package:eye/authentication/users/users_repository.dart';
import 'package:eye/dependency_injection.dart';
import 'package:eye/main.dart';
import 'package:forui/forui.dart';

import '../../dashboard/dashboard_page.dart';

final _users = UsersBloc();

class UsersBloc extends Bloc {
  Iterable<AppUser> get users => usersRepository.getAll();

  void login(AppUser user) {
    usersRepository.user(user);
    navigation.toAndRemoveUntil(DashboardPage());
  }

  void remove(AppUser user) {
    usersRepository.remove(user.id);
  }

  late var back = navigation.back;

  void createNewUser() async {
    final result = await navigation.dialog<AppUser>(NewUserDialog());
    if (result != null) {
      usersRepository.put(result);
    }
  }
}

class UsersPage extends UI {
  @override
  Widget build(BuildContext context) {
    return FScaffold(
      header: FHeader.nested(
        title: 'Users'.text(),
        prefixActions: [
          FHeaderAction.back(
            onPress: _users.back,
          ),
        ],
        suffixActions: [
          FHeaderAction(
            icon: FIcon(FAssets.icons.creativeCommons),
            onPress: _users.createNewUser,
          ),
        ],
      ),
      content: FTileGroup.builder(
        label: 'Users'.text(),
        maxHeight: 500,
        divider: FTileDivider.full,
        count: _users.users.length,
        tileBuilder: (context, index) {
          final user = _users.users.elementAt(index);
          return FTile(
            title: FBadge(
              label: user.name.text(),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                user.email.text(),
                user.password.text(),
              ],
            ),
            suffixIcon: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                FButton.icon(
                  onPress: () {
                    _users.login(user);
                  },
                  child: FIcon(FAssets.icons.logIn),
                  style: FButtonStyle.primary,
                ),
                SizedBox(width: 4),
                FButton.icon(
                  onPress: () {
                    _users.remove(user);
                  },
                  child: FIcon(FAssets.icons.delete),
                  style: FButtonStyle.destructive,
                ),
              ],
            ),
          );
        },
      ).pad(),
    );
  }
}
