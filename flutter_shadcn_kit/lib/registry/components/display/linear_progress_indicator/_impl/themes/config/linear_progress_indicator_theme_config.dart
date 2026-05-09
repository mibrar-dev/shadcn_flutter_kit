// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

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
