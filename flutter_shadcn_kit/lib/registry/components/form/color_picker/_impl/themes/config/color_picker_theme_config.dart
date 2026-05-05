// ═══════════════════════════════════════════════════════════
// COMPONENT THEME CONFIG
// Registration wiring (do not edit manually)
// ═══════════════════════════════════════════════════════════

import '../../../color_picker.dart';
import 'color_picker_theme_defaults.dart';
import 'color_picker_theme_tokens.dart';

class ColorPickerThemeConfig {
  const ColorPickerThemeConfig._();

  static const ColorPickerTheme? global = null;
  static const String globalType = 'ColorPickerTheme';
  static const ColorPickerThemeDefaults defaults = ColorPickerThemeDefaults();
  static const ColorPickerThemeTokens tokens = colorPickerThemeTokens;

  static final Map<Type, Object?> _resolveByType = <Type, Object?>{
    ColorPickerTheme: global,
  };

  static T? resolve<T extends ColorPickerTheme>() {
    return _resolveByType[T] as T?;
  }
}
