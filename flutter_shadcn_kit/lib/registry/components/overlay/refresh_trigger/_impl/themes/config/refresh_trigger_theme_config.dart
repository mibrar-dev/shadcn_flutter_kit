// ═══════════════════════════════════════════════════════════
// COMPONENT THEME CONFIG
// Registration wiring (do not edit manually)
// ═══════════════════════════════════════════════════════════

import '../../../refresh_trigger.dart';
import 'refresh_trigger_theme_defaults.dart';
import 'refresh_trigger_theme_tokens.dart';

class RefreshTriggerThemeConfig {
  const RefreshTriggerThemeConfig._();

  static const RefreshTriggerTheme? global = null;
  static const String globalType = 'RefreshTriggerTheme';
  static const RefreshTriggerThemeDefaults defaults =
      RefreshTriggerThemeDefaults();
  static const RefreshTriggerThemeTokens tokens = refreshTriggerThemeTokens;

  static final Map<Type, Object?> _resolveByType = <Type, Object?>{
    RefreshTriggerTheme: global,
  };

  static T? resolve<T extends RefreshTriggerTheme>() {
    return _resolveByType[T] as T?;
  }
}
