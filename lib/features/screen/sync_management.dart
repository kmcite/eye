import 'package:eye/business/app_status_notifier.dart';
import 'package:eye/business/sync_notifier.dart';
import 'package:eye/domain/repositories/sync_repository.dart';
import 'package:eye/features/screen/cloud_setup.dart';
import 'package:eye/features/screen/outbox.dart';
import 'package:eye/ui/eye_ui.dart';
import 'package:eye/utils/infrastructure.dart';
import 'package:eye/utils/pocketbase_config.dart';
import 'package:eye/utils/router.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SyncManagementScreen extends SignalConsumer {
  const SyncManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final status = appStatusNotifierProvider();
    final engine = syncNotifierProvider();
    final repo = syncRepositoryProvider();
    final config = pocketBaseConfigProvider();
    final cursor = repo.syncCursor;
    final last = engine.lastCompletedAt();

    return EyeScaffold(
      title: 'Sync',
      body: EyeListView(
        children: [
          const SectionHeader(
            title: 'Engine',
            subtitle:
                'ObjectBox is source of truth; changes queue to PocketBase',
          ),
          GlassPanel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _Row(
                  label: 'Status',
                  value: status.syncActive()
                      ? 'Syncing…'
                      : status.syncQueueCount() > 0
                      ? '${status.syncQueueCount()} in outbox'
                      : 'Idle',
                ),
                if (last != null)
                  _Row(
                    label: 'Last cycle',
                    value: DateFormat.yMMMd().add_jm().format(last.toLocal()),
                  ),
                const SizedBox(height: 12),
                EyePrimaryButton(
                  label: 'Sync now',
                  icon: EyeIcons.sync,
                  onPressed: status.syncActive()
                      ? null
                      : () => engine.syncNow(),
                ),
                const SizedBox(height: 8),
                EyeSwitch(
                  value: engine.autoSyncEnabled(),
                  onChanged: engine.setAutoSync,
                ),
                const Text(
                  'Automatic background sync (30s)',
                  style: TextStyle(fontSize: 13),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          GlassPanel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _Row(
                  label: 'Network',
                  value: status.networkOnline() ? 'Online' : 'Offline',
                ),
                _Row(
                  label: 'PocketBase',
                  value: status.pocketBaseReachable()
                      ? config.baseUrl
                      : 'Unreachable',
                ),
                _Row(
                  label: 'Applied remote',
                  value: '${repo.appliedRemoteCount}',
                ),
                if (cursor != null) ...[
                  _Row(label: 'Device id', value: cursor.deviceId),
                  _Row(
                    label: 'Pull cursor',
                    value: cursor.lastPulledCreated.isEmpty
                        ? '(start)'
                        : cursor.lastPulledCreated,
                  ),
                ],
                const SizedBox(height: 8),
                EyeTextButton(
                  label: 'Refresh connectivity',
                  onPressed: () => status.refresh(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          EyeListTile(
            title: 'Cloud setup',
            subtitle: config.isSchemaCurrent ? 'Configured' : 'Setup required',
            trailing: const Icon(EyeIcons.chevronRight),
            onTap: () => router.push(const CloudSetupScreen()),
          ),
          EyeListTile(
            title: 'Outbox',
            subtitle: '${status.syncQueueCount()} pending',
            trailing: const Icon(EyeIcons.chevronRight),
            onTap: () => router.push(const OutboxScreen()),
          ),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(label, style: context.eyeTheme.caption),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }
}
