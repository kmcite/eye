import 'package:flutter/material.dart';

import 'package:eye/ui/glass.dart';
import 'package:eye/ui/icons.dart';
import 'package:eye/ui/theme.dart';

class _EyeGlassButton extends StatelessWidget {
  const _EyeGlassButton({
    required this.label,
    this.onPressed,
    this.icon,
    this.expand = false,
    required this.decoration,
    required this.foregroundColor,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool expand;
  final BoxDecoration decoration;
  final Color foregroundColor;

  static const _radius = 14.0;
  static const _minHeight = 48.0;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;
    final borderRadius = BorderRadius.circular(_radius);

    final content = Row(
      mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 20, color: foregroundColor),
          const SizedBox(width: 8),
        ],
        Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: foregroundColor,
            ),
          ),
      ],
    );

    final button = Opacity(
      opacity: enabled ? 1 : 0.5,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: borderRadius,
          splashFactory: InkSparkle.splashFactory,
          child: Ink(
            decoration: decoration,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: _minHeight,
                minWidth: expand ? double.infinity : 64,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                child: Center(child: content),
              ),
            ),
          ),
        ),
      ),
    );

    if (expand) {
      return SizedBox(width: double.infinity, child: button);
    }
    return button;
  }
}

class EyePrimaryButton extends StatelessWidget {
  const EyePrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.expand = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    return _EyeGlassButton(
      label: label,
      onPressed: onPressed,
      icon: icon,
      expand: expand,
      decoration: Glass.buttonPrimary(context),
      foregroundColor: context.eyeTheme.onPrimary,
    );
  }
}

class EyeSecondaryButton extends StatelessWidget {
  const EyeSecondaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.expand = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    return _EyeGlassButton(
      label: label,
      onPressed: onPressed,
      icon: icon,
      expand: expand,
      decoration: Glass.buttonSecondary(context),
      foregroundColor: context.eyeTheme.label,
    );
  }
}

class EyeOutlinedButton extends StatelessWidget {
  const EyeOutlinedButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.expand = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    return _EyeGlassButton(
      label: label,
      onPressed: onPressed,
      icon: icon,
      expand: expand,
      decoration: Glass.buttonOutline(context),
      foregroundColor: context.eyeTheme.primary,
    );
  }
}

class EyeDestructiveButton extends StatelessWidget {
  const EyeDestructiveButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.expand = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    return _EyeGlassButton(
      label: label,
      onPressed: onPressed,
      icon: icon,
      expand: expand,
      decoration: Glass.buttonDestructive(context),
      foregroundColor: context.eyeTheme.onPrimary,
    );
  }
}

class EyeTextButton extends StatelessWidget {
  const EyeTextButton({
    super.key,
    required this.label,
    this.onPressed,
    this.color,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final Color? color;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final fg = color ?? context.eyeTheme.primary;
    final enabled = onPressed != null;

    return Opacity(
      opacity: enabled ? 1 : 0.5,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(10),
          splashFactory: InkSparkle.splashFactory,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 18, color: fg),
                  const SizedBox(width: 6),
                ],
                Text(
                  label,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: fg,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class EyeFab extends StatelessWidget {
  const EyeFab({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
  });

  final String label;
  final VoidCallback onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return EyePrimaryButton(
      label: label,
      icon: icon ?? EyeIcons.add,
      onPressed: onPressed,
    );
  }
}

class EyeIconButton extends StatelessWidget {
  const EyeIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.color,
    this.size = 22,
    this.semanticLabel,
    this.glass = false,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final Color? color;
  final double size;
  final String? semanticLabel;
  final bool glass;

  @override
  Widget build(BuildContext context) {
    final theme = context.eyeTheme;
    final fg = color ?? theme.label;

    final iconWidget = Icon(icon, size: size, color: fg);

    if (!glass) {
      return IconButton(
        onPressed: onPressed,
        icon: iconWidget,
        tooltip: semanticLabel,
      );
    }

    return Opacity(
      opacity: onPressed != null ? 1 : 0.5,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Ink(
            decoration: Glass.buttonSecondary(context, radius: 12),
            child: SizedBox(
              width: 44,
              height: 44,
              child: Center(child: iconWidget),
            ),
          ),
        ),
      ),
    );
  }
}

/// Minimum touch target with Material ink splash on glass when [glass] is true.
class EyeTap extends StatelessWidget {
  const EyeTap({
    super.key,
    required this.child,
    this.onPressed,
    this.minSize = 48,
    this.semanticLabel,
    this.semanticButton = true,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
    this.glass = false,
  });

  final Widget child;
  final VoidCallback? onPressed;
  final double minSize;
  final String? semanticLabel;
  final bool semanticButton;
  final BorderRadius borderRadius;
  final bool glass;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;
    return Semantics(
      label: semanticLabel,
      button: semanticButton && semanticLabel != null,
      enabled: enabled,
      child: Opacity(
        opacity: enabled ? 1 : 0.55,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            borderRadius: borderRadius,
            splashFactory: InkSparkle.splashFactory,
            child: glass
                ? Ink(
                    decoration: Glass.buttonSecondary(
                      context,
                      radius: borderRadius.topLeft.x,
                    ),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: minSize,
                        minHeight: minSize,
                      ),
                      child: Center(child: child),
                    ),
                  )
                : ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: minSize,
                      minHeight: minSize,
                    ),
                    child: Center(child: child),
                  ),
          ),
        ),
      ),
    );
  }
}

class EyeListTile extends StatelessWidget {
  const EyeListTile({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
  });

  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: DecoratedBox(
        decoration: Glass.panel(context, radius: 16),
        child: ListTile(
          onTap: onTap,
          leading: leading,
          trailing: trailing,
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
          subtitle:
              subtitle != null ? Text(subtitle!, style: context.eyeTheme.caption) : null,
        ),
      ),
    );
  }
}
