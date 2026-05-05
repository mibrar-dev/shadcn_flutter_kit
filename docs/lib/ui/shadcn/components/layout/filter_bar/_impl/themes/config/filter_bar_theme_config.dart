// ═══════════════════════════════════════════════════════════
// COMPONENT THEME CONFIG
// Registration wiring (do not edit manually)
// ═══════════════════════════════════════════════════════════

import '../../../filter_bar.dart';
import 'filter_bar_theme_defaults.dart';
import 'filter_bar_theme_tokens.dart';

class FilterBarThemeConfig {
  const FilterBarThemeConfig._();

  static const FilterBarStyle? global = null;
  static const String globalType = 'FilterBarTheme';
  static const FilterBarThemeDefaults defaults = FilterBarThemeDefaults();
  static const FilterBarThemeTokens tokens = filterBarThemeTokens;

  static final Map<Type, Object?> _resolveByType = <Type, Object?>{
    FilterBarStyle: global,
  };

  static T? resolve<T extends FilterBarStyle>() {
    return _resolveByType[T] as T?;
  }
}
