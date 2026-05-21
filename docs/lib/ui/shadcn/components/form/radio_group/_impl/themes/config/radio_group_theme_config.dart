// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

// ═══════════════════════════════════════════════════════════
// COMPONENT THEME CONFIG
// Registration wiring (do not edit manually)
// ═══════════════════════════════════════════════════════════

import '../../../radio_group.dart';
import 'radio_group_theme_defaults.dart';
import 'radio_group_theme_tokens.dart';

class RadioGroupThemeConfig {
  const RadioGroupThemeConfig._();

  static const RadioCardTheme? radioCardTheme = null;
  static const String radioCardThemeType = 'RadioCardTheme';
  static const RadioCardThemeDefaults radioCardThemeDefaults =
      RadioCardThemeDefaults();
  static const RadioCardThemeTokens radioCardThemeTokenConfig =
      radioCardThemeTokens;

  static const RadioTheme? radioTheme = null;
  static const String radioThemeType = 'RadioTheme';
  static const RadioThemeDefaults radioThemeDefaults = RadioThemeDefaults();
  static const RadioThemeTokens radioThemeTokenConfig = radioThemeTokens;

  static final Map<Type, Object?> _resolveByType = <Type, Object?>{
    RadioCardTheme: radioCardTheme,
    RadioTheme: radioTheme,
  };

  static T? resolve<T>() {
    return _resolveByType[T] as T?;
  }
}
