// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

// ═══════════════════════════════════════════════════════════
// COMPONENT THEME CONFIG
// Registration wiring (do not edit manually)
// ═══════════════════════════════════════════════════════════

import '../../../collapsible.dart';
import 'collapsible_theme_defaults.dart';
import 'collapsible_theme_tokens.dart';

class CollapsibleThemeConfig {
  const CollapsibleThemeConfig._();

  static const CollapsibleTheme? global = null;
  static const String globalType = 'CollapsibleTheme';
  static const CollapsibleThemeDefaults defaults = CollapsibleThemeDefaults();
  static const CollapsibleThemeTokens tokens = collapsibleThemeTokens;

  static final Map<Type, Object?> _resolveByType = <Type, Object?>{
    CollapsibleTheme: global,
  };

  static T? resolve<T extends CollapsibleTheme>() {
    return _resolveByType[T] as T?;
  }
}
