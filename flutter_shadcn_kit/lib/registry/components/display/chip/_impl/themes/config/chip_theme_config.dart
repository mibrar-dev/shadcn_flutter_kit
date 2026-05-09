// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

// ═══════════════════════════════════════════════════════════
// COMPONENT THEME CONFIG
// Registration wiring (do not edit manually)
// ═══════════════════════════════════════════════════════════

import '../../../chip.dart';
import 'chip_theme_defaults.dart';
import 'chip_theme_tokens.dart';

class ChipThemeConfig {
  const ChipThemeConfig._();

  static const ChipTheme? global = null;
  static const String globalType = 'ChipTheme';
  static const ChipThemeDefaults defaults = ChipThemeDefaults();
  static const ChipThemeTokens tokens = chipThemeTokens;

  static final Map<Type, Object?> _resolveByType = <Type, Object?>{
    ChipTheme: global,
  };

  static T? resolve<T extends ChipTheme>() {
    return _resolveByType[T] as T?;
  }
}
