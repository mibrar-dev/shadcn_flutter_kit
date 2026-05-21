// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

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
