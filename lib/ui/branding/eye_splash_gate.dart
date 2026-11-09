import 'package:eye/ui/branding/eye_logo.dart';
import 'package:eye/ui/glass.dart';
import 'package:flutter/material.dart';

/// Cross-fades from the native splash (closed eye) into the app chrome.
class EyeSplashGate extends StatefulWidget {
  const EyeSplashGate({
    super.key,
    required this.child,
    this.openDuration = const Duration(milliseconds: 650),
    this.crossfadeDuration = const Duration(milliseconds: 380),
  });

  final Widget child;
  final Duration openDuration;
  final Duration crossfadeDuration;

  @override
  State<EyeSplashGate> createState() => _EyeSplashGateState();
}

class _EyeSplashGateState extends State<EyeSplashGate>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _open;
  late final Animation<double> _handoff;
  var _finished = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _open = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0, 0.72, curve: Curves.easeOutCubic),
    );
    _handoff = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.55, 1, curve: Curves.easeInOut),
    );
    _run();
  }

  Future<void> _run() async {
    _controller.duration = widget.openDuration + widget.crossfadeDuration;
    await _controller.forward();
    if (mounted) setState(() => _finished = true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_finished) return widget.child;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Stack(
          fit: StackFit.expand,
          children: [
            Opacity(opacity: _handoff.value, child: widget.child),
            Opacity(
              opacity: 1 - _handoff.value,
              child: GlassBackground(
                child: Center(
                  child: EyeLogo.themed(
                    context,
                    openAmount: _open.value,
                    size: 120,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
