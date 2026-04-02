import 'package:eye/business/users.dart';
import 'package:eye/domain/models/app_user.dart';
import 'package:eye/features/auth/failed_login.dart';
import 'package:eye/main.dart';
import 'package:eye/utils/db.dart';
import 'package:eye/utils/navigator.dart';

final autheticationFormRM = RM.injectForm(
  autovalidateMode: .always,
);

final emailField = signal("adn@gmail.com");
final passwordField = signal("1234");
final loadingRM = RM.inject(
  () => true,
  debugPrintWhenNotifiedPreMessage: 'AUTHENTICATION|LOADING',
  autoDisposeWhenNotUsed: false,
);

/// REGISTER ONLY STATE
final nameField = signal("Adnan Farooq");

final authenticated = computed(
  () {
    return authentication() != null;
  },
);

/// MUTATIONS
void login() async {
  if (authenticated()) {
    authentication(users.getByEmail(emailField())!.id);
  } else {
    router.toDialog(FailedLoginDialog());
  }
}

void logout() {
  authentication(null);
  // loadingRM.onChanged(true);
  // authenticationRM.state = null;
  // loadingRM.onChanged(false);
}

void register() async {
  // loadingRM.onChanged(true);
  put(
    AppUser()
      ..name = nameField()
      ..email = emailField().trim().toLowerCase()
      ..password = passwordField().trim(),
  );
  final user = users.getByEmail(emailField())!;
  authentication(user.id);
}
