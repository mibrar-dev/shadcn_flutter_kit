// ═══════════════════════════════════════════════════════════
// COMPONENT THEME CONFIG
// Registration wiring (do not edit manually)
// ═══════════════════════════════════════════════════════════

import '../../../dropdown_menu.dart';
import 'dropdown_menu_theme_defaults.dart';
import 'dropdown_menu_theme_tokens.dart';

class DropdownMenuThemeConfig {
  const DropdownMenuThemeConfig._();

  static const DropdownMenuTheme? global = null;
  static const String globalType = 'DropdownMenuTheme';
  static const DropdownMenuThemeDefaults defaults = DropdownMenuThemeDefaults();
  static const DropdownMenuThemeTokens tokens = dropdownMenuThemeTokens;

  static final Map<Type, Object?> _resolveByType = <Type, Object?>{
    DropdownMenuTheme: global,
  };

  static T? resolve<T extends DropdownMenuTheme>() {
    return _resolveByType[T] as T?;
  }
}
