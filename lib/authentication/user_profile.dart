import 'package:eye/authentication/user_progress.dart';
import 'package:eye/authentication/users/users_repository.dart';
import 'package:eye/dependency_injection.dart';
import 'package:eye/main.dart';
import 'package:forui/forui.dart';

import '../subscription/subscription_page.dart';
import 'login/login_page.dart';

final _userProfile = UserProfileBloc();

class UserProfileBloc extends Bloc {
  late final user = usersRepository.user;
  late final name = usersRepository.name;
  late final email = usersRepository.email;
  late final password = usersRepository.password;
  SubscriptionType get type => user().type;
  void deleteProgress() => usersRepository.progress(UserProgress.none());

  void deleteUser() {
    usersRepository.remove(user().id);
    navigation.toAndRemoveUntil(LoginPage());
  }
}

class UserProfilePage extends UI {
  const UserProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        spacing: 16,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FTextField(
            label: 'NAME'.text(),
            initialValue: _userProfile.name(),
            onChange: _userProfile.name,
            description: _userProfile.email.text(),
          ),
          FLabel(
            axis: Axis.vertical,
            label: 'SUBSCRIPTIONS'.text(),
            child: FButton(
              prefix: FIcon(FAssets.icons.squareCheckBig),
              label: _userProfile.type.displayName.text(),
              onPress: () => _userProfile.to(SubscriptionPage()),
            ),
            description: 'Go to subscriptions page.'.text(),
          ),
          FLabel(
            axis: Axis.vertical,
            label: 'DELETE PROGRESS'.text(),
            child: FButton(
              style: FButtonStyle.destructive,
              onPress: _userProfile.deleteProgress,
              label: 'DELETE PROGRESS'.text(),
            ),
            description: 'This action is irreversible.'.text(),
          ),
          FLabel(
            axis: Axis.vertical,
            label: 'DELETE USER'.text(),
            child: FButton(
              style: FButtonStyle.destructive,
              onPress: _userProfile.deleteUser,
              label: 'DELETE USER'.text(),
            ),
            description: _deleteAction.text(),
          ),
        ],
      ).pad(),
    );
  }
}

const _deleteAction = ''
    'This action will permanently '
    'delete your account and '
    'all your progress.';
