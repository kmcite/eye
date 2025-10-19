import 'package:eye/domain/api/login_register_repository.dart';
import 'package:eye/domain/api/user_repository.dart';
import 'package:eye/domain/api/users_repository.dart';
import 'package:eye/features/register/register_page.dart';
import 'package:eye/utils/api.dart';
import 'package:eye/main.dart';

import 'failed_login_dialog.dart';

String? validateEmail(String? email) {
  if (email == null || email.isEmpty) {
    return 'Email cannot be empty';
  }

  List<String> errors = [];

  if (!email.contains('@')) {
    errors.add('Email should contain "@"');
  }
  return errors.isEmpty ? null : errors.join(', ');
}

String? validatePassword(String? password) {
  if (password == null || password.isEmpty) {
    return 'Password cannot be empty';
  }
  if (password.length < 4) {
    return 'Password must be at least 4 characters long';
  }
  return null;
}

final email = loginRegisterRepository.email;

final password = loginRegisterRepository.password;
void login() async {
  final authenticated = usersRepository.authenticated(email(), password());
  if (authenticated) {
    final user = usersRepository.getByEmail(email());
    userRepository.userId(user!.id);
    // navigator.toAndRemoveUntil(HomePage());
  } else {
    navigator.toDialog(
      FailedLoginDialog(),
    );
  }
}

class LoginPage extends UI {
  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FScaffold(
      header: FHeader(title: Text('Login')),
      child: Column(
        children: [
          FTextField.email(
            initialText: email(),
            onChange: email,
            hint: 'adn@gmail.com',
            // validator: validateEmail,
            // autovalidateMode: AutovalidateMode.always,
          ).pad(),
          FTextField.password(
            initialText: password(),
            onChange: password,
          ).pad(),
          Row(
            children: [
              FButton.icon(
                style: FButtonStyle.primary,
                onPress: validateEmail(email()) == null ? login : null,
                child: 'Login'.text(),
              ).pad(),
              FButton.icon(
                onPress: () {
                  navigator.to(RegisterPage());
                },
                child: 'New? Register'.text(),
              ).pad(),
            ],
          ),
        ],
      ),
    );
  }
}
