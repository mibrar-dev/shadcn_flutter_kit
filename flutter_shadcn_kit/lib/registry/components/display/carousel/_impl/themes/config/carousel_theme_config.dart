// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

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
