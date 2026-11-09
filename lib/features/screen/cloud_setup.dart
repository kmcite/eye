import 'package:eye/business/cloud_bootstrap_notifier.dart';
import 'package:eye/business/sync_notifier.dart';
import 'package:eye/ui/eye_ui.dart';
import 'package:eye/utils/infrastructure.dart';
import 'package:eye/utils/pocketbase_config.dart';
import 'package:eye/utils/router.dart';
import 'package:flutter/material.dart';

class CloudSetupScreen extends SignalConsumer {
  const CloudSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bootstrap = cloudBootstrapNotifierProvider();
    return _CloudSetupForm(
      busy: bootstrap.busy(),
      error: bootstrap.lastError(),
      onSubmit: (url, email, password) async {
        try {
          await bootstrap.completeSetup(
            baseUrl: url,
            adminEmail: email,
            adminPassword: password,
          );
          await syncNotifierProvider().syncNow();
          if (context.mounted) router.pop();
        } catch (_) {
          return;
        }
      },
    );
  }
}

class _CloudSetupForm extends StatefulWidget {
  const _CloudSetupForm({
    required this.busy,
    required this.error,
    required this.onSubmit,
  });

  final bool busy;
  final Object? error;
  final Future<void> Function(String url, String email, String password)
  onSubmit;

  @override
  State<_CloudSetupForm> createState() => _CloudSetupFormState();
}

class _CloudSetupFormState extends State<_CloudSetupForm> {
  late final TextEditingController _urlCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _passCtrl;

  @override
  void initState() {
    super.initState();
    final config = pocketBaseConfigProvider();
    _urlCtrl = TextEditingController(text: config.baseUrl);
    _emailCtrl = TextEditingController(text: config.adminEmail ?? '');
    _passCtrl = TextEditingController(text: config.adminPassword ?? '');
  }

  @override
  void dispose() {
    _urlCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (widget.busy) return;
    widget.onSubmit(_urlCtrl.text, _emailCtrl.text, _passCtrl.text);
  }

  @override
  Widget build(BuildContext context) {
    return EyeScaffold(
      title: 'Cloud setup',
      body: EyeListView(
        children: [
          const SectionHeader(
            title: 'PocketBase',
            subtitle: 'One-time admin login so Eye can create sync collections on a fresh server.',
          ),
          InlineMessage.info(
            'Termux on this phone: use $defaultPocketBaseBaseUrl. '
            'Android emulator: http://10.0.2.2:8090',
          ),
          const SizedBox(height: 16),
          GlassPanel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                EyeFieldGroup(
                  label: 'Server URL',
                  child: EyeTextField(
                    controller: _urlCtrl,
                    placeholder: defaultPocketBaseBaseUrl,
                    keyboardType: TextInputType.url,
                    textInputAction: TextInputAction.next,
                  ),
                ),
                const SizedBox(height: 16),
                EyeFieldGroup(
                  label: 'Superuser email',
                  child: EyeTextField(
                    controller: _emailCtrl,
                    placeholder: 'admin@example.com',
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                  ),
                ),
                const SizedBox(height: 16),
                EyeFieldGroup(
                  label: 'Superuser password',
                  child: EyeTextField(
                    controller: _passCtrl,
                    placeholder: 'PocketBase admin password',
                    obscureText: true,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _submit(),
                  ),
                ),
                if (widget.error != null) ...[
                  const SizedBox(height: 12),
                  InlineMessage.error(widget.error.toString()),
                ],
                const SizedBox(height: 20),
                EyePrimaryButton(
                  label: widget.busy
                      ? 'Setting up…'
                      : 'Save & provision schema',
                  icon: EyeIcons.cloudUpload,
                  expand: true,
                  onPressed: widget.busy ? null : _submit,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
