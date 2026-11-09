import 'package:flutter/material.dart';

import 'package:eye/features/widgets/status_rail.dart';
import 'package:eye/ui/keyboard.dart';
import 'package:eye/ui/nav_bar.dart';
import 'package:eye/utils/infrastructure.dart';
import 'package:eye/utils/router.dart';

class EyeScaffold extends SignalConsumer {
  const EyeScaffold({
    super.key,
    this.title,
    this.titleWidget,
    this.trailing,
    this.leading,
    this.showBack,
    this.menu,
    required this.body,
    this.primaryAction,
    this.showStatusRail = true,
    this.showNavBar = true,
    this.keyboardInset = true,
  });

  final String? title;
  final Widget? titleWidget;
  final Widget? trailing;
  final Widget? leading;
  final bool? showBack;
  final Widget? menu;
  final Widget body;
  final Widget? primaryAction;
  final bool showStatusRail;
  final bool showNavBar;
  final bool keyboardInset;

  @override
  Widget build(BuildContext context) {
    final back = showBack ?? router.canPop();

    final statusBottom = showStatusRail
        ? const PreferredSize(
            preferredSize: Size.fromHeight(StatusRail.height),
            child: StatusRail(),
          )
        : null;

    Widget content = Scaffold(
      backgroundColor: Colors.transparent,
      appBar: showNavBar
          ? EyeNavBar(
              title: title,
              titleWidget: titleWidget,
              leading: leading,
              trailing: trailing,
              onBack: back ? () => router.pop() : null,
              hasDrawer: menu != null,
              bottom: statusBottom,
            )
          : null,
      drawer: menu,
      drawerEnableOpenDragGesture: menu != null,
      body: body,
      floatingActionButton: primaryAction,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );

    if (keyboardInset) {
      content = EyeKeyboardInset(child: content);
    }

    return content;
  }
}
