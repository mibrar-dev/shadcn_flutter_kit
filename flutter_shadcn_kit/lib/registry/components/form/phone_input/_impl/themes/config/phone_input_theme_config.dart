// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

// ═══════════════════════════════════════════════════════════
// COMPONENT THEME CONFIG
// Registration wiring (do not edit manually)
// ═══════════════════════════════════════════════════════════

import '../../../phone_input.dart';
import 'phone_input_theme_defaults.dart';
import 'phone_input_theme_tokens.dart';

class PhoneInputThemeConfig {
  const PhoneInputThemeConfig._();

  static const PhoneInputTheme? global = null;
  static const String globalType = 'PhoneInputTheme';
  static const PhoneInputThemeDefaults defaults = PhoneInputThemeDefaults();
  static const PhoneInputThemeTokens tokens = phoneInputThemeTokens;

  static final Map<Type, Object?> _resolveByType = <Type, Object?>{
    PhoneInputTheme: global,
  };

  static T? resolve<T extends PhoneInputTheme>() {
    return _resolveByType[T] as T?;
  }
}
