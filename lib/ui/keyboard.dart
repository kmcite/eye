import 'package:flutter/material.dart';

/// Dismisses the soft keyboard when tapping outside focused fields.
class EyeKeyboardDismiss extends StatelessWidget {
  const EyeKeyboardDismiss({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      behavior: HitTestBehavior.translucent,
      child: child,
    );
  }
}

/// Lifts content with the keyboard using [MediaQuery.viewInsets].
class EyeKeyboardInset extends StatelessWidget {
  const EyeKeyboardInset({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 120),
  });

  final Widget child;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.viewInsetsOf(context).bottom;
    return AnimatedPadding(
      duration: duration,
      curve: Curves.easeOutCubic,
      padding: EdgeInsets.only(bottom: bottom),
      child: child,
    );
  }
}
