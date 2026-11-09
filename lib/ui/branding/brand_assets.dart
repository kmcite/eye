/// Bundled brand artwork (see [test/generate_brand_assets_test.dart]).
abstract final class BrandAssets {
  static const directory = 'assets/branding';

  /// Open eye — launcher / marketing (1024×1024).
  static const appIcon1024 = '$directory/app_icon_1024.png';

  /// Closed eye — matches native splash first frame (1024×1024).
  static const eyeClosed1024 = '$directory/eye_closed_1024.png';

  /// Foreground layer for Android adaptive icon (transparent, 1024×1024).
  static const appIconForeground1024 = '$directory/app_icon_foreground_1024.png';
}
