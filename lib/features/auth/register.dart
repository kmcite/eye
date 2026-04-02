import 'package:eye/business/users.dart';
import 'package:eye/domain/validators.dart';
import 'package:eye/features/auth/authentication_state.dart';
import 'package:eye/main.dart';

class RegisterView extends UI {
  static String route = '/register';
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 8,
        children: [
          TextFormField(
            initialValue: nameField(),
            onChanged: nameField,
            decoration: InputDecoration(
              labelText: 'Name',
            ),
            validator: validateName,
            autovalidateMode: AutovalidateMode.always,
          ),
          TextFormField(
            initialValue: emailField(),
            onChanged: emailField,
            decoration: InputDecoration(
              labelText: 'Email',
            ),
            validator: validateEmailRegisteration,
            autovalidateMode: AutovalidateMode.always,
          ),
          TextFormField(
            initialValue: passwordField(),
            onChanged: passwordField,
            decoration: InputDecoration(
              labelText: 'Password',
            ),
            validator: validatePassword,
            autovalidateMode: AutovalidateMode.always,
          ),

          ElevatedButton(
            onPressed: isUserEmailExists().choose(null, register),
            child: Text('Register'),
          ),
        ],
      ),
    );
  }
}
