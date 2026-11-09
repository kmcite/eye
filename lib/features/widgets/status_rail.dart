import 'package:eye/business/app_status_notifier.dart';
import 'package:eye/features/screen/sync_management.dart';
import 'package:eye/ui/eye_ui.dart';
import 'package:eye/utils/infrastructure.dart';
import 'package:eye/utils/router.dart';
import 'package:flutter/material.dart';

class StatusRail extends SignalConsumer {
  const StatusRail({super.key});

  static const height = 1.0;

  @override
  Widget build(BuildContext context) {
    final status = appStatusNotifierProvider();
    final theme = context.eyeTheme;

    final online = status.networkOnline();
    final cloud = status.pocketBaseReachable();
    final syncing = status.syncActive();
    final queue = status.syncQueueCount();

    final summary = [
      'Network: ${online ? 'online' : 'offline'}',
      'Cloud: ${cloud ? 'reachable' : 'down'}',
      syncing
          ? 'Sync: in progress'
          : queue > 0
              ? 'Sync: $queue queued'
              : 'Sync: idle',
      'Tap for sync engine',
    ].join(' · ');

    final networkColor = online
        ? theme.success.withValues(alpha: 0.85)
        : theme.error.withValues(alpha: 0.75);
    final cloudColor = cloud
        ? const Color(0xFF64D2FF).withValues(alpha: 0.8)
        : theme.warning.withValues(alpha: 0.55);
    final syncColor = syncing
        ? theme.primary.withValues(alpha: 0.9)
        : queue > 0
            ? theme.primary.withValues(alpha: 0.65)
            : theme.secondaryLabel.withValues(alpha: 0.35);

    return Semantics(
      label: summary,
      button: true,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: () => router.push(const SyncManagementScreen()),
          child: SizedBox(
            height: height,
            child: Row(
              children: [
                Expanded(child: ColoredBox(color: networkColor)),
                Expanded(child: ColoredBox(color: cloudColor)),
                Expanded(child: ColoredBox(color: syncColor)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
