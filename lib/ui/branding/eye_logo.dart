import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

import 'package:eye/ui/theme.dart';

/// Duotone brand palette (matches Android `@color/eye_*`).
abstract final class EyeBrandColors {
  static const iris = Color(0xFF5B6FD6);
  static const irisSoft = Color(0xFF9AA8E8);
  static const ink = Color(0xFF2D3142);
  static const paper = Color(0xFFF0F2FA);
}

/// Brand mark: lids open from [openAmount] `0` (closed) → `1` (fully open).
class EyeLogo extends StatelessWidget {
  const EyeLogo({
    super.key,
    required this.openAmount,
    this.size = 96,
    Color? tonePrimary,
    Color? toneSecondary,
    Color? ink,
    this.showGlow = false,
  })  : tonePrimary = tonePrimary ?? EyeBrandColors.iris,
        toneSecondary = toneSecondary ?? EyeBrandColors.irisSoft,
        ink = ink ?? EyeBrandColors.ink;

  final double openAmount;
  final double size;
  final Color tonePrimary;
  final Color toneSecondary;
  final Color ink;
  final bool showGlow;

  factory EyeLogo.themed(
    BuildContext context, {
    required double openAmount,
    double size = 96,
    bool showGlow = false,
  }) {
    final theme = EyeTheme.of(context);
    return EyeLogo(
      openAmount: openAmount,
      size: size,
      tonePrimary: theme.primary,
      toneSecondary: theme.isDark
          ? const Color(0xFF9AA8E8)
          : const Color(0xFF7B8CFF),
      ink: theme.label,
      showGlow: showGlow,
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.square(size),
      painter: EyeLogoPainter(
        openAmount: openAmount.clamp(0, 1),
        tonePrimary: tonePrimary,
        toneSecondary: toneSecondary,
        ink: ink,
        showGlow: showGlow,
      ),
    );
  }
}

class EyeLogoPainter extends CustomPainter {
  EyeLogoPainter({
    required this.openAmount,
    required this.tonePrimary,
    required this.toneSecondary,
    required this.ink,
    required this.showGlow,
  });

  final double openAmount;
  final Color tonePrimary;
  final Color toneSecondary;
  final Color ink;
  final bool showGlow;

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final w = size.width * 0.8;
    final h = size.height * 0.46;

    final almond = _almondPath(cx, cy, w, h);

    if (showGlow && openAmount > 0.1) {
      final glow = Paint()
        ..color = tonePrimary.withValues(alpha: 0.2 * openAmount)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
      canvas.drawCircle(Offset(cx, cy), w * 0.28, glow);
    }

    canvas.drawPath(
      almond,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [EyeBrandColors.paper, toneSecondary.withValues(alpha: 0.35)],
        ).createShader(Rect.fromCircle(center: Offset(cx, cy), radius: w / 2)),
    );

    canvas.drawPath(
      almond,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = size.width * 0.022
        ..color = ink.withValues(alpha: 0.35),
    );

    final irisR = lerpDouble(w * 0.06, w * 0.2, openAmount)!;
    if (openAmount > 0.02) {
      canvas.save();
      canvas.clipPath(almond);
      canvas.drawCircle(
        Offset(cx, cy),
        irisR,
        Paint()..color = tonePrimary.withValues(alpha: openAmount),
      );
      canvas.drawCircle(
        Offset(cx, cy),
        irisR,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = size.width * 0.018
          ..color = toneSecondary.withValues(alpha: 0.85 * openAmount),
      );
      canvas.drawCircle(
        Offset(cx, cy),
        irisR * 0.42,
        Paint()..color = ink.withValues(alpha: 0.9 * openAmount),
      );
      canvas.drawCircle(
        Offset(cx - irisR * 0.22, cy - irisR * 0.25),
        irisR * 0.14,
        Paint()..color = Colors.white.withValues(alpha: 0.5 * openAmount),
      );
      canvas.restore();
    }

    final gap = lerpDouble(0.015, h * 0.9, openAmount)!;
    final lid = Paint()..color = ink;
    canvas.drawPath(_upperLid(cx, cy, w, h, gap), lid);
    canvas.drawPath(_lowerLid(cx, cy, w, h, gap), lid);
  }

  Path _almondPath(double cx, double cy, double w, double h) => Path()
    ..moveTo(cx - w / 2, cy)
    ..quadraticBezierTo(cx - w * 0.18, cy - h * 0.82, cx, cy - h / 2)
    ..quadraticBezierTo(cx + w * 0.18, cy - h * 0.82, cx + w / 2, cy)
    ..quadraticBezierTo(cx + w * 0.18, cy + h * 0.82, cx, cy + h / 2)
    ..quadraticBezierTo(cx - w * 0.18, cy + h * 0.82, cx - w / 2, cy)
    ..close();

  Path _upperLid(double cx, double cy, double w, double h, double gap) => Path()
    ..moveTo(cx - w / 2 - 2, cy)
    ..quadraticBezierTo(cx - w * 0.14, cy - h * 0.92, cx, cy - h / 2)
    ..quadraticBezierTo(cx + w * 0.14, cy - h * 0.92, cx + w / 2 + 2, cy)
    ..lineTo(cx + w / 2 + 2, cy - gap / 2)
    ..quadraticBezierTo(cx, cy - gap / 2 - h * 0.12, cx - w / 2 - 2, cy - gap / 2)
    ..close();

  Path _lowerLid(double cx, double cy, double w, double h, double gap) => Path()
    ..moveTo(cx - w / 2 - 2, cy)
    ..quadraticBezierTo(cx - w * 0.14, cy + h * 0.92, cx, cy + h / 2)
    ..quadraticBezierTo(cx + w * 0.14, cy + h * 0.92, cx + w / 2 + 2, cy)
    ..lineTo(cx + w / 2 + 2, cy + gap / 2)
    ..quadraticBezierTo(cx, cy + gap / 2 + h * 0.12, cx - w / 2 - 2, cy + gap / 2)
    ..close();

  @override
  bool shouldRepaint(covariant EyeLogoPainter oldDelegate) {
    return oldDelegate.openAmount != openAmount ||
        oldDelegate.tonePrimary != tonePrimary ||
        oldDelegate.toneSecondary != toneSecondary ||
        oldDelegate.ink != ink;
  }
}
