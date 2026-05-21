// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

// ═══════════════════════════════════════════════════════════
// COMPONENT THEME CONFIG
// Registration wiring (do not edit manually)
// ═══════════════════════════════════════════════════════════

import '../../../context_menu.dart';
import 'context_menu_theme_defaults.dart';
import 'context_menu_theme_tokens.dart';

class ContextMenuThemeConfig {
  const ContextMenuThemeConfig._();

  static const ContextMenuTheme? global = null;
  static const String globalType = 'ContextMenuTheme';
  static const ContextMenuThemeDefaults defaults = ContextMenuThemeDefaults();
  static const ContextMenuThemeTokens tokens = contextMenuThemeTokens;

  static final Map<Type, Object?> _resolveByType = <Type, Object?>{
    ContextMenuTheme: global,
  };

  static T? resolve<T extends ContextMenuTheme>() {
    return _resolveByType[T] as T?;
  }
}
