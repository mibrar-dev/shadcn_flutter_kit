// ═══════════════════════════════════════════════════════════
// COMPONENT THEME CONFIG
// Registration wiring (do not edit manually)
// ═══════════════════════════════════════════════════════════

import '../../../carousel.dart';
import 'carousel_theme_defaults.dart';
import 'carousel_theme_tokens.dart';

class CarouselThemeConfig {
  const CarouselThemeConfig._();

  static const CarouselTheme? global = null;
  static const String globalType = 'CarouselTheme';
  static const CarouselThemeDefaults defaults = CarouselThemeDefaults();
  static const CarouselThemeTokens tokens = carouselThemeTokens;

  static final Map<Type, Object?> _resolveByType = <Type, Object?>{
    CarouselTheme: global,
  };

  static T? resolve<T extends CarouselTheme>() {
    return _resolveByType[T] as T?;
  }
}
