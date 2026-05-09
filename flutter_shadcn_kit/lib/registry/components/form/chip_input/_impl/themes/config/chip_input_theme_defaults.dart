// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

// ═══════════════════════════════════════════════════════════
// COMPONENT THEME DEFAULTS
// Built-in defaults (never changes)
// Extracted from hard-coded values in chip input widgets
// ═══════════════════════════════════════════════════════════

class ChipInputThemeDefaults {
  const ChipInputThemeDefaults({this.useChips = true, this.spacing = 4.0});

  /// From `ChipInputState`: `defaultValue: true`
  final bool useChips;

  /// From `ChipEditingController`: `theme?.spacing ?? 4.0`
  final double spacing;
}
