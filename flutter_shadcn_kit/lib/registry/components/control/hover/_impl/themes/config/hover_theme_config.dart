// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

// ═══════════════════════════════════════════════════════════
// COMPONENT THEME CONFIG
// Registration wiring (do not edit manually)
// ═══════════════════════════════════════════════════════════

import '../../../hover.dart';
import 'hover_theme_defaults.dart';
import 'hover_theme_tokens.dart';

class HoverThemeConfig {
  const HoverThemeConfig._();

  static const HoverTheme? global = null;
  static const String globalType = 'HoverTheme';
  static const HoverThemeDefaults defaults = HoverThemeDefaults();
  static const HoverThemeTokens tokens = hoverThemeTokens;

  static final Map<Type, Object?> _resolveByType = <Type, Object?>{
    HoverTheme: global,
  };

  static T? resolve<T extends HoverTheme>() {
    return _resolveByType[T] as T?;
  }
}
