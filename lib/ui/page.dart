import 'package:flutter/material.dart';

class EyePage<T> extends Page<T> {
  const EyePage({
    required this.child,
    super.key,
    super.name,
    super.arguments,
    super.restorationId,
  });

  final Widget child;

  @override
  Route<T> createRoute(BuildContext context) {
    return PageRouteBuilder<T>(
      settings: this,
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final offsetTween = Tween<Offset>(
          begin: const Offset(0.04, 0),
          end: Offset.zero,
        );
        return FadeTransition(
          opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
          child: SlideTransition(
            position: offsetTween.animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
            ),
            child: child,
          ),
        );
      },
    );
  }
}

/// Full-screen modal route with scrim — Material dialog presentation, glass content.
class EyeDialogPage<T> extends Page<T> {
  const EyeDialogPage({
    required this.child,
    this.barrierDismissible = true,
    super.key,
    super.name,
    super.arguments,
    super.restorationId,
  });

  final Widget child;
  final bool barrierDismissible;

  @override
  Route<T> createRoute(BuildContext context) {
    return PageRouteBuilder<T>(
      settings: this,
      opaque: false,
      barrierDismissible: barrierDismissible,
      barrierColor: const Color(0x99000000),
      pageBuilder: (context, animation, secondaryAnimation) {
        return _EyeModalScaffold(
          animation: animation,
          align: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: child,
        );
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curve = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
        return FadeTransition(
          opacity: curve,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.94, end: 1).animate(curve),
            child: child,
          ),
        );
      },
    );
  }
}

/// Modal bottom route — Material bottom sheet semantics, glass surface.
class EyeSheetPage<T> extends Page<T> {
  const EyeSheetPage({
    required this.child,
    super.key,
    super.name,
    super.arguments,
    super.restorationId,
  });

  final Widget child;

  @override
  Route<T> createRoute(BuildContext context) {
    return PageRouteBuilder<T>(
      settings: this,
      opaque: false,
      barrierDismissible: true,
      barrierColor: const Color(0x99000000),
      pageBuilder: (context, animation, secondaryAnimation) {
        return _EyeModalScaffold(
          animation: animation,
          align: Alignment.bottomCenter,
          padding: EdgeInsets.zero,
          child: child,
        );
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final offset = Tween<Offset>(
          begin: const Offset(0, 1),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic));
        return SlideTransition(position: offset, child: child);
      },
    );
  }
}

class _EyeModalScaffold extends StatelessWidget {
  const _EyeModalScaffold({
    required this.animation,
    required this.align,
    required this.padding,
    required this.child,
  });

  final Animation<double> animation;
  final Alignment align;
  final EdgeInsetsGeometry padding;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: align,
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}
