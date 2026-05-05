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
