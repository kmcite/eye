import 'package:eye/authentication/users/users_repository.dart';
import 'package:eye/dependency_injection.dart';
import 'package:eye/main.dart';
import 'package:forui/forui.dart';

import '../user_progress.dart';

final _newUser = NewUserBloc();

class NewUserBloc extends Bloc {
  final userRM = RM.inject(() => AppUser());
  AppUser user([AppUser? value]) {
    if (value != null) {
      userRM
        ..state = value
        ..notify();
    }
    return userRM.state;
  }

  String name([String? value]) {
    if (value != null) {
      user(user()..name = value);
    }
    return user().name;
  }

  String email([String? value]) {
    if (value != null) {
      user(user()..email = value);
    }
    return user().email;
  }

  String password([String? value]) {
    if (value != null) {
      user(user()..password = value);
    }
    return user().password;
  }

  UserProgress get progress => user().progress;
  set progress(UserProgress value) {
    user(user()..progress = value);
  }

  SubscriptionType type([SubscriptionType? value]) {
    if (value != null) {
      user(user()..type = value);
    }
    return user().type;
  }

  late var back = navigation.back;
  void save() {
    back(user());
  }
}

class NewUserDialog extends UI {
  @override
  Widget build(BuildContext context) {
    return FDialog(
      title: 'New User Dialog'.text(),
      body: Column(
        children: [
          FTextField(
            label: 'Name'.text(),
            initialValue: _newUser.name(),
            onChange: _newUser.name,
          ),
          FTextField(
            label: 'Email'.text(),
            initialValue: _newUser.email(),
            onChange: _newUser.email,
          ),
          FTextField(
            label: 'Password'.text(),
            initialValue: _newUser.password(),
            onChange: _newUser.password,
          ),
          FTileGroup(
            label: 'Subscription'.text(),
            maxHeight: 100,
            divider: FTileDivider.full,
            children: SubscriptionType.values.map(
              (type) {
                return FTile(
                  suffixIcon: type == _newUser.type()
                      ? FIcon(FAssets.icons.check)
                      : null,
                  title: type.displayName.text(),
                  onPress: () => _newUser.user(),
                );
              },
            ).toList(),
          ),
        ],
      ),
      actions: [
        FButton(
          onPress: () => _newUser.save(),
          label: 'Save'.text(),
        ),
        FButton(
          onPress: () => _newUser.back(),
          label: 'Cancel'.text(),
        ),
      ],
    );
  }
}
