// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

// ═══════════════════════════════════════════════════════════
// COMPONENT THEME CONFIG
// Registration wiring (do not edit manually)
// ═══════════════════════════════════════════════════════════

import '../../../skeleton.dart';
import 'skeleton_theme_defaults.dart';
import 'skeleton_theme_tokens.dart';

class SkeletonThemeConfig {
  const SkeletonThemeConfig._();

  static const SkeletonTheme? global = null;
  static const String globalType = 'SkeletonTheme';
  static const SkeletonThemeDefaults defaults = SkeletonThemeDefaults();
  static const SkeletonThemeTokens tokens = skeletonThemeTokens;

  static final Map<Type, Object?> _resolveByType = <Type, Object?>{
    SkeletonTheme: global,
  };

  static T? resolve<T extends SkeletonTheme>() {
    return _resolveByType[T] as T?;
  }
}
