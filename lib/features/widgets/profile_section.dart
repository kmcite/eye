import 'package:eye/business/authentication_notifier.dart';
import 'package:eye/ui/eye_ui.dart';
import 'package:eye/utils/infrastructure.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class ProfileSection extends SignalConsumer {
  const ProfileSection({super.key});

  @override
  Widget build(BuildContext context) {
    final user = authenticationNotifierProvider().appUser();

    if (user == null) {
      return GlassPanel(
        child: Row(
          children: [
            Icon(
              EyeIcons.personOff,
              color: context.eyeTheme.secondaryLabel,
            ),
            const SizedBox(width: 12),
            const Text('No signed-in user'),
          ],
        ),
      );
    }

    return GlassPanel(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
            child: Row(
              children: [
                _Avatar(user.avatar, _initials(user.name, user.username)),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name.isEmpty ? user.username : user.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '@${user.username}',
                        style: TextStyle(
                          color: context.eyeTheme.secondaryLabel,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          _ProfileRow(EyeIcons.mail, 'Email', user.email),
          _divider(context),
          _ProfileRow(EyeIcons.person, 'Username', user.username),
          _divider(context),
          _ProfileRow(EyeIcons.number, 'User ID', user.id.toString()),
          _divider(context),
          _ProfileRow(
            EyeIcons.calendar,
            'Joined',
            DateFormat.yMMMMd().format(user.created.toLocal()),
          ),
          _divider(context),
          _ProfileRow(
            EyeIcons.time,
            'Last updated',
            DateFormat.yMMMMd().format(user.updated.toLocal()),
          ),
        ],
      ),
    );
  }

  static Widget _divider(BuildContext context) => Container(
    height: 0.5,
    color: context.eyeTheme.separator,
  );

  String _initials(String name, String username) {
    try {
      final text = name.trim().isNotEmpty ? name : username;
      final parts = text.trim().split(RegExp(r'\s+'));
      if (parts.length == 1) {
        return parts.first.substring(0, 1).toUpperCase();
      }
      return (parts.first.substring(0, 1) + parts.last.substring(0, 1))
          .toUpperCase();
    } catch (_) {
      return '?';
    }
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar(this.url, this.initials);

  final String url;
  final String initials;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: context.eyeTheme.primary.withValues(alpha: 0.2),
      ),
      child: SizedBox(
        width: 72,
        height: 72,
        child: url.isNotEmpty
            ? ClipOval(child: Image.network(url, fit: BoxFit.cover))
            : Center(
                child: Text(
                  initials,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
      ),
    );
  }
}

class _ProfileRow extends StatelessWidget {
  const _ProfileRow(this.icon, this.title, this.value);

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    color: context.eyeTheme.secondaryLabel,
                  ),
                ),
                Text(value),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
