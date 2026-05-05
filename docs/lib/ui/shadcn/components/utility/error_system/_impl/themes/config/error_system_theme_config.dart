// ═══════════════════════════════════════════════════════════
// COMPONENT THEME CONFIG
// Registration wiring (do not edit manually)
// ═══════════════════════════════════════════════════════════

import '../../../error_system.dart';
import 'error_system_theme_defaults.dart';
import 'error_system_theme_tokens.dart';

class ErrorSystemThemeConfig {
  const ErrorSystemThemeConfig._();

  static const ErrorSystemTheme? global = null;
  static const String globalType = 'ErrorSystemTheme';
  static const ErrorSystemThemeDefaults defaults = ErrorSystemThemeDefaults();
  static const ErrorSystemThemeTokens tokens = errorSystemThemeTokens;

  static final Map<Type, Object?> _resolveByType = <Type, Object?>{
    ErrorSystemTheme: global,
  };

  static T? resolve<T extends ErrorSystemTheme>() {
    return _resolveByType[T] as T?;
  }
}
