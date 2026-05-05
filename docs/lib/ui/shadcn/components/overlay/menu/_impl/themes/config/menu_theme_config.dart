// ═══════════════════════════════════════════════════════════
// COMPONENT THEME CONFIG
// Registration wiring (do not edit manually)
// ═══════════════════════════════════════════════════════════

import '../../../menu.dart';
import 'menu_theme_defaults.dart';
import 'menu_theme_tokens.dart';

class MenuThemeConfig {
  const MenuThemeConfig._();

  static const MenuTheme? global = null;
  static const String globalType = 'MenuTheme';
  static const MenuThemeDefaults defaults = MenuThemeDefaults();
  static const MenuThemeTokens tokens = menuThemeTokens;

  static const MenuPopupTheme? menuPopupTheme = null;
  static const String menuPopupThemeType = 'MenuPopupTheme';
  static const MenuPopupThemeDefaults menuPopupThemeDefaults =
      MenuPopupThemeDefaults();
  static const MenuPopupThemeTokens menuPopupThemeTokenConfig =
      menuPopupThemeTokens;

  static const MenubarTheme? menubarTheme = null;
  static const String menubarThemeType = 'MenubarTheme';
  static const MenubarThemeDefaults menubarThemeDefaults =
      MenubarThemeDefaults();
  static const MenubarThemeTokens menubarThemeTokenConfig = menubarThemeTokens;

  static final Map<Type, Object?> _resolveByType = <Type, Object?>{
    MenuTheme: global,
    MenuPopupTheme: menuPopupTheme,
    MenubarTheme: menubarTheme,
  };

  static T? resolve<T>() {
    return _resolveByType[T] as T?;
  }
}
