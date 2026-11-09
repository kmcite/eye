import 'package:eye/business/authentication_notifier.dart';
import 'package:eye/features/screen/categories.dart';
import 'package:eye/features/screen/questions.dart';
import 'package:eye/features/screen/settings.dart';
import 'package:eye/ui/eye_ui.dart';
import 'package:eye/utils/infrastructure.dart';
import 'package:eye/utils/router.dart';
import 'package:flutter/material.dart';

class AppMenuDrawer extends SignalConsumer {
  const AppMenuDrawer({super.key});

  void _closeAnd(void Function() action, BuildContext context) {
    Navigator.pop(context);
    action();
  }

  @override
  Widget build(BuildContext context) {
    final authentication = authenticationNotifierProvider();
    final user = authentication.appUser();
    final theme = context.eyeTheme;

    return Drawer(
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 24, 16),
          child: DecoratedBox(
            decoration: Glass.panel(context, radius: 22),
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 12),
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: Row(
                    children: [
                      EyeLogo.themed(context, openAmount: 1, size: 32),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Eye',
                              style: theme.titleLarge.copyWith(fontSize: 20),
                            ),
                            if (user != null)
                              Text(
                                user.email,
                                style: theme.caption,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(height: 1, color: theme.separator),
                _MenuRow(
                  icon: EyeIcons.house,
                  label: 'Home',
                  onTap: () => _closeAnd(router.popToRoot, context),
                ),
                _MenuRow(
                  icon: EyeIcons.book,
                  label: 'Questions',
                  onTap: () => _closeAnd(
                    () => router.push(const QuestionsScreen()),
                    context,
                  ),
                ),
                _MenuRow(
                  icon: EyeIcons.folder,
                  label: 'Topics',
                  onTap: () => _closeAnd(
                    () => router.push(const CategoriesScreen()),
                    context,
                  ),
                ),
                _MenuRow(
                  icon: EyeIcons.gear,
                  label: 'Settings',
                  onTap: () => _closeAnd(
                    () => router.push(const SettingsScreen()),
                    context,
                  ),
                ),
                if (authentication.authenticated()) ...[
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: EyeOutlinedButton(
                      label: 'Sign out',
                      icon: EyeIcons.logout,
                      expand: true,
                      onPressed: () async {
                        Navigator.pop(context);
                        router.popToRoot();
                        await authentication.logout();
                      },
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MenuRow extends StatelessWidget {
  const _MenuRow({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      onTap: onTap,
    );
  }
}
