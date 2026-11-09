import 'package:flutter/material.dart';

/// Scroll view defaults tuned for soft-keyboard UX.
class EyeSingleChildScrollView extends StatelessWidget {
  const EyeSingleChildScrollView({
    super.key,
    required this.child,
    this.padding,
    this.controller,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.onDrag,
    this.centered = false,
    this.maxWidth = 480,
  });

  final Widget child;
  final EdgeInsets? padding;
  final ScrollController? controller;
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;
  final bool centered;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    final insets = MediaQuery.viewInsetsOf(context);
    final resolvedPadding = (padding ?? const EdgeInsets.symmetric(horizontal: 20, vertical: 16))
        + EdgeInsets.only(bottom: insets.bottom + 8);

    return SingleChildScrollView(
      controller: controller,
      keyboardDismissBehavior: keyboardDismissBehavior,
      padding: resolvedPadding,
      child: centered
          ? Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: child,
              ),
            )
          : child,
    );
  }
}

class EyeListView extends StatelessWidget {
  const EyeListView({
    super.key,
    required this.children,
    this.padding,
    this.controller,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.onDrag,
    this.shrinkWrap = false,
  });

  final List<Widget> children;
  final EdgeInsets? padding;
  final ScrollController? controller;
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;
  final bool shrinkWrap;

  @override
  Widget build(BuildContext context) {
    final insets = MediaQuery.viewInsetsOf(context);
    final base = padding ?? const EdgeInsets.fromLTRB(20, 16, 20, 32);
    return ListView(
      controller: controller,
      shrinkWrap: shrinkWrap,
      keyboardDismissBehavior: keyboardDismissBehavior,
      padding: base + EdgeInsets.only(bottom: insets.bottom),
      children: children,
    );
  }
}
