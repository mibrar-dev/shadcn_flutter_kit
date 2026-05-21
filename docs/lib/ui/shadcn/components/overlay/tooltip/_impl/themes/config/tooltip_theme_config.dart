// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

// ═══════════════════════════════════════════════════════════
// COMPONENT THEME CONFIG
// Registration wiring (do not edit manually)
// ═══════════════════════════════════════════════════════════

import '../../../tooltip.dart';
import 'tooltip_theme_defaults.dart';
import 'tooltip_theme_tokens.dart';

class TooltipThemeConfig {
  const TooltipThemeConfig._();

  static const TooltipTheme? global = null;
  static const String globalType = 'TooltipTheme';
  static const TooltipThemeDefaults defaults = TooltipThemeDefaults();
  static const TooltipThemeTokens tokens = tooltipThemeTokens;

  static final Map<Type, Object?> _resolveByType = <Type, Object?>{
    TooltipTheme: global,
  };

  static T? resolve<T extends TooltipTheme>() {
    return _resolveByType[T] as T?;
  }
}
