// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

// ═══════════════════════════════════════════════════════════
// COMPONENT THEME DEFAULTS
// Built-in defaults (never changes)
// Extracted from hard-coded values in tracker widgets
// ═══════════════════════════════════════════════════════════

class TrackerThemeDefaults {
  const TrackerThemeDefaults({
    this.radius = 6.0,
    this.gap = 2.0,
    this.itemHeight = 32.0,
  });

  /// From `Tracker`: `trackerTheme?.radius ?? theme.radiusMd`
  final double radius;

  /// From `Tracker`: `trackerTheme?.gap ?? theme.scaling * 2`
  final double gap;

  /// From `Tracker`: `trackerTheme?.itemHeight ?? 32`
  final double itemHeight;
}
