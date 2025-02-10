import 'package:eye/authentication/user_progress.dart';
import 'package:eye/authentication/users/users_repository.dart';
import 'package:eye/dependency_injection.dart';
import 'package:eye/main.dart';
import 'package:forui/forui.dart';

import '../subscription/subscription_page.dart';
import 'login/login_page.dart';

final _userProfile = UserProfileBloc();

class UserProfileBloc extends Bloc {
  AppUser get user => usersRepository.currentUser;

  String get name => user.name;

  SubscriptionType get type => user.type;
  void setName(String value) {
    usersRepository.put(user..name = value);
  }

  void deleteProgress() {
    usersRepository.put(user..progress = UserProgress.none());
    showSheet('USER PROGRESS DELETED');
  }

  String get email {
    return user.email;
  }

  String password([String? value]) {
    return user.password;
  }

  void deleteAccount() async {
    usersRepository.remove(user.id);
    navigation.toAndRemoveUntil(LoginPage());
  }

  void showSheet(String info) {
    showFSheet(
      context: navigation.context,
      side: FLayout.btt,
      builder: (context) {
        Timer(
          2.seconds,
          navigation.back,
        );
        return FButton(
          label: Text(info),
          onPress: () => navigation.back(),
        ).pad().pad();
      },
    );
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
            initialValue: _userProfile.name,
            onChange: _userProfile.setName,
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
              onPress: () {
                _userProfile.deleteProgress();
              },
              label: 'DELETE PROGRESS'.text(),
            ),
            description: ''
                    'This action is irreversible.'
                .text(),
          ),
          FLabel(
            axis: Axis.vertical,
            label: 'DELETE ACCOUNT'.text(),
            child: FButton(
              style: FButtonStyle.destructive,
              onPress: () => _userProfile.deleteAccount(),
              label: 'DELETE ACCOUNT'.text(),
            ),
            description: ''
                    'This action will permanently '
                    'delete your account and '
                    'all your progress.'
                .text(),
          ),
        ],
      ).pad(),
    );
  }
}
