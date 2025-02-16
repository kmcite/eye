import 'package:eye/authentication/users/users_repository.dart';
import 'package:eye/main.dart';
import 'package:forui/forui.dart';

import '../../dashboard/dashboard_page.dart';
import '../../dependency_injection.dart';
import '../login/login_page.dart';
import '../users/users_page.dart';

final _register = RegisterBloc();

class RegisterBloc extends Bloc {
  String? validateName(String? name) {
    if (name == null || name.isEmpty) {
      return 'Name cannot be empty';
    }
    if (name.length < 4) {
      return 'Name must be at least 4 characters long';
    }
    return null;
  }

  String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return 'Email cannot be empty';
    }

    List<String> errors = [];

    if (!email.contains('@')) {
      errors.add('Email should contain "@"');
    }
    if (usersRepository.isEmailExists(email)) {
      errors.add('$email already exists');
    }

    return errors.isEmpty ? null : errors.join(', ');
  }

  late final name = loginRegisterRepository.name;
  late final email = loginRegisterRepository.email;
  late final password = loginRegisterRepository.password;

  void register() {
    final userEmail = email();
    final userPassword = password();
    final userName = name();

    if (userEmail.isEmpty || userPassword.isEmpty || userName.isEmpty) {
      return;
    }

    if (usersRepository.isEmailExists(userEmail)) {
      navigation.toAndRemoveUntil(LoginPage());
      return;
    }

    final user = AppUser()
      ..name = userName
      ..email = userEmail
      ..password = userPassword;

    usersRepository.put(user);
    usersRepository.user(user);
    navigation.toAndRemoveUntil(
      DashboardPage(),
    );
  }

  bool get authentic => usersRepository.user().valid;

  bool get exists => usersRepository.isEmailExists(email());
}

class RegisterPage extends UI {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FScaffold(
      header: FHeader.nested(
        prefixActions: [
          FHeaderAction.back(onPress: _register.back),
        ],
        title: Text('Register'),
        suffixActions: [
          FHeaderAction(
            icon: FIcon(FAssets.icons.info),
            onPress: () => _register.to(UsersPage()),
          ),
        ],
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FTextField(
            initialValue: _register.name(),
            onChange: _register.name,
            label: 'Name'.text(),
            validator: _register.validateName,
            autovalidateMode: AutovalidateMode.always,
          ).pad(),
          FTextField(
            initialValue: _register.email(),
            onChange: _register.email,
            label: 'Email'.text(),
            validator: _register.validateEmail,
            autovalidateMode: AutovalidateMode.always,
          ).pad(),
          FTextField(
            initialValue: _register.password(),
            onChange: _register.password,
            label: 'Password'.text(),
          ).pad(),
          FButton(
            onPress: _register.exists ? null : _register.register,
            label: 'Register'.text(),
          ).pad(),
        ],
      ),
    );
  }
}
