// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

// ═══════════════════════════════════════════════════════════
// COMPONENT THEME CONFIG
// Registration wiring (do not edit manually)
// ═══════════════════════════════════════════════════════════

import '../../../text_field.dart';
import 'text_field_theme_defaults.dart';
import 'text_field_theme_tokens.dart';

class TextFieldThemeConfig {
  const TextFieldThemeConfig._();

  static const TextFieldTheme? global = null;
  static const String globalType = 'TextFieldTheme';
  static const TextFieldThemeDefaults defaults = TextFieldThemeDefaults();
  static const TextFieldThemeTokens tokens = textFieldThemeTokens;

  static final Map<Type, Object?> _resolveByType = <Type, Object?>{
    TextFieldTheme: global,
  };

  static T? resolve<T extends TextFieldTheme>() {
    return _resolveByType[T] as T?;
  }
}
