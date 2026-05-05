// ═══════════════════════════════════════════════════════════
// COMPONENT THEME CONFIG
// Registration wiring (do not edit manually)
// ═══════════════════════════════════════════════════════════

import '../../../progress.dart';
import 'progress_theme_defaults.dart';
import 'progress_theme_tokens.dart';

class ProgressThemeConfig {
  const ProgressThemeConfig._();

  static const ProgressTheme? global = null;
  static const String globalType = 'ProgressTheme';
  static const ProgressThemeDefaults defaults = ProgressThemeDefaults();
  static const ProgressThemeTokens tokens = progressThemeTokens;

  static final Map<Type, Object?> _resolveByType = <Type, Object?>{
    ProgressTheme: global,
  };

  static T? resolve<T extends ProgressTheme>() {
    return _resolveByType[T] as T?;
  }
}
