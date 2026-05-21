// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

// ═══════════════════════════════════════════════════════════
// COMPONENT THEME CONFIG
// Registration wiring (do not edit manually)
// ═══════════════════════════════════════════════════════════

import '../../../focus_outline.dart';
import 'focus_outline_theme_defaults.dart';
import 'focus_outline_theme_tokens.dart';

class FocusOutlineThemeConfig {
  const FocusOutlineThemeConfig._();

  static const FocusOutlineTheme? global = null;
  static const String globalType = 'FocusOutlineTheme';
  static const FocusOutlineThemeDefaults defaults = FocusOutlineThemeDefaults();
  static const FocusOutlineThemeTokens tokens = focusOutlineThemeTokens;

  static final Map<Type, Object?> _resolveByType = <Type, Object?>{
    FocusOutlineTheme: global,
  };

  static T? resolve<T extends FocusOutlineTheme>() {
    return _resolveByType[T] as T?;
  }
}
