// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

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
