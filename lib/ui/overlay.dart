import 'package:eye/ui/button.dart';
import 'package:eye/ui/glass.dart';
import 'package:eye/ui/theme.dart';
import 'package:eye/utils/infrastructure.dart';
import 'package:eye/utils/router.dart';
import 'package:flutter/material.dart';

/// Material [AlertDialog] layout with a liquid-glass surface.
class EyeDialog extends StatelessWidget {
  const EyeDialog({
    super.key,
    this.title,
    this.content,
    this.actions = const [],
    this.icon,
  });

  final String? title;
  final Widget? content;
  final List<Widget> actions;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    final theme = context.eyeTheme;
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: GlassPanel(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (icon != null) ...[
              Align(child: icon),
              const SizedBox(height: 12),
            ],
            if (title != null)
              Text(
                title!,
                style: theme.titleLarge.copyWith(fontSize: 20),
              ),
            if (content != null) ...[
              const SizedBox(height: 12),
              DefaultTextStyle(
                style: theme.bodySmall,
                child: content!,
              ),
            ],
            if (actions.isNotEmpty) ...[
              const SizedBox(height: 8),
              OverflowBar(
                alignment: MainAxisAlignment.end,
                spacing: 8,
                children: actions,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class EyeConfirmDialog extends SignalConsumer {
  const EyeConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    required this.onClose,
    this.confirm = 'OK',
    this.cancel = 'Cancel',
    this.isDestructive = false,
  });

  final String title;
  final String message;
  final void Function(bool? value) onClose;
  final String confirm;
  final String cancel;
  final bool isDestructive;

  void _close(bool? value) {
    onClose(value);
    router.pop();
  }

  @override
  Widget build(BuildContext context) {
    return EyeDialog(
      title: title,
      content: Text(message),
      actions: [
        EyeTextButton(label: cancel, onPressed: () => _close(false)),
        if (isDestructive)
          EyeDestructiveButton(label: confirm, onPressed: () => _close(true))
        else
          EyePrimaryButton(label: confirm, onPressed: () => _close(true)),
      ],
    );
  }
}

/// One glass panel with Material [ListTile] rows (replaces iOS-style action sheets).
class EyeOptionsSheet extends StatelessWidget {
  const EyeOptionsSheet({
    super.key,
    this.title,
    required this.actions,
  });

  final String? title;
  final List<EyeSheetAction> actions;

  @override
  Widget build(BuildContext context) {
    final theme = context.eyeTheme;
    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (title != null) ...[
              Padding(
                padding: const EdgeInsets.only(bottom: 8, left: 4),
                child: Text(
                  title!,
                  style: theme.titleLarge.copyWith(fontSize: 18),
                ),
              ),
            ],
            GlassPanel(
              padding: EdgeInsets.zero,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (var i = 0; i < actions.length; i++) ...[
                    if (i > 0) Divider(height: 1, color: theme.separator),
                    ListTile(
                      leading: actions[i].icon != null
                          ? Icon(
                              actions[i].icon,
                              color: actions[i].destructive
                                  ? theme.error
                                  : theme.label,
                            )
                          : null,
                      title: Text(
                        actions[i].label,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: actions[i].destructive
                              ? theme.error
                              : theme.label,
                        ),
                      ),
                      onTap: actions[i].onPressed,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EyeSheetAction {
  const EyeSheetAction({
    required this.label,
    required this.onPressed,
    this.icon,
    this.destructive = false,
  });

  final String label;
  final VoidCallback onPressed;
  final IconData? icon;
  final bool destructive;
}

/// Drag-handle header for router-presented bottom sheets.
class EyeSheetFrame extends StatelessWidget {
  const EyeSheetFrame({
    super.key,
    required this.title,
    required this.child,
    this.actions,
  });

  final String title;
  final Widget child;
  final Widget? actions;

  @override
  Widget build(BuildContext context) {
    final theme = context.eyeTheme;
    return Material(
      color: Colors.transparent,
      child: GlassPanel(
        radius: 22,
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 32,
                height: 4,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: theme.secondaryLabel.withValues(alpha: 0.45),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Text(
              title,
              style: theme.titleLarge.copyWith(fontSize: 18),
            ),
            const SizedBox(height: 12),
            child,
            if (actions != null) ...[
              const SizedBox(height: 12),
              actions!,
            ],
          ],
        ),
      ),
    );
  }
}
