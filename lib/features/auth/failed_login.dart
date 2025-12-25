import 'package:eye/features/auth/register.dart';
import 'package:eye/utils/router.dart';
import 'package:manager/manager.dart';

import '../../main.dart';

class FailedLoginDialog extends UI {
  const FailedLoginDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: 'Login failed'.text(),
      content: 'Please check your email and password'.text(),
      actions: [
        ElevatedButton(
          child: 'Ok'.text(),
          onPressed: () {
            router.back();
          },
        ),
        ElevatedButton(
          child: 'Register'.text(),
          onPressed: () {
            router.back();
            router.to(RegisterView.route);
          },
        ),
      ],
    );
  }
}
