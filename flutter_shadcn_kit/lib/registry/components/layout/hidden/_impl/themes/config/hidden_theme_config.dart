// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

// ═══════════════════════════════════════════════════════════
// COMPONENT THEME CONFIG
// Registration wiring (do not edit manually)
// ═══════════════════════════════════════════════════════════

import '../../../hidden.dart';
import 'hidden_theme_defaults.dart';
import 'hidden_theme_tokens.dart';

class HiddenThemeConfig {
  const HiddenThemeConfig._();

  static const HiddenTheme? global = null;
  static const String globalType = 'HiddenTheme';
  static const HiddenThemeDefaults defaults = HiddenThemeDefaults();
  static const HiddenThemeTokens tokens = hiddenThemeTokens;

  static final Map<Type, Object?> _resolveByType = <Type, Object?>{
    HiddenTheme: global,
  };

  static T? resolve<T extends HiddenTheme>() {
    return _resolveByType[T] as T?;
  }
}
