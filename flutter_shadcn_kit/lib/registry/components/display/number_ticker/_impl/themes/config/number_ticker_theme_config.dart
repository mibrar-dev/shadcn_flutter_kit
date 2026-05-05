// ═══════════════════════════════════════════════════════════
// COMPONENT THEME CONFIG
// Registration wiring (do not edit manually)
// ═══════════════════════════════════════════════════════════

import '../../../number_ticker.dart';
import 'number_ticker_theme_defaults.dart';
import 'number_ticker_theme_tokens.dart';

class NumberTickerThemeConfig {
  const NumberTickerThemeConfig._();

  static const NumberTickerTheme? global = null;
  static const String globalType = 'NumberTickerTheme';
  static const NumberTickerThemeDefaults defaults = NumberTickerThemeDefaults();
  static const NumberTickerThemeTokens tokens = numberTickerThemeTokens;

  static final Map<Type, Object?> _resolveByType = <Type, Object?>{
    NumberTickerTheme: global,
  };

  static T? resolve<T extends NumberTickerTheme>() {
    return _resolveByType[T] as T?;
  }
}
