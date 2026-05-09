// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

// ═══════════════════════════════════════════════════════════
// COMPONENT THEME CONFIG
// Registration wiring (do not edit manually)
// ═══════════════════════════════════════════════════════════

import '../../../formatted_input.dart';
import 'formatted_input_theme_defaults.dart';
import 'formatted_input_theme_tokens.dart';

class FormattedInputThemeConfig {
  const FormattedInputThemeConfig._();

  static const FormattedInputTheme? global = null;
  static const String globalType = 'FormattedInputTheme';
  static const FormattedInputThemeDefaults defaults =
      FormattedInputThemeDefaults();
  static const FormattedInputThemeTokens tokens = formattedInputThemeTokens;

  static final Map<Type, Object?> _resolveByType = <Type, Object?>{
    FormattedInputTheme: global,
  };

  static T? resolve<T extends FormattedInputTheme>() {
    return _resolveByType[T] as T?;
  }
}
