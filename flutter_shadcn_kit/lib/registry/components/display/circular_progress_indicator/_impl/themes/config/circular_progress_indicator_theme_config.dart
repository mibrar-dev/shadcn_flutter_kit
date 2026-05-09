// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

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
