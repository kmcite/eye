String? validateEmailRegistration(
  String? email,
  bool Function() isUserEmailRegistered,
) {
  if (email == null || email.trim().isEmpty) {
    return 'Email cannot be empty';
  }
  if (!email.contains('@')) {
    return 'Email should contain "@"';
  }
  if (isUserEmailRegistered()) {
    return 'Email already exists';
  }
  return null;
}

String? validateEmailForLogin(
  String? email,
  bool Function() isUserEmailRegistered,
) {
  if (email == null || email.trim().isEmpty) {
    return 'Email cannot be empty';
  }
  if (!email.contains('@')) {
    return 'Email should contain "@"';
  }
  if (!isUserEmailRegistered()) {
    return 'Email does not exist';
  }
  return null;
}

String? validatePassword(String? password) {
  if (password == null || password.isEmpty) {
    return 'Password cannot be empty';
  }
  if (password.length < 8) {
    return 'Password must be at least 8 characters long';
  }
  return null;
}

String? validatePasswordConfirm(String? password, String? confirm) {
  if (confirm == null || confirm.isEmpty) {
    return 'Confirm your password';
  }
  if (password != confirm) {
    return 'Passwords do not match';
  }
  return null;
}

String? validateName(String? name) {
  if (name == null || name.trim().isEmpty) {
    return 'Name cannot be empty';
  }
  if (name.trim().length < 4) {
    return 'Name must be at least 4 characters long';
  }
  return null;
}
