// ═══════════════════════════════════════════════════════════
// COMPONENT THEME CONFIG
// Registration wiring (do not edit manually)
// ═══════════════════════════════════════════════════════════

import '../../../accordion.dart';
import 'accordion_theme_defaults.dart';
import 'accordion_theme_tokens.dart';

class AccordionThemeConfig {
  const AccordionThemeConfig._();

  static const AccordionTheme? global = null;
  static const String globalType = 'AccordionTheme';
  static const AccordionThemeDefaults defaults = AccordionThemeDefaults();
  static const AccordionThemeTokens tokens = accordionThemeTokens;

  static final Map<Type, Object?> _resolveByType = <Type, Object?>{
    AccordionTheme: global,
  };

  static T? resolve<T extends AccordionTheme>() {
    return _resolveByType[T] as T?;
  }
}
