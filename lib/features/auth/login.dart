import 'package:eye/domain/validators.dart';
import 'package:eye/features/auth/authentication_state.dart';
import 'package:eye/main.dart';
import 'package:manager/manager.dart';
import 'package:yaru/widgets.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: .stretch,
        spacing: 8,
        children: [
          TextFormField(
            controller: emailField.controller,
            validator: validateEmailForLogin,
            autovalidateMode: AutovalidateMode.always,
            decoration: InputDecoration(labelText: 'Email'),
          ),
          TextFormField(
            controller: passwordField.controller,
            validator: validatePassword,
            autovalidateMode: AutovalidateMode.always,
            decoration: InputDecoration(labelText: 'Password'),
          ),
          if (loadingRM.state)
            YaruCircularProgressIndicator()
          else
            ElevatedButton(
              onPressed: validateEmailForLogin(emailField.value) == null
                  ? authenticate
                  : null,
              child: 'Login'.text(),
            ),
        ],
      ),
    );
  }
}
