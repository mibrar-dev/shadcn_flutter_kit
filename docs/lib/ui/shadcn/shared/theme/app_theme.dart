// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'dart:ui' show Brightness;

import 'app_theme_preset.dart';
import 'preset_themes.dart';
import 'theme.dart';

/// AppTheme composes global [ThemeData] from installed preset payload.
class AppTheme {
  /// Builds light theme from installed preset.
  static ThemeData light() {
    return _build(
      preset: InstalledThemePreset.current,
      brightness: Brightness.light,
    );
  }

  /// Builds dark theme from installed preset.
  static ThemeData dark() {
    return _build(
      preset: InstalledThemePreset.current,
      brightness: Brightness.dark,
    );
  }

  static ThemeData _build({
    required RegistryThemePreset preset,
    required Brightness brightness,
  }) {
    final tokens = brightness == Brightness.dark
        ? preset.darkTokens
        : preset.lightTokens;
    final colorScheme = brightness == Brightness.dark
        ? preset.dark
        : preset.light;

    final base = ThemeData(
      colorScheme: colorScheme,
      radius: tokens.radius,
      density: tokens.density,
      spacing: tokens.spacing,
      tracking: tokens.tracking,
      shadows: tokens.shadows,
    );

    return base.copyWith(
      colorScheme: () => base.colorScheme,
      typography: () => base.typography,
    );
  }
}
