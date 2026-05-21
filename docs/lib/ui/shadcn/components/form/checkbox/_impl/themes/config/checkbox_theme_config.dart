// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

// ═══════════════════════════════════════════════════════════
// COMPONENT THEME CONFIG
// Registration wiring (do not edit manually)
// ═══════════════════════════════════════════════════════════

import '../../../checkbox.dart';
import 'checkbox_theme_defaults.dart';
import 'checkbox_theme_tokens.dart';

class CheckboxThemeConfig {
  const CheckboxThemeConfig._();

  static const CheckboxTheme? global = null;
  static const String globalType = 'CheckboxTheme';
  static const CheckboxThemeDefaults defaults = CheckboxThemeDefaults();
  static const CheckboxThemeTokens tokens = checkboxThemeTokens;

  static final Map<Type, Object?> _resolveByType = <Type, Object?>{
    CheckboxTheme: global,
  };

  static T? resolve<T extends CheckboxTheme>() {
    return _resolveByType[T] as T?;
  }
}
