import 'package:eye/domain/api/users_repository.dart';
import 'package:spark/spark.dart';

final authenticationSpark = RM.inject(
  () => AuthenticationSpark(usersRepositorySpark()),
);

class AuthenticationSpark {
  final UsersRepository usersRepository;
  var name = 'Adnan Farooq';
  var email = 'adn@gmail.com';
  void onEmailChanged(String value) => email = value;

  var password = '123456';
  bool loading = false;
  int? uid;

  AuthenticationSpark(this.usersRepository);
  bool get authenticated => uid != null;
  bool get isUserEmailExists => usersRepository.exists(email);

  void login() {}

  void register() {
    // usersRepository.create(name, email, password);
  }

  void logout() {}
  void bypassLogin() {}

  void onPasswordChanged(String value) => password = value;
}

// final autheticationFormRM = RM.injectForm(
//   autovalidateMode: .always,
// );

// final emailField = signal("adn@gmail.com");
// final passwordField = signal("1234");
// final loadingRM = RM.inject(
//   () => true,
//   debugPrintWhenNotifiedPreMessage: 'AUTHENTICATION|LOADING',
//   autoDisposeWhenNotUsed: false,
// );

// /// REGISTER ONLY STATE
// final nameField = signal("Adnan Farooq");

// final authenticated = computed(
//   () {
//     // return authentication() != null;
//   },
// );

// /// MUTATIONS
// void login() async {
//   // if (authenticated()) {
//   //   authentication(users.getByEmail(emailField())!.id);
//   // } else {
//   //   router.toDialog(FailedLoginDialog());
//   // }
// }

// void logout() {
//   // authentication(null);
//   // loadingRM.onChanged(true);
//   // authenticationRM.state = null;
//   // loadingRM.onChanged(false);
// }

// void register() async {
//   // // loadingRM.onChanged(true);
//   // put(
//   //   AppUser()
//   //     ..name = nameField()
//   //     ..email = emailField().trim().toLowerCase()
//   //     ..password = passwordField().trim(),
//   // );
//   // final user = users.getByEmail(emailField())!;
//   // authentication(user.id);
// }
