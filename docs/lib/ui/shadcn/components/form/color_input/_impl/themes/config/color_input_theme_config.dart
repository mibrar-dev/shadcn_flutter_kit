// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

// ═══════════════════════════════════════════════════════════
// COMPONENT THEME CONFIG
// Registration wiring (do not edit manually)
// ═══════════════════════════════════════════════════════════

import '../../../color_input.dart';
import 'color_input_theme_defaults.dart';
import 'color_input_theme_tokens.dart';

class ColorInputThemeConfig {
  const ColorInputThemeConfig._();

  static const ColorInputTheme? global = null;
  static const String globalType = 'ColorInputTheme';
  static const ColorInputThemeDefaults defaults = ColorInputThemeDefaults();
  static const ColorInputThemeTokens tokens = colorInputThemeTokens;

  static final Map<Type, Object?> _resolveByType = <Type, Object?>{
    ColorInputTheme: global,
  };

  static T? resolve<T extends ColorInputTheme>() {
    return _resolveByType[T] as T?;
  }
}
