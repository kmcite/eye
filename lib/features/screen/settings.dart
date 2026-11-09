import 'package:eye/business/app_status_notifier.dart';
import 'package:eye/business/authentication_notifier.dart';
import 'package:eye/business/dark_notifier.dart';
import 'package:eye/features/screen/cloud_setup.dart';
import 'package:eye/features/screen/outbox.dart';
import 'package:eye/features/screen/sync_management.dart';
import 'package:eye/features/widgets/profile_section.dart';
import 'package:eye/ui/eye_ui.dart';
import 'package:eye/utils/infrastructure.dart';
import 'package:eye/utils/pocketbase_config.dart';
import 'package:eye/utils/router.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends SignalConsumer {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authentication = authenticationNotifierProvider();
    final dark = darkNotifierProvider();
    final status = appStatusNotifierProvider();
    final queue = status.syncQueueCount();
    final pbConfig = pocketBaseConfigProvider();
    final cloudUp = status.pocketBaseReachable();

    final mode = dark.dark();
    final (icon, label) = switch (mode) {
      true => (EyeIcons.moon, 'Dark'),
      false => (EyeIcons.sun, 'Light'),
      null => (EyeIcons.circleHalf, 'System'),
    };

    return EyeScaffold(
      title: 'Settings',
      body: EyeListView(
        children: [
          const SectionHeader(
            title: 'Profile',
            subtitle: 'Local account · data in ObjectBox',
          ),
          const ProfileSection(),
          const SizedBox(height: 24),
          const SectionHeader(
            title: 'Cloud',
            subtitle: 'Optional PocketBase sync (outbox from ObjectBox)',
          ),
          GlassPanel(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                _SettingsRow(
                  icon: EyeIcons.cloudUpload,
                  title: 'PocketBase',
                  subtitle: cloudUp
                      ? pbConfig.isSchemaCurrent
                          ? pbConfig.baseUrl
                          : 'Connected — setup required'
                      : '${pbConfig.baseUrl} · unreachable',
                  onTap: () => router.push(const CloudSetupScreen()),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const SectionHeader(title: 'App'),
          GlassPanel(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                _SettingsRow(
                  icon: icon,
                  title: 'Appearance',
                  subtitle: '$label · tap to change',
                  onTap: dark.toggle,
                ),
                _sep(context),
                _SettingsRow(
                  icon: EyeIcons.sync,
                  title: 'Sync engine',
                  subtitle: status.syncActive()
                      ? 'Syncing now'
                      : queue > 0
                          ? '$queue item(s) in outbox'
                          : 'Up to date',
                  onTap: () => router.push(const SyncManagementScreen()),
                ),
                if (queue > 0) ...[
                  _sep(context),
                  _SettingsRow(
                    icon: EyeIcons.trayUp,
                    title: 'Outbox',
                    subtitle: '$queue pending change(s)',
                    onTap: () => router.push(const OutboxScreen()),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 32),
          const SectionHeader(title: 'Account'),
          EyeDestructiveButton(
            label: 'Sign out',
            icon: EyeIcons.logout,
            expand: true,
            onPressed: () async {
              router.popToRoot();
              await authentication.logout();
            },
          ),
        ],
      ),
    );
  }

  static Widget _sep(BuildContext context) => Container(
        height: 0.5,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        color: context.eyeTheme.separator,
      );
}

class _SettingsRow extends StatelessWidget {
  const _SettingsRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return EyeTap(
      onPressed: onTap,
      semanticButton: false,
      minSize: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(icon, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: context.eyeTheme.secondaryLabel,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(EyeIcons.chevronRight, size: 18),
          ],
        ),
      ),
    );
  }
}
