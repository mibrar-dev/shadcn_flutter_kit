// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

// ═══════════════════════════════════════════════════════════
// COMPONENT THEME CONFIG
// Registration wiring (do not edit manually)
// ═══════════════════════════════════════════════════════════

import '../../../star_rating.dart';
import 'star_rating_theme_defaults.dart';
import 'star_rating_theme_tokens.dart';

class StarRatingThemeConfig {
  const StarRatingThemeConfig._();

  static const StarRatingTheme? global = null;
  static const String globalType = 'StarRatingTheme';
  static const StarRatingThemeDefaults defaults = StarRatingThemeDefaults();
  static const StarRatingThemeTokens tokens = starRatingThemeTokens;

  static final Map<Type, Object?> _resolveByType = <Type, Object?>{
    StarRatingTheme: global,
  };

  static T? resolve<T extends StarRatingTheme>() {
    return _resolveByType[T] as T?;
  }
}
