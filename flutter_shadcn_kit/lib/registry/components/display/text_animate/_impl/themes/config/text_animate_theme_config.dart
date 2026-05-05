// ═══════════════════════════════════════════════════════════
// COMPONENT THEME CONFIG
// Registration wiring (do not edit manually)
// ═══════════════════════════════════════════════════════════

import '../../../text_animate.dart';
import 'text_animate_theme_defaults.dart';
import 'text_animate_theme_tokens.dart';

class TextAnimateThemeConfig {
  const TextAnimateThemeConfig._();

  static const TextAnimateTheme? global = null;
  static const String globalType = 'TextAnimateTheme';
  static const TextAnimateThemeDefaults defaults = TextAnimateThemeDefaults();
  static const TextAnimateThemeTokens tokens = textAnimateThemeTokens;

  static final Map<Type, Object?> _resolveByType = <Type, Object?>{
    TextAnimateTheme: global,
  };

  static T? resolve<T extends TextAnimateTheme>() {
    return _resolveByType[T] as T?;
  }
}
