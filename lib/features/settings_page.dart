import 'package:eye/domain/api/user_repository.dart';
import 'package:eye/domain/models/app_user.dart';
import 'package:eye/domain/api/users_repository.dart';
import 'package:eye/features/login/login_page.dart';
import 'package:eye/main.dart';
import 'package:eye/utils/api.dart';
import 'package:manager/dark/dark_repository.dart';

mixin class SettingsBloc {
  AppUser get user =>
      //  usersRepository.one(userRepository.id) ??
      AppUser();
  void updateUser(AppUser user) => usersRepository.put(user);

  bool get dark => user.dark;
  String get themeModeName => user.themeMode.name.toUpperCase();

  void logout() {
    userRepository.userId(null);
    navigator.toAndRemoveUntil(LoginPage());
  }

  void toggleDark() {
    // updateUser(user..dark = !user.dark);
    darkRepository.state = !_dark;
  }
}

bool get _dark => darkRepository.state;

class SettingsPage extends UI with SettingsBloc {
  const SettingsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return FScaffold(
      header: FHeader.nested(
        title: 'Settings'.text(),
        prefixes: [
          FButton.icon(
            onPress: navigator.back,
            child: Icon(FIcons.arrowLeft),
          ),
        ],
        suffixes: [
          FButton.icon(
            child: Icon(FIcons.logOut),
            onPress: logout,
          ),
        ],
      ),
      child: Column(
        children: [
          FButton(
            prefix: Icon(switch (_dark) {
              false => FIcons.sun,
              true => FIcons.moon,
            }),
            onPress: toggleDark,
            child: themeModeName.text(),
          ).pad(),
          // const UserProfilePage(),
        ],
      ),
    );
  }
}
