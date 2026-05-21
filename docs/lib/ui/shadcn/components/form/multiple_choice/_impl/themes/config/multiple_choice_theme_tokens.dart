// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

// ═══════════════════════════════════════════════════════════
// COMPONENT THEME TOKENS
// User customization layer (replace this file from website output)
// Defaults intentionally mirror MultipleChoiceThemeDefaults
// ═══════════════════════════════════════════════════════════

class MultipleChoiceThemeTokens {
  const MultipleChoiceThemeTokens({
    this.allowUnselect = false,
    this.multipleAnswerAllowUnselect = true,
    this.ignoreGlobalScaling = false,
    this.ignoreGlobalRadius = false,
  });

  final bool allowUnselect;
  final bool multipleAnswerAllowUnselect;
  final bool ignoreGlobalScaling;
  final bool ignoreGlobalRadius;
}

const multipleChoiceThemeTokens = MultipleChoiceThemeTokens();
