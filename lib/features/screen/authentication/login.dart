import 'package:eye/business/authentication_notifier.dart';
import 'package:eye/ui/eye_ui.dart';
import 'package:eye/utils/infrastructure.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class LoginFormView extends SignalConsumer {
  const LoginFormView({super.key});

  @override
  Widget build(BuildContext context) {
    final authentication = authenticationNotifierProvider();
    final err = authentication.error()?.toString();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        EyeFieldGroup(
          label: 'Email',
          child: EyeTextField(
            placeholder: 'you@example.com',
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            onChanged: authentication.email.set,
          ),
        ),
        const SizedBox(height: 16),
        EyeFieldGroup(
          label: 'Password',
          child: EyeTextField(
            placeholder: 'Password',
            obscureText: true,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => authentication.login(),
            onChanged: authentication.password.set,
          ),
        ),
        if (err != null) ...[
          const SizedBox(height: 14),
          InlineMessage.error(err),
        ],
        const SizedBox(height: 22),
        if (authentication.loading())
          const Center(child: EyeSpinner())
        else
          EyePrimaryButton(
            label: 'Sign in',
            expand: true,
            icon: EyeIcons.login,
            onPressed: () => authentication.login(),
          ),
      ],
    );
  }
}
