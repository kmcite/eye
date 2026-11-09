import 'package:eye/business/app_status_notifier.dart';
import 'package:eye/business/authentication_notifier.dart';
import 'package:eye/features/screen/categories.dart';
import 'package:eye/features/screen/cloud_setup.dart';
import 'package:eye/features/screen/home/app_drawer.dart';
import 'package:eye/features/screen/questions.dart';
import 'package:eye/features/screen/settings.dart';
import 'package:eye/ui/eye_ui.dart';
import 'package:eye/utils/infrastructure.dart';
import 'package:eye/utils/pocketbase_config.dart';
import 'package:eye/utils/router.dart';
import 'package:flutter/material.dart';

class HomePage extends SignalConsumer {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = authenticationNotifierProvider();
    final setup = pocketBaseConfigProvider().setupRequired();
    final cloudUp = appStatusNotifierProvider().pocketBaseReachable();
    final user = auth.appUser();
    final theme = context.eyeTheme;
    final name = user == null
        ? 'there'
        : (user.name.trim().isNotEmpty ? user.name : user.username);

    return EyeScaffold(
      title: 'Eye',
      menu: const AppMenuDrawer(),
      trailing: EyeIconButton(
        icon: EyeIcons.settings,
        semanticLabel: 'Settings',
        onPressed: () => router.push(const SettingsScreen()),
      ),
      body: EyeListView(
        children: [
          Text('Hello, $name', style: theme.titleLarge.copyWith(fontSize: 30)),
          const SizedBox(height: 6),
          Text(
            'Practice offline; changes sync when PocketBase is available.',
            style: theme.caption.copyWith(fontSize: 15),
          ),
          if (setup && cloudUp) ...[
            const SizedBox(height: 20),
            InlineMessage.info(
              'PocketBase is reachable but sync is not configured yet.',
            ),
            const SizedBox(height: 10),
            EyePrimaryButton(
              label: 'Set up cloud sync',
              icon: EyeIcons.cloudUpload,
              onPressed: () => router.push(const CloudSetupScreen()),
            ),
          ],
          const SizedBox(height: 28),
          const SectionHeader(title: 'Study', subtitle: 'Pick a mode'),
          const SizedBox(height: 8),
          _HubCard(
            icon: EyeIcons.book,
            title: 'Practice',
            subtitle: 'Timed MCQ sessions by topic',
            tint: theme.primary,
            onTap: () => router.push(const CategoriesScreen()),
          ),
          const SizedBox(height: 12),
          _HubCard(
            icon: EyeIcons.questionDiamond,
            title: 'Question bank',
            subtitle: 'Author, search, and filter items',
            tint: theme.success,
            onTap: () => router.push(const QuestionsScreen()),
          ),
        ],
      ),
    );
  }
}

class _HubCard extends StatelessWidget {
  const _HubCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.tint,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color tint;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = context.eyeTheme;
    return EyeTap(
      onPressed: onTap,
      semanticButton: false,
      minSize: 0,
      borderRadius: BorderRadius.circular(18),
      child: GlassPanel(
        child: Row(
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: tint.withValues(alpha: 0.16),
                border: Border.all(color: tint.withValues(alpha: 0.35)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Icon(icon, size: 26, color: tint),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: theme.navTitle.copyWith(fontSize: 17)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: theme.caption),
                ],
              ),
            ),
            Icon(EyeIcons.chevronRight, size: 22, color: theme.secondaryLabel),
          ],
        ),
      ),
    );
  }
}
