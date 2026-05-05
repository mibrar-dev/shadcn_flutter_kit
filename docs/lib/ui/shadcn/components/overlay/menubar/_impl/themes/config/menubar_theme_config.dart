// ═══════════════════════════════════════════════════════════
// COMPONENT THEME CONFIG
// Registration wiring (do not edit manually)
// ═══════════════════════════════════════════════════════════

import '../../../menubar.dart';
import 'menubar_theme_defaults.dart';
import 'menubar_theme_tokens.dart';

class MenubarThemeConfig {
  const MenubarThemeConfig._();

  static const MenubarTheme? global = null;
  static const String globalType = 'MenubarTheme';
  static const MenubarThemeDefaults defaults = MenubarThemeDefaults();
  static const MenubarThemeTokens tokens = menubarThemeTokens;

  static final Map<Type, Object?> _resolveByType = <Type, Object?>{
    MenubarTheme: global,
  };

  static T? resolve<T extends MenubarTheme>() {
    return _resolveByType[T] as T?;
  }
}
