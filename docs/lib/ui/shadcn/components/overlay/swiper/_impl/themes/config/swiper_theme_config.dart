// ═══════════════════════════════════════════════════════════
// COMPONENT THEME CONFIG
// Registration wiring (do not edit manually)
// ═══════════════════════════════════════════════════════════

import '../../../swiper.dart';
import 'swiper_theme_defaults.dart';
import 'swiper_theme_tokens.dart';

class SwiperThemeConfig {
  const SwiperThemeConfig._();

  static const SwiperTheme? global = null;
  static const String globalType = 'SwiperTheme';
  static const SwiperThemeDefaults defaults = SwiperThemeDefaults();
  static const SwiperThemeTokens tokens = swiperThemeTokens;

  static final Map<Type, Object?> _resolveByType = <Type, Object?>{
    SwiperTheme: global,
  };

  static T? resolve<T extends SwiperTheme>() {
    return _resolveByType[T] as T?;
  }
}
