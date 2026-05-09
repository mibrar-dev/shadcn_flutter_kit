// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

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
