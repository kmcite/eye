import 'package:eye/business/authentication_state.dart';
import 'package:eye/business/validators.dart';
import 'package:eye/utils/ui.dart';
import 'package:flutter/material.dart';

class RegisterView extends UI {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    final authentication = authenticationSpark();
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 8,
        children: [
          TextFormField(
            initialValue: authentication.name,
            // onChanged: authentication.name.set,
            decoration: InputDecoration(
              labelText: 'Name',
            ),
            validator: validateName,
            autovalidateMode: AutovalidateMode.always,
          ),
          TextFormField(
            initialValue: authentication.email,
            // onChanged: authentication.email.set,
            decoration: InputDecoration(
              labelText: 'Email',
            ),
            validator: (value) => validateEmailRegisteration(
              value,
              () => true,
            ),
            autovalidateMode: AutovalidateMode.always,
          ),
          TextFormField(
            initialValue: authentication.password,
            // onChanged: authentication.password.set,
            decoration: InputDecoration(
              labelText: 'Password',
            ),
            validator: validatePassword,
            autovalidateMode: AutovalidateMode.always,
          ),

          ElevatedButton(
            onPressed: authentication.isUserEmailExists ? null : () => authentication.register(),
            child: Text('Register'),
          ),
        ],
      ),
    );
  }
}
