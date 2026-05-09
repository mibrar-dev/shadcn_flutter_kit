// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

// ═══════════════════════════════════════════════════════════
// COMPONENT THEME CONFIG
// Registration wiring (do not edit manually)
// ═══════════════════════════════════════════════════════════

import '../../../switch.dart';
import 'switch_theme_defaults.dart';
import 'switch_theme_tokens.dart';

class SwitchThemeConfig {
  const SwitchThemeConfig._();

  static const SwitchTheme? global = null;
  static const String globalType = 'SwitchTheme';
  static const SwitchThemeDefaults defaults = SwitchThemeDefaults();
  static const SwitchThemeTokens tokens = switchThemeTokens;

  static final Map<Type, Object?> _resolveByType = <Type, Object?>{
    SwitchTheme: global,
  };

  static T? resolve<T extends SwitchTheme>() {
    return _resolveByType[T] as T?;
  }
}
