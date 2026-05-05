// ═══════════════════════════════════════════════════════════
// COMPONENT THEME CONFIG
// Registration wiring (do not edit manually)
// ═══════════════════════════════════════════════════════════

import '../../../scrollable.dart';
import 'scrollable_theme_defaults.dart';
import 'scrollable_theme_tokens.dart';

class ScrollableThemeConfig {
  const ScrollableThemeConfig._();

  static const ScrollableClientTheme? scrollableClientTheme = null;
  static const String scrollableClientThemeType = 'ScrollableClientTheme';
  static const ScrollableClientThemeDefaults scrollableClientThemeDefaults =
      ScrollableClientThemeDefaults();
  static const ScrollableClientThemeTokens scrollableClientThemeTokenConfig =
      scrollableClientThemeTokens;

  static final Map<Type, Object?> _resolveByType = <Type, Object?>{
    ScrollableClientTheme: scrollableClientTheme,
  };

  static T? resolve<T>() {
    return _resolveByType[T] as T?;
  }
}
