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
