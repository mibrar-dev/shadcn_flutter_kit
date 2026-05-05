// ═══════════════════════════════════════════════════════════
// COMPONENT THEME CONFIG
// Registration wiring (do not edit manually)
// ═══════════════════════════════════════════════════════════

import '../../../divider.dart';
import 'divider_theme_defaults.dart';
import 'divider_theme_tokens.dart';

class DividerThemeConfig {
  const DividerThemeConfig._();

  static const DividerTheme? global = null;
  static const String globalType = 'DividerTheme';
  static const DividerThemeDefaults defaults = DividerThemeDefaults();
  static const DividerThemeTokens tokens = dividerThemeTokens;

  static final Map<Type, Object?> _resolveByType = <Type, Object?>{
    DividerTheme: global,
  };

  static T? resolve<T extends DividerTheme>() {
    return _resolveByType[T] as T?;
  }
}
