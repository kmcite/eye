import 'package:eye/business/authentication_notifier.dart';
import 'package:eye/ui/eye_ui.dart';
import 'package:eye/utils/infrastructure.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class RegisterView extends SignalConsumer {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    final authentication = authenticationNotifierProvider();
    final err = authentication.error()?.toString();
    final firstFieldErr = authentication.registerFirstFieldError();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        EyeFieldGroup(
          label: 'Username',
          child: EyeTextField(
            placeholder: 'Username',
            textInputAction: TextInputAction.next,
            onChanged: authentication.username.set,
          ),
        ),
        const SizedBox(height: 14),
        EyeFieldGroup(
          label: 'Email',
          child: EyeTextField(
            placeholder: 'you@example.com',
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            onChanged: authentication.email.set,
          ),
        ),
        const SizedBox(height: 14),
        EyeFieldGroup(
          label: 'Password',
          child: EyeTextField(
            placeholder: 'At least 8 characters',
            obscureText: true,
            textInputAction: TextInputAction.next,
            onChanged: authentication.password.set,
          ),
        ),
        const SizedBox(height: 14),
        EyeFieldGroup(
          label: 'Confirm password',
          child: EyeTextField(
            placeholder: 'Repeat password',
            obscureText: true,
            textInputAction: TextInputAction.done,
            onChanged: authentication.passwordConfirm.set,
          ),
        ),
        if (firstFieldErr != null || err != null) ...[
          const SizedBox(height: 14),
          if (firstFieldErr != null)
            InlineMessage.error(firstFieldErr)
          else if (err != null)
            InlineMessage.error(err),
        ],
        const SizedBox(height: 22),
        if (authentication.loading())
          const Center(child: EyeSpinner())
        else
          EyePrimaryButton(
            label: 'Create account',
            expand: true,
            icon: EyeIcons.person,
            onPressed: authentication.enabled() && authentication.registerFormValid()
                ? () => authentication.register()
                : null,
          ),
      ],
    );
  }
}
