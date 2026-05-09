// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

// ═══════════════════════════════════════════════════════════
// COMPONENT THEME CONFIG
// Registration wiring (do not edit manually)
// ═══════════════════════════════════════════════════════════

import '../../../empty_state.dart';
import 'empty_state_theme_defaults.dart';
import 'empty_state_theme_tokens.dart';

class EmptyStateThemeConfig {
  const EmptyStateThemeConfig._();

  static const EmptyStateTheme? global = null;
  static const String globalType = 'EmptyStateTheme';
  static const EmptyStateThemeDefaults defaults = EmptyStateThemeDefaults();
  static const EmptyStateThemeTokens tokens = emptyStateThemeTokens;

  static final Map<Type, Object?> _resolveByType = <Type, Object?>{
    EmptyStateTheme: global,
  };

  static T? resolve<T extends EmptyStateTheme>() {
    return _resolveByType[T] as T?;
  }
}
