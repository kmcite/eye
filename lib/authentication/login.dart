import 'package:eye/business/authentication_state.dart';
import 'package:eye/business/validators.dart';
import 'package:eye/utils/ui.dart';
import 'package:flutter/material.dart';
import 'package:yaru/widgets.dart';

class LoginView extends UI {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final authentication = authenticationSpark();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 8,
        children: [
          TextFormField(
            initialValue: authentication.email,
            onChanged: (value) => authenticationSpark((a) => a.onEmailChanged(value)),
            validator: (value) => validateEmailForLogin(
              value,
              () => authentication.authenticated,
            ),
            autovalidateMode: AutovalidateMode.always,
            decoration: InputDecoration(labelText: 'Email'),
          ),
          TextFormField(
            initialValue: authentication.password,
            onChanged: (value) => authenticationSpark((a) => a.onPasswordChanged(value)),
            validator: validatePassword,
            autovalidateMode: AutovalidateMode.always,
            decoration: InputDecoration(labelText: 'Password'),
          ),
          if (authentication.loading)
            YaruCircularProgressIndicator()
          else
            ElevatedButton(
              onPressed:
                  validateEmailForLogin(
                        authentication.email,
                        () => authentication.authenticated,
                      ) ==
                      null
                  ? () => authentication.login()
                  : null,
              child: Text('Login'),
            ),
        ],
      ),
    );
  }
}
