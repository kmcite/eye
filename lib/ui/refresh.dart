import 'package:flutter/material.dart';

typedef EyeRefreshCallback = Future<void> Function();

/// Material pull-to-refresh over a scrollable [child] (must be scrollable).
class EyeRefreshScrollView extends StatelessWidget {
  const EyeRefreshScrollView({
    super.key,
    required this.onRefresh,
    required this.child,
    this.physics,
  });

  final EyeRefreshCallback onRefresh;
  final Widget child;
  final ScrollPhysics? physics;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator.adaptive(
      onRefresh: onRefresh,
      edgeOffset: 8,
      child: child,
    );
  }
}

/// ListView wrapper that is always scrollable for [RefreshIndicator].
class EyeRefreshableListView extends StatelessWidget {
  const EyeRefreshableListView({
    super.key,
    required this.onRefresh,
    required this.children,
    this.padding,
    this.controller,
  });

  final EyeRefreshCallback onRefresh;
  final List<Widget> children;
  final EdgeInsets? padding;
  final ScrollController? controller;

  @override
  Widget build(BuildContext context) {
    final insets = MediaQuery.viewInsetsOf(context);
    final base = padding ?? const EdgeInsets.fromLTRB(20, 16, 20, 32);
    return EyeRefreshScrollView(
      onRefresh: onRefresh,
      child: ListView(
        controller: controller,
        physics: const AlwaysScrollableScrollPhysics(),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: base + EdgeInsets.only(bottom: insets.bottom),
        children: children,
      ),
    );
  }
}
