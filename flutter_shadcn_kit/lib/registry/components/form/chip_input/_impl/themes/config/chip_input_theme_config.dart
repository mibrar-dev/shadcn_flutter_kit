// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

// ═══════════════════════════════════════════════════════════
// COMPONENT THEME CONFIG
// Registration wiring (do not edit manually)
// ═══════════════════════════════════════════════════════════

import '../../../chip_input.dart';
import 'chip_input_theme_defaults.dart';
import 'chip_input_theme_tokens.dart';

class ChipInputThemeConfig {
  const ChipInputThemeConfig._();

  static const ChipInputTheme? global = null;
  static const String globalType = 'ChipInputTheme';
  static const ChipInputThemeDefaults defaults = ChipInputThemeDefaults();
  static const ChipInputThemeTokens tokens = chipInputThemeTokens;

  static final Map<Type, Object?> _resolveByType = <Type, Object?>{
    ChipInputTheme: global,
  };

  static T? resolve<T extends ChipInputTheme>() {
    return _resolveByType[T] as T?;
  }
}
