// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

// ═══════════════════════════════════════════════════════════
// COMPONENT THEME CONFIG
// Registration wiring (do not edit manually)
// ═══════════════════════════════════════════════════════════

import '../../../stage_container.dart';
import 'stage_container_theme_defaults.dart';
import 'stage_container_theme_tokens.dart';

class StageContainerThemeConfig {
  const StageContainerThemeConfig._();

  static const StageContainerTheme? global = null;
  static const String globalType = 'StageContainerTheme';
  static const StageContainerThemeDefaults defaults =
      StageContainerThemeDefaults();
  static const StageContainerThemeTokens tokens = stageContainerThemeTokens;

  static final Map<Type, Object?> _resolveByType = <Type, Object?>{
    StageContainerTheme: global,
  };

  static T? resolve<T extends StageContainerTheme>() {
    return _resolveByType[T] as T?;
  }
}
