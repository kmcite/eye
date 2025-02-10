import 'package:eye/dependency_injection.dart';
import 'package:eye/main.dart';
import 'package:forui/forui.dart';

import '../../dashboard/dashboard_page.dart';
import '../register/register_page.dart';

final _login = LoginBloc();

class LoginBloc extends Bloc {
  late final email = loginRegisterRepository.email;
  late final password = loginRegisterRepository.password;

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

  void login() {
    final authentic = usersRepository.authenticated(email(), password());
    if (authentic) {
      final user = usersRepository.getByEmail(email());
      usersRepository.setCurrentUser(user!);
      navigation.toAndRemoveUntil(DashboardPage());
    } else {
      to(RegisterPage());
    }
  }
}

class LoginPage extends UI {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FScaffold(
      header: FHeader(title: Text('Login')),
      content: Column(
        children: [
          FTextField.email(
            initialValue: _login.email(),
            onChange: _login.email,
            hint: 'adn@gmail.com',
            validator: _login.validateEmail,
            autovalidateMode: AutovalidateMode.always,
          ).pad(),
          FTextField.password(
            initialValue: _login.password(),
            onChange: _login.password,
          ).pad(),
          Row(
            children: [
              FButton.icon(
                style: FButtonStyle.primary,
                onPress: _login.validateEmail(_login.email()) == null
                    ? _login.login
                    : null,
                child: 'Login'.text(),
              ).pad(),
              FButton.icon(
                onPress: () => _login.to(RegisterPage()),
                child: 'New? Register'.text(),
              ).pad(),
            ],
          )
        ],
      ),
    );
  }
}
