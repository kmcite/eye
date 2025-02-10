import 'package:eye/main.dart';

class LoginRegisterRepository {
  final nameRM = RM.inject(() => 'Adnan Farooq');
  final emailRM = RM.inject(() => 'adn@gmail.com');
  final passwordRM = RM.inject(() => '1234');
  String name([String? value]) {
    if (value != null) {
      nameRM.state = value;
    }
    return nameRM.state;
  }

  String email([String? value]) {
    if (value != null) {
      emailRM.state = value;
    }
    return emailRM.state;
  }

  String password([String? value]) {
    if (value != null) {
      passwordRM.state = value;
    }
    return passwordRM.state;
  }
}
