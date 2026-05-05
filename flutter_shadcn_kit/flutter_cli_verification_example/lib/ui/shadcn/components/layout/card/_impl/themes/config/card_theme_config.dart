// ═══════════════════════════════════════════════════════════
// COMPONENT THEME CONFIG
// Registration wiring (do not edit manually)
// ═══════════════════════════════════════════════════════════

import '../../../card.dart';
import 'card_theme_defaults.dart';
import 'card_theme_tokens.dart';

class CardThemeConfig {
  const CardThemeConfig._();

  static const CardTheme? global = null;
  static const String globalType = 'CardTheme';
  static const CardThemeDefaults defaults = CardThemeDefaults();
  static const CardThemeTokens tokens = cardThemeTokens;

  static T? resolve<T extends CardTheme>() {
    if (T == CardTheme) {
      return global as T?;
    }
    return null;
  }
}
