import 'package:eye/features/screen/authentication/login.dart';
import 'package:eye/features/screen/authentication/register.dart';
import 'package:eye/ui/eye_ui.dart';
import 'package:eye/utils/infrastructure.dart';
import 'package:flutter/material.dart';

class AuthenticationScreen extends SignalConsumer {
  const AuthenticationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.eyeTheme;

    return EyeScaffold(
      showNavBar: false,
      showStatusRail: false,
      body: SafeArea(
        child: EyeSingleChildScrollView(
          centered: true,
          maxWidth: 420,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _AuthHeader(),
              const SizedBox(height: 32),
              const GlassPanel(child: LoginFormView()),
              const SizedBox(height: 16),
              GlassPanel(
                padding: EdgeInsets.zero,
                radius: 14,
                child: Theme(
                  data: Theme.of(context).copyWith(
                    dividerColor: Colors.transparent,
                    splashColor: theme.primary.withValues(alpha: 0.12),
                  ),
                  child: ExpansionTile(
                    tilePadding: EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                    childrenPadding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                    leading: Icon(EyeIcons.gear),
                    title: Text(
                      'Advanced options',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text('Create account on this device'),
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'New account',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'For first-time setup or another profile on this device.',
                      ),
                      SizedBox(height: 16),
                      RegisterView(),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'MCQs live in ObjectBox; sync runs when cloud is configured.',
                textAlign: TextAlign.center,
                style: theme.caption,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AuthHeader extends StatelessWidget {
  const _AuthHeader();

  @override
  Widget build(BuildContext context) {
    final theme = context.eyeTheme;

    return Column(
      children: [
        GlassPanel(
          padding: const EdgeInsets.all(18),
          radius: 28,
          child: EyeLogo.themed(context, openAmount: 1, size: 56),
        ),
        const SizedBox(height: 18),
        Text('Eye', style: theme.titleLarge.copyWith(fontSize: 34)),
        const SizedBox(height: 6),
        Text(
          'Learn · practice · sync',
          style: theme.caption.copyWith(fontSize: 15),
        ),
      ],
    );
  }
}
