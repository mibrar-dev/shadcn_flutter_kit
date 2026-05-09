// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

// ═══════════════════════════════════════════════════════════
// COMPONENT THEME CONFIG
// Registration wiring (do not edit manually)
// ═══════════════════════════════════════════════════════════

import '../../../select.dart';
import 'select_theme_defaults.dart';
import 'select_theme_tokens.dart';

class SelectThemeConfig {
  const SelectThemeConfig._();

  static const SelectTheme? global = null;
  static const String globalType = 'SelectTheme';
  static const SelectThemeDefaults defaults = SelectThemeDefaults();
  static const SelectThemeTokens tokens = selectThemeTokens;

  static final Map<Type, Object?> _resolveByType = <Type, Object?>{
    SelectTheme: global,
  };

  static T? resolve<T extends SelectTheme>() {
    return _resolveByType[T] as T?;
  }
}
