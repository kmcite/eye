import 'package:eye/domain/api/users.dart';

String? validateEmailRegisteration(String? email) {
  List<String> errors = [];
  if (email != null) {
    if (users.isEmailExists(email)) {
      errors.add('Email already exists');
    }

    if (email.isEmpty) {
      errors.add('Email cannot be empty');
    }
  }

  if (!email!.contains('@')) {
    errors.add('Email should contain "@"');
  }
  return errors.isEmpty ? null : errors.join(', ');
}

String? validateEmailForLogin(String? email) {
  List<String> errors = [];
  if (email != null) {
    if (email.isEmpty) {
      errors.add('Email cannot be empty');
    }
    if (!users.isEmailExists(email)) {
      errors.add('Email does not exist');
    }
  }
  if (!email!.contains('@')) {
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

String? validateName(String? name) {
  if (name == null || name.isEmpty) {
    return 'Name cannot be empty';
  }
  if (name.length < 4) {
    return 'Name must be at least 4 characters long';
  }
  return null;
}
