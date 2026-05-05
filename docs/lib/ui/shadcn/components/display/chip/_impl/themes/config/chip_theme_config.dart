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
