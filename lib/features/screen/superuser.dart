import 'package:eye/business/superuser.dart';
import 'package:eye/business/users_notifier.dart';
import 'package:eye/ui/eye_ui.dart';
import 'package:eye/utils/infrastructure.dart';
import 'package:flutter/widgets.dart';

class SuperUserScreen extends SignalConsumer {
  const SuperUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final superuser = superuserProvider();
    final users = usersNotifierProvider();

    final loggedIn = superuser.isLoggedIn();
    final busy = superuser.isBusy();

    return EyeScaffold(
      title: 'Superuser',
      trailing: EyeChip(
        label: loggedIn ? 'Connected' : 'Disconnected',
        selected: loggedIn,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        children: [
          GlassPanel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'PocketBase',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Admin credentials come from Settings → PocketBase (cloud setup).',
                  style: TextStyle(
                    fontSize: 13,
                    color: context.eyeTheme.secondaryLabel,
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    EyePrimaryButton(
                      label: 'Login',
                      icon: EyeIcons.login,
                      onPressed: busy || loggedIn
                          ? null
                          : () async {
                              try {
                                await superuser.login();
                              } catch (_) {
                                return;
                              }
                              await users.loadUsers();
                            },
                    ),
                    EyePrimaryButton(
                      label: 'Logout',
                      onPressed: busy || !loggedIn
                          ? null
                          : () => superuser.logout(),
                    ),
                    EyePrimaryButton(
                      label: 'Ensure schema',
                      icon: EyeIcons.table,
                      onPressed: busy || !loggedIn
                          ? null
                          : () => superuser.ensureSchema(),
                    ),
                  ],
                ),
                if (busy) ...[
                  const SizedBox(height: 20),
                  const EyeProgressBar(value: 0.35),
                  const SizedBox(height: 8),
                  const Center(child: EyeSpinner()),
                ],
                if (superuser.error() != null) ...[
                  const SizedBox(height: 12),
                  InlineMessage.error(superuser.error().toString()),
                ],
                if (users.error().isNotEmpty) ...[
                  const SizedBox(height: 12),
                  InlineMessage.error(users.error()),
                ],
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Local users (${users.users().length})',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          ...users.users().map(
            (user) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: GlassPanel(
                child: Row(
                  children: [
                    DecoratedBox(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: context.eyeTheme.primary.withValues(alpha: 0.2),
                      ),
                      child: SizedBox(
                        width: 44,
                        height: 44,
                        child: Center(
                          child: Text(
                            user.name.isEmpty
                                ? '?'
                                : user.name.characters.first.toUpperCase(),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.name.isEmpty ? user.username : user.name,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Text('${user.email}\n@${user.username}'),
                        ],
                      ),
                    ),
                    EyeIconButton(
                      icon: EyeIcons.delete,
                      color: context.eyeTheme.error,
                      onPressed: () => users.remove(user.id),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
