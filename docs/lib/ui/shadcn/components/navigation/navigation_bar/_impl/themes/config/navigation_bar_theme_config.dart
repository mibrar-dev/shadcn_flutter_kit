// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

// ═══════════════════════════════════════════════════════════
// COMPONENT THEME CONFIG
// Registration wiring (do not edit manually)
// ═══════════════════════════════════════════════════════════

import '../../../navigation_bar.dart';
import 'navigation_bar_theme_defaults.dart';
import 'navigation_bar_theme_tokens.dart';

class NavigationBarThemeConfig {
  const NavigationBarThemeConfig._();

  static const NavigationBarTheme? global = null;
  static const String globalType = 'NavigationBarTheme';
  static const NavigationBarThemeDefaults defaults =
      NavigationBarThemeDefaults();
  static const NavigationBarThemeTokens tokens = navigationBarThemeTokens;

  static final Map<Type, Object?> _resolveByType = <Type, Object?>{
    NavigationBarTheme: global,
  };

  static T? resolve<T extends NavigationBarTheme>() {
    return _resolveByType[T] as T?;
  }
}
