// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

// ═══════════════════════════════════════════════════════════
// COMPONENT THEME CONFIG
// Registration wiring (do not edit manually)
// ═══════════════════════════════════════════════════════════

import '../../../calendar.dart';
import 'calendar_theme_defaults.dart';
import 'calendar_theme_tokens.dart';

class CalendarThemeConfig {
  const CalendarThemeConfig._();

  static const CalendarTheme? global = null;
  static const String globalType = 'CalendarTheme';
  static const CalendarThemeDefaults defaults = CalendarThemeDefaults();
  static const CalendarThemeTokens tokens = calendarThemeTokens;

  static final Map<Type, Object?> _resolveByType = <Type, Object?>{
    CalendarTheme: global,
  };

  static T? resolve<T extends CalendarTheme>() {
    return _resolveByType[T] as T?;
  }
}
