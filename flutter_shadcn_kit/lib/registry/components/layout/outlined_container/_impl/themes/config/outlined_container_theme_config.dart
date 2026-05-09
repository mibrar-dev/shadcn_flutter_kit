// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

// ═══════════════════════════════════════════════════════════
// COMPONENT THEME CONFIG
// Registration wiring (do not edit manually)
// ═══════════════════════════════════════════════════════════

import '../../../outlined_container.dart';
import 'outlined_container_theme_defaults.dart';
import 'outlined_container_theme_tokens.dart';

class OutlinedContainerThemeConfig {
  const OutlinedContainerThemeConfig._();

  static const OutlinedContainerTheme? global = null;
  static const String globalType = 'OutlinedContainerTheme';
  static const OutlinedContainerThemeDefaults defaults =
      OutlinedContainerThemeDefaults();
  static const OutlinedContainerThemeTokens tokens =
      outlinedContainerThemeTokens;

  static final Map<Type, Object?> _resolveByType = <Type, Object?>{
    OutlinedContainerTheme: global,
  };

  static T? resolve<T extends OutlinedContainerTheme>() {
    return _resolveByType[T] as T?;
  }
}
