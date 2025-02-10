import 'package:eye/authentication/login/login_page.dart';
import 'package:eye/authentication/user_profile.dart';
import 'package:eye/authentication/users/users_repository.dart';
import 'package:eye/dependency_injection.dart';
import 'package:eye/main.dart';
import 'package:forui/forui.dart';

final _settings = SettingsBloc();

class SettingsBloc extends Bloc {
  bool get isDark => themeMode() == ThemeMode.dark;
  String get themeModeName => themeMode().name.toUpperCase();

  void logout() {
    usersRepository.setCurrentUser(AppUser.logout());
    navigation.toAndRemoveUntil(LoginPage());
  }

  ThemeMode themeMode() {
    return usersRepository.currentUser.themeMode;
  }

  void toggleThemeMode() {
    final user = usersRepository.currentUser;
    usersRepository.put(
      user
        ..themeMode =
            themeMode() == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark,
    );
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
              switch (_settings.isDark) {
                false => FAssets.icons.sun,
                true => FAssets.icons.blocks,
              },
            ),
            onPress: _settings.toggleThemeMode,
            label: _settings.themeModeName.text(),
          ).pad(),
          const UserProfilePage(),
        ],
      ),
    );
  }
}
