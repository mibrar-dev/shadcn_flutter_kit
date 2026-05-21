// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

// ═══════════════════════════════════════════════════════════
// COMPONENT THEME CONFIG
// Registration wiring (do not edit manually)
// ═══════════════════════════════════════════════════════════

import '../../../time_picker.dart';
import 'time_picker_theme_defaults.dart';
import 'time_picker_theme_tokens.dart';

class TimePickerThemeConfig {
  const TimePickerThemeConfig._();

  static const TimePickerTheme? global = null;
  static const String globalType = 'TimePickerTheme';
  static const TimePickerThemeDefaults defaults = TimePickerThemeDefaults();
  static const TimePickerThemeTokens tokens = timePickerThemeTokens;

  static final Map<Type, Object?> _resolveByType = <Type, Object?>{
    TimePickerTheme: global,
  };

  static T? resolve<T extends TimePickerTheme>() {
    return _resolveByType[T] as T?;
  }
}
