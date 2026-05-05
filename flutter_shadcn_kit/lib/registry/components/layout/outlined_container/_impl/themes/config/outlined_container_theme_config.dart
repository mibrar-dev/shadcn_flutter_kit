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
