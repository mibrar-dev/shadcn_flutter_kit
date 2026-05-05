// ═══════════════════════════════════════════════════════════
// COMPONENT THEME CONFIG
// Registration wiring (do not edit manually)
// ═══════════════════════════════════════════════════════════

import '../../../popup.dart';
import 'popup_theme_defaults.dart';
import 'popup_theme_tokens.dart';

class PopupThemeConfig {
  const PopupThemeConfig._();

  static const MenuPopupTheme? menuPopupTheme = null;
  static const String menuPopupThemeType = 'MenuPopupTheme';
  static const MenuPopupThemeDefaults menuPopupThemeDefaults =
      MenuPopupThemeDefaults();
  static const MenuPopupThemeTokens menuPopupThemeTokenConfig =
      menuPopupThemeTokens;

  static final Map<Type, Object?> _resolveByType = <Type, Object?>{
    MenuPopupTheme: menuPopupTheme,
  };

  static T? resolve<T extends MenuPopupTheme>() {
    return _resolveByType[T] as T?;
  }
}
