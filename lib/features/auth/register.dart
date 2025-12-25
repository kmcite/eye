import 'package:eye/domain/api/users.dart';
import 'package:eye/domain/validators.dart';
import 'package:eye/features/auth/authentication_state.dart';
import 'package:eye/main.dart';
import 'package:manager/extensions.dart';
import 'package:yaru/yaru.dart';

class RegisterView extends UI {
  static String route = '/register';
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 8,
        children: [
          TextFormField(
            controller: nameField.controller,
            decoration: InputDecoration(
              labelText: 'Name',
            ),
            validator: validateName,
            autovalidateMode: AutovalidateMode.always,
          ),
          TextFormField(
            controller: emailField.controller,
            decoration: InputDecoration(
              labelText: 'Email',
            ),
            validator: validateEmailRegisteration,
            autovalidateMode: AutovalidateMode.always,
          ),
          TextFormField(
            controller: passwordField.controller,
            decoration: InputDecoration(
              labelText: 'Password',
            ),
            validator: validatePassword,
            autovalidateMode: AutovalidateMode.always,
          ),
          if (users.loading)
            YaruCircularProgressIndicator()
          else
            ElevatedButton(
              onPressed: users.isEmailExists(emailField.value)
                  ? null
                  : register,
              child: 'Register'.text(),
            ),
        ],
      ),
    );
  }
}
