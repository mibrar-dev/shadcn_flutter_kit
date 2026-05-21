// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

// ═══════════════════════════════════════════════════════════
// COMPONENT THEME CONFIG
// Registration wiring (do not edit manually)
// ═══════════════════════════════════════════════════════════

import '../../../dot_indicator.dart';
import 'dot_indicator_theme_defaults.dart';
import 'dot_indicator_theme_tokens.dart';

class DotIndicatorThemeConfig {
  const DotIndicatorThemeConfig._();

  static const DotIndicatorTheme? global = null;
  static const String globalType = 'DotIndicatorTheme';
  static const DotIndicatorThemeDefaults defaults = DotIndicatorThemeDefaults();
  static const DotIndicatorThemeTokens tokens = dotIndicatorThemeTokens;

  static final Map<Type, Object?> _resolveByType = <Type, Object?>{
    DotIndicatorTheme: global,
  };

  static T? resolve<T extends DotIndicatorTheme>() {
    return _resolveByType[T] as T?;
  }
}
