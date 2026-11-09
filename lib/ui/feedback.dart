import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:eye/ui/glass.dart';
import 'package:eye/ui/icons.dart';
import 'package:eye/ui/theme.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.subtitle,
  });

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = context.eyeTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: theme.sectionLabel),
          if (subtitle != null) ...[
            const SizedBox(height: 2),
            Text(subtitle!, style: theme.caption),
          ],
        ],
      ),
    );
  }
}

class InlineMessage extends StatelessWidget {
  const InlineMessage.error(this.text, {super.key}) : tone = _Tone.error;

  const InlineMessage.info(this.text, {super.key}) : tone = _Tone.info;

  final String text;
  final _Tone tone;

  @override
  Widget build(BuildContext context) {
    final (bg, fg, icon) = switch (tone) {
      _Tone.error => (
          context.eyeTheme.error.withValues(alpha: 0.18),
          context.eyeTheme.error,
          EyeIcons.exclamation,
        ),
      _Tone.info => (
          context.eyeTheme.primary.withValues(alpha: 0.15),
          context.eyeTheme.primary,
          EyeIcons.info,
        ),
    };

    return DecoratedBox(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: fg.withValues(alpha: 0.35)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 20, color: fg),
            const SizedBox(width: 8),
            Expanded(child: Text(text, style: TextStyle(color: fg, fontSize: 15))),
          ],
        ),
      ),
    );
  }
}

enum _Tone { error, info }

class EyeProgressBar extends StatelessWidget {
  const EyeProgressBar({super.key, required this.value});

  final double value;

  @override
  Widget build(BuildContext context) {
    final theme = context.eyeTheme;
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: SizedBox(
        height: 4,
        child: Stack(
          fit: StackFit.expand,
          children: [
            ColoredBox(color: theme.fill),
            FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: value.clamp(0.0, 1.0),
              child: ColoredBox(color: theme.primary),
            ),
          ],
        ),
      ),
    );
  }
}

class EyeSpinner extends StatefulWidget {
  const EyeSpinner({super.key, this.size = 22, this.color});

  final double size;
  final Color? color;

  @override
  State<EyeSpinner> createState() => _EyeSpinnerState();
}

class _EyeSpinnerState extends State<EyeSpinner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 850),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? context.eyeTheme.primary;
    final dim = widget.size;
    return SizedBox(
      width: dim,
      height: dim,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.rotate(
            angle: _controller.value * math.pi * 2,
            child: child,
          );
        },
        child: CustomPaint(
          size: Size(dim, dim),
          painter: _EyeSpinnerPainter(color: color),
        ),
      ),
    );
  }
}

class _EyeSpinnerPainter extends CustomPainter {
  _EyeSpinnerPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final side = math.min(size.width, size.height);
    final stroke = (side * 0.09).clamp(2.0, 3.0);
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (side - stroke) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final track = Paint()
      ..color = color.withValues(alpha: 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..isAntiAlias = true;
    canvas.drawCircle(center, radius, track);

    final arc = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;

    const sweep = math.pi * 0.72;
    const start = -math.pi / 2;
    canvas.drawArc(rect, start, sweep, false, arc);
  }

  @override
  bool shouldRepaint(_EyeSpinnerPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}

class EyeChip extends StatelessWidget {
  const EyeChip({
    super.key,
    required this.label,
    this.selected = false,
    this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = context.eyeTheme;
    final enabled = onTap != null;

    return Opacity(
      opacity: enabled ? 1 : 0.6,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Ink(
            decoration: Glass.chip(context, selected: selected),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Text(
                label,
                style: TextStyle(
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                  fontSize: 14,
                  color: selected ? theme.primary : theme.label,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class EyeEmptyState extends StatelessWidget {
  const EyeEmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.message,
    this.action,
  });

  final IconData icon;
  final String title;
  final String? message;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final theme = context.eyeTheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: GlassPanel(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 56, color: theme.primary.withValues(alpha: 0.85)),
              const SizedBox(height: 16),
              Text(
                title,
                textAlign: TextAlign.center,
                style: theme.titleLarge.copyWith(fontSize: 20),
              ),
              if (message != null) ...[
                const SizedBox(height: 8),
                Text(
                  message!,
                  textAlign: TextAlign.center,
                  style: theme.caption.copyWith(fontSize: 15),
                ),
              ],
              if (action != null) ...[
                const SizedBox(height: 20),
                action!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
