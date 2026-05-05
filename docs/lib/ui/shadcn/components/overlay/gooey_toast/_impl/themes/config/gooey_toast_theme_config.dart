// ═══════════════════════════════════════════════════════════
// COMPONENT THEME CONFIG
// Registration wiring (do not edit manually)
// ═══════════════════════════════════════════════════════════

import '../../../gooey_toast.dart';
import 'gooey_toast_theme_defaults.dart';
import 'gooey_toast_theme_tokens.dart';

class GooeyToastThemeConfig {
  const GooeyToastThemeConfig._();

  static const GooeyToastTheme? global = null;
  static const String globalType = 'GooeyToastTheme';
  static const GooeyToastThemeDefaults defaults = GooeyToastThemeDefaults();
  static const GooeyToastThemeTokens tokens = gooeyToastThemeTokens;

  static final Map<Type, Object?> _resolveByType = <Type, Object?>{
    GooeyToastTheme: global,
  };

  static T? resolve<T extends GooeyToastTheme>() {
    return _resolveByType[T] as T?;
  }
}
