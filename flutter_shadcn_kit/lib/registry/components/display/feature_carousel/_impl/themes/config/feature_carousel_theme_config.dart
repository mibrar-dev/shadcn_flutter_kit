// ═══════════════════════════════════════════════════════════
// COMPONENT THEME CONFIG
// Registration wiring (do not edit manually)
// ═══════════════════════════════════════════════════════════

import '../../../feature_carousel.dart';
import 'feature_carousel_theme_defaults.dart';
import 'feature_carousel_theme_tokens.dart';

class FeatureCarouselThemeConfig {
  const FeatureCarouselThemeConfig._();

  static const FeatureCarouselThemeData? global = null;
  static const String globalType = 'FeatureCarouselTheme';
  static const FeatureCarouselThemeDefaults defaults =
      FeatureCarouselThemeDefaults();
  static const FeatureCarouselThemeTokens tokens = featureCarouselThemeTokens;

  static final Map<Type, Object?> _resolveByType = <Type, Object?>{
    FeatureCarouselThemeData: global,
  };

  static T? resolve<T extends FeatureCarouselThemeData>() {
    return _resolveByType[T] as T?;
  }
}
