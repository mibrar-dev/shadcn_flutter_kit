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
