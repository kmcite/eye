import 'package:eye/business/dark_notifier.dart';
import 'package:flutter/material.dart';

Brightness resolveEyeBrightness({
  required bool? darkPreference,
  required Brightness platform,
}) {
  return switch (darkPreference) {
    true => Brightness.dark,
    false => Brightness.light,
    null => platform,
  };
}

EyeThemeData resolveEyeThemeData([BuildContext? context]) {
  final dark = darkNotifierProvider();
  final platform = context != null
      ? MediaQuery.platformBrightnessOf(context)
      : WidgetsBinding.instance.platformDispatcher.platformBrightness;
  return EyeThemeData(
    brightness: resolveEyeBrightness(
      darkPreference: dark.dark(),
      platform: platform,
    ),
  );
}

class EyeThemeData {
  const EyeThemeData({required this.brightness});

  final Brightness brightness;

  bool get isDark => brightness == Brightness.dark;

  Color get primary =>
      isDark ? const Color(0xFF7B8CFF) : const Color(0xFF4A5FC1);

  Color get scaffoldBackground =>
      isDark ? const Color(0xFF0C0C10) : const Color(0xFFE9EEF8);

  Color get label => isDark ? const Color(0xFFF2F2F7) : const Color(0xFF0C0C10);

  Color get secondaryLabel =>
      isDark ? const Color(0xFFAEAEB2) : const Color(0xFF636366);

  Color get separator =>
      isDark ? const Color(0x33FFFFFF) : const Color(0x1A000000);

  Color get fill => isDark ? const Color(0xFF2C2C34) : const Color(0xFFE8E8ED);

  Color get fillSecondary =>
      isDark ? const Color(0xFF3A3A42) : const Color(0xFFD1D1D6);

  Color get error => const Color(0xFFFF453A);

  Color get success => const Color(0xFF32D74B);

  Color get warning => const Color(0xFFFFD60A);

  Color get onPrimary => const Color(0xFFFFFFFF);

  TextStyle get body =>
      TextStyle(fontSize: 17, height: 1.35, color: label);

  TextStyle get bodySmall =>
      TextStyle(fontSize: 15, height: 1.3, color: label);

  TextStyle get caption =>
      TextStyle(fontSize: 13, height: 1.25, color: secondaryLabel);

  TextStyle get navTitle => TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w600,
        color: label,
        decoration: TextDecoration.none,
      );

  TextStyle get titleLarge =>
      TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: label);

  /// Headings that must not inherit Material [TextDecoration.underline].
  TextStyle titleStyle({
    double fontSize = 22,
    Color? color,
    FontWeight fontWeight = FontWeight.w700,
    double? letterSpacing,
  }) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color ?? label,
      letterSpacing: letterSpacing,
      decoration: TextDecoration.none,
      decorationThickness: 0,
      inherit: false,
    );
  }

  TextStyle get sectionLabel => TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.3,
        color: primary,
      );

  /// Material 3 theme wired to liquid-glass tokens (no backdrop blur).
  ThemeData toMaterialTheme() {
    final scheme = ColorScheme.fromSeed(
      seedColor: primary,
      brightness: brightness,
      surface: scaffoldBackground,
      error: error,
    );

    final radius = BorderRadius.circular(12);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: Colors.transparent,
      canvasColor: Colors.transparent,
      dividerColor: separator,
      splashFactory: InkSparkle.splashFactory,
      textTheme: TextTheme(
        bodyLarge: body,
        bodyMedium: bodySmall,
        bodySmall: caption,
        titleLarge: titleLarge,
        titleMedium: navTitle,
        labelSmall: sectionLabel,
      ),
      iconTheme: IconThemeData(color: label, size: 22),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: fill.withValues(alpha: isDark ? 0.45 : 0.65),
        hintStyle: bodySmall.copyWith(color: secondaryLabel),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(borderRadius: radius, borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(
          borderRadius: radius,
          borderSide: BorderSide(
            color: isDark
                ? const Color(0xFFFFFFFF).withValues(alpha: 0.12)
                : const Color(0xFFFFFFFF).withValues(alpha: 0.75),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: radius,
          borderSide: BorderSide(color: primary.withValues(alpha: 0.85), width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: radius,
          borderSide: BorderSide(color: error.withValues(alpha: 0.7)),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: onPrimary,
          disabledBackgroundColor: primary.withValues(alpha: 0.35),
          minimumSize: const Size(64, 48),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primary,
          minimumSize: const Size(44, 44),
          textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: label,
          minimumSize: const Size(44, 44),
          iconSize: 22,
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) => onPrimary),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return primary;
          }
          return fillSecondary;
        }),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          visualDensity: VisualDensity.compact,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          ),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Colors.transparent,
        elevation: 0,
        showDragHandle: true,
      ),
      drawerTheme: const DrawerThemeData(
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        foregroundColor: label,
        titleTextStyle: titleStyle(fontSize: 20),
        iconTheme: IconThemeData(color: label, size: 24),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primary,
        foregroundColor: onPrimary,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      listTileTheme: ListTileThemeData(
        iconColor: label,
        textColor: label,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: radius),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(color: primary),
      chipTheme: ChipThemeData(
        backgroundColor: fill,
        selectedColor: primary.withValues(alpha: 0.22),
        labelStyle: bodySmall.copyWith(fontSize: 14),
        side: BorderSide(color: separator),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}

class EyeTheme extends InheritedWidget {
  const EyeTheme({
    super.key,
    required this.data,
    required super.child,
  });

  final EyeThemeData data;

  static EyeThemeData of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<EyeTheme>();
    assert(scope != null, 'No EyeTheme found in context');
    return scope!.data;
  }

  static EyeThemeData? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<EyeTheme>()?.data;
  }

  @override
  bool updateShouldNotify(EyeTheme oldWidget) => data != oldWidget.data;
}

extension EyeThemeBuildContext on BuildContext {
  EyeThemeData get eyeTheme => EyeTheme.of(this);
}
