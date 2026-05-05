// ═══════════════════════════════════════════════════════════
// COMPONENT THEME CONFIG
// Registration wiring (do not edit manually)
// ═══════════════════════════════════════════════════════════

import '../../../spinner.dart';
import 'spinner_theme_defaults.dart';
import 'spinner_theme_tokens.dart';

class SpinnerThemeConfig {
  const SpinnerThemeConfig._();

  static const SpinnerTheme? global = null;
  static const String globalType = 'SpinnerTheme';
  static const SpinnerThemeDefaults defaults = SpinnerThemeDefaults();
  static const SpinnerThemeTokens tokens = spinnerThemeTokens;

  static final Map<Type, Object?> _resolveByType = <Type, Object?>{
    SpinnerTheme: global,
  };

  static T? resolve<T extends SpinnerTheme>() {
    return _resolveByType[T] as T?;
  }
}
