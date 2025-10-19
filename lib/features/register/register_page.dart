import 'package:eye/domain/api/user_repository.dart';
import 'package:eye/domain/models/app_user.dart';
import 'package:eye/domain/api/login_register_repository.dart';
import 'package:eye/domain/api/users_repository.dart';
import 'package:eye/features/login/login_page.dart';
import 'package:eye/main.dart';
import 'package:eye/utils/api.dart';

mixin Validators on RegisterBloc {
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
    if (exists) {
      errors.add('$email already exists');
    }

    return errors.isEmpty ? null : errors.join(', ');
  }
}

mixin RegisterBloc {
  final name = loginRegisterRepository.name;
  final email = loginRegisterRepository.email;
  final password = loginRegisterRepository.password;

  void register() {
    if (email().isEmpty || password().isEmpty || name().isEmpty) {
      return;
    }

    if (exists) {
      navigator.toAndRemoveUntil(LoginPage());
      return;
    }

    final user = AppUser()
      ..name = name()
      ..email = email()
      ..password = password();
    usersRepository.put(user);
    userRepository.userId(user.id);
    // navigator.toAndRemoveUntil(HomePage());
    navigator.back();
  }

  // bool get authenticated => userRepository.authenticated;
  bool get exists => usersRepository.isEmailExists(email());
}

class RegisterPage extends UI with RegisterBloc, Validators {
  RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FScaffold(
      header: FHeader.nested(
        prefixes: [
          FHeaderAction.back(onPress: navigator.back),
        ],
        title: Text('Register'),
        suffixes: [
          FHeaderAction(
            icon: Icon(FIcons.info),
            onPress: () {
              // navigator.to(UsersPage());
            },
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FTextField(
            initialText: name(),
            onChange: name,
            label: 'Name'.text(),
            // validator: validateName,
            // autovalidateMode: AutovalidateMode.always,
          ).pad(),
          FTextField(
            initialText: email(),
            onChange: email,
            label: 'Email'.text(),
            // validator: validateEmail,
            // autovalidateMode: AutovalidateMode.always,
          ).pad(),
          FTextField(
            initialText: password(),
            onChange: password,
            label: 'Password'.text(),
          ).pad(),
          FButton(
            onPress: exists ? null : register,
            child: 'Register'.text(),
          ).pad(),
        ],
      ),
    );
  }
}
