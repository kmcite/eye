import 'package:eye/business/app_status_notifier.dart';
import 'package:eye/business/sync_notifier.dart';
import 'package:eye/domain/repositories/sync_repository.dart';
import 'package:eye/domain/models/sync_outbox_entry.dart';
import 'package:eye/ui/eye_ui.dart';
import 'package:eye/utils/infrastructure.dart';
import 'package:flutter/material.dart';

class OutboxScreen extends SignalConsumer {
  const OutboxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = syncRepositoryProvider();
    final status = appStatusNotifierProvider();
    final entries = repo.listPendingOutbox();

    return EyeScaffold(
      title: 'Outbox',
      trailing: status.syncQueueCount() > 0
          ? EyePrimaryButton(
              label: 'Sync',
              icon: EyeIcons.sync,
              onPressed: () => syncNotifierProvider().syncNow(),
            )
          : null,
      body: entries.isEmpty
          ? Center(
              child: Text(
                'No pending changes',
                style: context.eyeTheme.caption,
              ),
            )
          : EyeListView(
              children: [
                for (final e in entries) _OutboxCard(entry: e),
              ],
            ),
    );
  }
}

class _OutboxCard extends StatelessWidget {
  const _OutboxCard({required this.entry});

  final SyncOutboxEntry entry;

  @override
  Widget build(BuildContext context) {
    final theme = context.eyeTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GlassPanel(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${entry.entityType} · ${entry.operation}',
              style: theme.navTitle.copyWith(fontSize: 15),
            ),
            const SizedBox(height: 4),
            Text('Key: ${entry.entityKey}', style: theme.caption),
            Text(
              'Queued ${entry.createdAt.toLocal()}',
              style: theme.caption,
            ),
          ],
        ),
      ),
    );
  }
}
