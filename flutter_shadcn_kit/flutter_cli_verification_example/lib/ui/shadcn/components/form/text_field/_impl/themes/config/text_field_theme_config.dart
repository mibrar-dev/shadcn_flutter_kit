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

  static T? resolve<T extends TextFieldTheme>() {
    if (T == TextFieldTheme) {
      return global as T?;
    }
    return null;
  }
}
