// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

// ═══════════════════════════════════════════════════════════
// COMPONENT THEME TOKENS
// User customization layer (replace this file from website output)
// Defaults intentionally mirror InputOTPThemeDefaults
// ═══════════════════════════════════════════════════════════

class InputOTPThemeTokens {
  const InputOTPThemeTokens({
    this.spacing = 8.0,
    this.height = 36.0,
    this.ignoreGlobalScaling = false,
    this.ignoreGlobalRadius = false,
  });

  final double spacing;
  final double height;
  final bool ignoreGlobalScaling;
  final bool ignoreGlobalRadius;
}

const inputOTPThemeTokens = InputOTPThemeTokens();
