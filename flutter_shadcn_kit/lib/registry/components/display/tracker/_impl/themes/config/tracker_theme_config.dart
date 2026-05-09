// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

// ═══════════════════════════════════════════════════════════
// COMPONENT THEME CONFIG
// Registration wiring (do not edit manually)
// ═══════════════════════════════════════════════════════════

import '../../../tracker.dart';
import 'tracker_theme_defaults.dart';
import 'tracker_theme_tokens.dart';

class TrackerThemeConfig {
  const TrackerThemeConfig._();

  static const TrackerTheme? global = null;
  static const String globalType = 'TrackerTheme';
  static const TrackerThemeDefaults defaults = TrackerThemeDefaults();
  static const TrackerThemeTokens tokens = trackerThemeTokens;

  static final Map<Type, Object?> _resolveByType = <Type, Object?>{
    TrackerTheme: global,
  };

  static T? resolve<T extends TrackerTheme>() {
    return _resolveByType[T] as T?;
  }
}
