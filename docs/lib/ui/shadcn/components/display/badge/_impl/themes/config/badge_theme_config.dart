// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

// ═══════════════════════════════════════════════════════════
// COMPONENT THEME CONFIG
// Registration wiring (do not edit manually)
// ═══════════════════════════════════════════════════════════

import '../../../badge.dart';
import 'badge_theme_defaults.dart';
import 'badge_theme_tokens.dart';

class BadgeThemeConfig {
  const BadgeThemeConfig._();

  static const BadgeTheme? global = null;
  static const String globalType = 'BadgeTheme';
  static const BadgeThemeDefaults defaults = BadgeThemeDefaults();
  static const BadgeThemeTokens tokens = badgeThemeTokens;

  static final Map<Type, Object?> _resolveByType = <Type, Object?>{
    BadgeTheme: global,
  };

  static T? resolve<T extends BadgeTheme>() {
    return _resolveByType[T] as T?;
  }
}
