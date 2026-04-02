import 'package:eye/features/auth/register.dart';
import 'package:eye/utils/navigator.dart';

import '../../main.dart';

class FailedLoginDialog extends UI {
  const FailedLoginDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Login failed'),
      content: Text('Please check your email and password'),
      actions: [
        ElevatedButton(
          child: Text('Cancel'),
          onPressed: () {
            router.back();
          },
        ),
        FilledButton(
          child: Text('Register'),
          onPressed: () {
            router.back();
            router.to(RegisterView.route);
          },
        ),
      ],
    );
  }
}
