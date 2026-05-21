// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

// ═══════════════════════════════════════════════════════════
// COMPONENT THEME CONFIG
// Registration wiring (do not edit manually)
// ═══════════════════════════════════════════════════════════

import '../../../drawer.dart';
import 'drawer_theme_defaults.dart';
import 'drawer_theme_tokens.dart';

class DrawerThemeConfig {
  const DrawerThemeConfig._();

  static const DrawerTheme? global = null;
  static const String globalType = 'DrawerTheme';
  static const DrawerThemeDefaults defaults = DrawerThemeDefaults();
  static const DrawerThemeTokens tokens = drawerThemeTokens;

  static final Map<Type, Object?> _resolveByType = <Type, Object?>{
    DrawerTheme: global,
  };

  static T? resolve<T extends DrawerTheme>() {
    return _resolveByType[T] as T?;
  }
}
