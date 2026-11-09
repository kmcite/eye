import 'package:flutter/material.dart';

import 'package:eye/ui/theme.dart';

/// Translucent liquid glass — gradients and borders only (no blur).
abstract final class Glass {
  static bool _isDark(BuildContext context) =>
      EyeTheme.of(context).isDark;

  static Color pageGradientTop(BuildContext context) =>
      _isDark(context) ? const Color(0xFF12121A) : const Color(0xFFE4EAF6);

  static Color pageGradientMid(BuildContext context) =>
      _isDark(context) ? const Color(0xFF0A0A0F) : const Color(0xFFF4F2FA);

  static Color pageGradientBottom(BuildContext context) =>
      _isDark(context) ? const Color(0xFF080B12) : const Color(0xFFDDE9FF);

  static BoxDecoration panel(BuildContext context, {double radius = 18}) {
    final dark = _isDark(context);
    final theme = EyeTheme.of(context);
    return BoxDecoration(
      borderRadius: BorderRadius.circular(radius),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: dark
            ? [
                const Color(0xFF34343E).withValues(alpha: 0.88),
                const Color(0xFF18181F).withValues(alpha: 0.78),
                const Color(0xFF12121A).withValues(alpha: 0.72),
              ]
            : [
                const Color(0xFFFFFFFF).withValues(alpha: 0.92),
                const Color(0xFFF4F6FC).withValues(alpha: 0.72),
                const Color(0xFFE8ECFA).withValues(alpha: 0.58),
              ],
        stops: const [0.0, 0.55, 1.0],
      ),
      border: Border.all(
        color: dark
            ? const Color(0xFFFFFFFF).withValues(alpha: 0.16)
            : const Color(0xFFFFFFFF).withValues(alpha: 0.88),
      ),
      boxShadow: [
        BoxShadow(
          color: theme.label.withValues(alpha: dark ? 0.35 : 0.07),
          blurRadius: 18,
          offset: const Offset(0, 8),
        ),
      ],
    );
  }

  static BoxDecoration navBar(
    BuildContext context, {
    bool includeBottomHairline = true,
  }) {
    return BoxDecoration(
      gradient: navBarGradient(context),
      border: includeBottomHairline ? navBarBorder(context) : null,
    );
  }

  static LinearGradient navBarGradient(BuildContext context) {
    final dark = _isDark(context);
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: dark
          ? [
              const Color(0xFF22222A).withValues(alpha: 0.96),
              const Color(0xFF14141A).withValues(alpha: 0.88),
            ]
          : [
              const Color(0xFFFFFFFF).withValues(alpha: 0.96),
              const Color(0xFFF5F6FC).withValues(alpha: 0.88),
            ],
    );
  }

  static Border navBarBorder(BuildContext context) {
    final dark = _isDark(context);
    return Border(
      bottom: BorderSide(
        color: dark
            ? const Color(0xFFFFFFFF).withValues(alpha: 0.08)
            : const Color(0xFF000000).withValues(alpha: 0.06),
      ),
    );
  }

  static BoxDecoration buttonPrimary(
    BuildContext context, {
    double radius = 14,
  }) {
    final dark = _isDark(context);
    final theme = EyeTheme.of(context);
    return BoxDecoration(
      borderRadius: BorderRadius.circular(radius),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          theme.primary.withValues(alpha: dark ? 0.92 : 0.95),
          theme.primary.withValues(alpha: dark ? 0.72 : 0.82),
        ],
      ),
      border: Border.all(
        color: const Color(0xFFFFFFFF).withValues(alpha: dark ? 0.22 : 0.5),
      ),
      boxShadow: [
        BoxShadow(
          color: theme.primary.withValues(alpha: dark ? 0.35 : 0.28),
          blurRadius: 14,
          offset: const Offset(0, 6),
        ),
      ],
    );
  }

  static BoxDecoration buttonSecondary(
    BuildContext context, {
    double radius = 14,
  }) =>
      panel(context, radius: radius);

  static BoxDecoration buttonOutline(
    BuildContext context, {
    double radius = 14,
  }) {
    final dark = _isDark(context);
    final theme = EyeTheme.of(context);
    return BoxDecoration(
      borderRadius: BorderRadius.circular(radius),
      color: theme.fill.withValues(alpha: dark ? 0.35 : 0.45),
      border: Border.all(
        color: theme.primary.withValues(alpha: 0.55),
        width: 1.25,
      ),
    );
  }

  static BoxDecoration buttonDestructive(
    BuildContext context, {
    double radius = 14,
  }) {
    final theme = EyeTheme.of(context);
    return BoxDecoration(
      borderRadius: BorderRadius.circular(radius),
      gradient: LinearGradient(
        colors: [
          theme.error.withValues(alpha: 0.9),
          theme.error.withValues(alpha: 0.75),
        ],
      ),
      border: Border.all(
        color: const Color(0xFFFFFFFF).withValues(alpha: 0.25),
      ),
    );
  }

  static BoxDecoration chip(BuildContext context, {bool selected = false}) {
    final theme = EyeTheme.of(context);
    if (selected) {
      return BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: theme.primary.withValues(alpha: 0.22),
        border: Border.all(color: theme.primary.withValues(alpha: 0.65)),
      );
    }
    return BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      color: theme.fill.withValues(alpha: 0.55),
      border: Border.all(color: theme.separator),
    );
  }
}

class GlassBackground extends StatelessWidget {
  const GlassBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Glass.pageGradientTop(context),
            Glass.pageGradientMid(context),
            Glass.pageGradientBottom(context),
          ],
        ),
      ),
      child: child,
    );
  }
}

class GlassPanel extends StatelessWidget {
  const GlassPanel({
    super.key,
    required this.child,
    this.padding,
    this.radius = 18,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: Glass.panel(context, radius: radius),
      child: Padding(
        padding: padding ?? const EdgeInsets.all(16),
        child: child,
      ),
    );
  }
}
