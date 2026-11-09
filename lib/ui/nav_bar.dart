import 'package:flutter/material.dart';

import 'package:eye/ui/glass.dart';
import 'package:eye/ui/theme.dart';

class EyeNavBar extends StatelessWidget implements PreferredSizeWidget {
  const EyeNavBar({
    super.key,
    this.title,
    this.titleWidget,
    this.leading,
    this.trailing,
    this.onBack,
    this.hasDrawer = false,
    this.bottom,
  });

  static const barHeight = 56.0;

  final String? title;
  final Widget? titleWidget;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onBack;
  final bool hasDrawer;
  final PreferredSizeWidget? bottom;

  @override
  Size get preferredSize => Size.fromHeight(
        barHeight + (bottom?.preferredSize.height ?? 0),
      );

  @override
  Widget build(BuildContext context) {
    final theme = context.eyeTheme;

    Widget? lead = leading;
    if (lead == null && onBack != null) {
      lead = IconButton(
        onPressed: onBack,
        tooltip: 'Back',
        icon: const Icon(Icons.arrow_back_rounded),
      );
    }

    return AppBar(
      title: titleWidget ??
          (title != null
              ? Text(
                  title!,
                  style: theme.titleStyle(fontSize: 20),
                )
              : null),
      leading: lead,
      automaticallyImplyLeading: onBack != null || hasDrawer,
      actions: [
        if (trailing != null)
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 8),
            child: trailing!,
          ),
      ],
      actionsPadding: EdgeInsets.zero,
      centerTitle: false,
      scrolledUnderElevation: 0,
      elevation: 0,
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      foregroundColor: theme.label,
      flexibleSpace: DecoratedBox(
        decoration: Glass.navBar(context, includeBottomHairline: bottom == null),
      ),
      bottom: bottom,
    );
  }
}
