// ═══════════════════════════════════════════════════════════
// COMPONENT THEME CONFIG
// Registration wiring (do not edit manually)
// ═══════════════════════════════════════════════════════════

import '../../../circular_progress_indicator.dart';
import 'circular_progress_indicator_theme_defaults.dart';
import 'circular_progress_indicator_theme_tokens.dart';

class CircularProgressIndicatorThemeConfig {
  const CircularProgressIndicatorThemeConfig._();

  static const CircularProgressIndicatorTheme? global = null;
  static const String globalType = 'CircularProgressIndicatorTheme';
  static const CircularProgressIndicatorThemeDefaults defaults =
      CircularProgressIndicatorThemeDefaults();
  static const CircularProgressIndicatorThemeTokens tokens =
      circularProgressIndicatorThemeTokens;

  static final Map<Type, Object?> _resolveByType = <Type, Object?>{
    CircularProgressIndicatorTheme: global,
  };

  static T? resolve<T extends CircularProgressIndicatorTheme>() {
    return _resolveByType[T] as T?;
  }
}
