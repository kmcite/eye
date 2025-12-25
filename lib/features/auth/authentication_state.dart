import 'package:eye/domain/api/users.dart';
import 'package:eye/domain/models/app_user.dart';
import 'package:eye/features/auth/failed_login.dart';
import 'package:eye/utils/api.dart';
import 'package:eye/utils/router.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

final autheticationFormRM = RM.injectForm(
  autovalidateMode: .always,
);

final emailField = RM.injectTextEditing(
  text: "adn@gmail.com",
  autoDispose: false,
);
final passwordField = RM.injectTextEditing(
  text: "1234",
  autoDispose: false,
);
final loadingRM = RM.inject(
  () => true,
  debugPrintWhenNotifiedPreMessage: 'AUTHENTICATION|LOADING',
  autoDisposeWhenNotUsed: false,
);

/// REGISTER ONLY STATE
final nameField = RM.injectTextEditing(
  text: "Adnan Farooq",
  autoDispose: false,
);

/// MUTATIONS
void authenticate() async {
  loadingRM.onChanged(true);
  final authenticated = users.authenticated(
    emailField.value,
    passwordField.value,
  );
  if (authenticated) {
    authenticationRM.state = users.getByEmail(emailField.value)!.id;
  } else {
    router.toDialog(FailedLoginDialog());
  }
  loadingRM.onChanged(false);
}

void logout() {
  loadingRM.onChanged(true);
  authenticationRM.state = null;
  loadingRM.onChanged(false);
}

void register() async {
  loadingRM.onChanged(true);
  await users.put(
    AppUser()
      ..name = nameField.value.trim()
      ..email = emailField.value.trim().toLowerCase()
      ..password = passwordField.value,
  );
  final user = users.getByEmail(emailField.value)!;
  authenticationRM.state = user.id;
  loadingRM.onChanged(false);
}
