// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

// ═══════════════════════════════════════════════════════════
// COMPONENT THEME DEFAULTS
// Built-in defaults (never changes)
// Extracted from hard-coded values in multiple choice widgets
// ═══════════════════════════════════════════════════════════

class MultipleChoiceThemeDefaults {
  const MultipleChoiceThemeDefaults({
    this.allowUnselect = false,
    this.multipleAnswerAllowUnselect = true,
  });

  /// From `_MultipleChoiceState`: `theme?.allowUnselect ?? false`
  final bool allowUnselect;

  /// From `_MultipleAnswerState`: `theme?.allowUnselect ?? true`
  final bool multipleAnswerAllowUnselect;
}
