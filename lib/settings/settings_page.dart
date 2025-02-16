import 'package:eye/authentication/login/login_page.dart';
import 'package:eye/authentication/user_profile.dart';
import 'package:eye/authentication/users/users_repository.dart';
import 'package:eye/dependency_injection.dart';
import 'package:eye/main.dart';
import 'package:forui/forui.dart';

final _settings = SettingsBloc();

class SettingsBloc extends Bloc {
  late final user = usersRepository.user;
  bool get dark => user().dark;
  String get themeModeName => user().themeMode.name.toUpperCase();

  void logout() {
    usersRepository.user(AppUser.none());
    navigation.toAndRemoveUntil(LoginPage());
  }

  void toggleDark() {
    user(user()..dark = !user().dark);
  }
}

class SettingsPage extends UI {
  const SettingsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return FScaffold(
      header: FHeader.nested(
        title: 'Settings'.text(),
        prefixActions: [
          FButton.icon(
            onPress: _settings.back,
            child: FIcon(FAssets.icons.arrowLeft),
          )
        ],
        suffixActions: [
          FButton.icon(
            child: FIcon(FAssets.icons.logOut),
            onPress: _settings.logout,
          ),
        ],
      ),
      content: Column(
        children: [
          FButton(
            prefix: FIcon(
              switch (_settings.dark) {
                false => FAssets.icons.sun,
                true => FAssets.icons.blocks,
              },
            ),
            onPress: _settings.toggleDark,
            label: _settings.themeModeName.text(),
          ).pad(),
          const UserProfilePage(),
        ],
      ),
    );
  }
}
