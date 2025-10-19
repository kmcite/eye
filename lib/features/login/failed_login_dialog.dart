import 'package:eye/features/register/register_page.dart';
import 'package:eye/utils/api.dart';

import '../../main.dart';

class FailedLoginDialog extends UI {
  const FailedLoginDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return FDialog(
      direction: Axis.horizontal,
      title: 'Login failed'.text(),
      body: 'Please check your email and password'.text(),
      actions: [
        FButton(
          child: 'Ok'.text(),
          onPress: () {
            navigator.back();
          },
        ),
        FButton(
          child: 'Register'.text(),
          onPress: () {
            navigator.back();
            navigator.to(RegisterPage());
          },
        ),
      ],
    );
  }
}
