// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

// ═══════════════════════════════════════════════════════════
// COMPONENT THEME CONFIG
// Registration wiring (do not edit manually)
// ═══════════════════════════════════════════════════════════

import '../../../date_picker.dart';
import 'date_picker_theme_defaults.dart';
import 'date_picker_theme_tokens.dart';

class DatePickerThemeConfig {
  const DatePickerThemeConfig._();

  static const DatePickerTheme? global = null;
  static const String globalType = 'DatePickerTheme';
  static const DatePickerThemeDefaults defaults = DatePickerThemeDefaults();
  static const DatePickerThemeTokens tokens = datePickerThemeTokens;

  static final Map<Type, Object?> _resolveByType = <Type, Object?>{
    DatePickerTheme: global,
  };

  static T? resolve<T extends DatePickerTheme>() {
    return _resolveByType[T] as T?;
  }
}
