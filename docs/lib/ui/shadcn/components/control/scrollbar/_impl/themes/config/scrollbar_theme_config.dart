// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

// ═══════════════════════════════════════════════════════════
// COMPONENT THEME CONFIG
// Registration wiring (do not edit manually)
// ═══════════════════════════════════════════════════════════

import '../../../scrollbar.dart';
import 'scrollbar_theme_defaults.dart';
import 'scrollbar_theme_tokens.dart';

class ScrollbarThemeConfig {
  const ScrollbarThemeConfig._();

  static const ScrollbarTheme? global = null;
  static const String globalType = 'ScrollbarTheme';
  static const ScrollbarThemeDefaults defaults = ScrollbarThemeDefaults();
  static const ScrollbarThemeTokens tokens = scrollbarThemeTokens;

  static final Map<Type, Object?> _resolveByType = <Type, Object?>{
    ScrollbarTheme: global,
  };

  static T? resolve<T extends ScrollbarTheme>() {
    return _resolveByType[T] as T?;
  }
}
