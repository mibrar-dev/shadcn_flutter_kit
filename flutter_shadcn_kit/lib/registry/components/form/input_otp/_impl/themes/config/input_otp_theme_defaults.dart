// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

// ═══════════════════════════════════════════════════════════
// COMPONENT THEME DEFAULTS
// Built-in defaults (never changes)
// Extracted from hard-coded values in input OTP widgets
// ═══════════════════════════════════════════════════════════

class InputOTPThemeDefaults {
  const InputOTPThemeDefaults({this.spacing = 8.0, this.height = 36.0});

  /// From `_InputOTPSpacing`: `theme.density.baseGap * theme.scaling * gapSm`
  final double spacing;

  /// From `_InputOTPState`: `theme.scaling * 36`
  final double height;
}
