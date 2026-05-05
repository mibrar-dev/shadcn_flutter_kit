// ═══════════════════════════════════════════════════════════
// COMPONENT THEME CONFIG
// Registration wiring (do not edit manually)
// ═══════════════════════════════════════════════════════════

import '../../../linear_progress_indicator.dart';
import 'linear_progress_indicator_theme_defaults.dart';
import 'linear_progress_indicator_theme_tokens.dart';

class LinearProgressIndicatorThemeConfig {
  const LinearProgressIndicatorThemeConfig._();

  static const LinearProgressIndicatorTheme? global = null;
  static const String globalType = 'LinearProgressIndicatorTheme';
  static const LinearProgressIndicatorThemeDefaults defaults =
      LinearProgressIndicatorThemeDefaults();
  static const LinearProgressIndicatorThemeTokens tokens =
      linearProgressIndicatorThemeTokens;

  static final Map<Type, Object?> _resolveByType = <Type, Object?>{
    LinearProgressIndicatorTheme: global,
  };

  static T? resolve<T extends LinearProgressIndicatorTheme>() {
    return _resolveByType[T] as T?;
  }
}
