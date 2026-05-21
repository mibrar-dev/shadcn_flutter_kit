// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/widgets.dart';

// ═══════════════════════════════════════════════════════════
// COMPONENT THEME TOKENS
// User customization layer (replace this file from website output)
// ═══════════════════════════════════════════════════════════

class SelectThemeTokens {
  const SelectThemeTokens({
    this.popupConstraints,
    this.popoverAlignment = Alignment.topCenter,
    this.popoverAnchorAlignment,
    this.borderRadius,
    this.padding,
    this.disableHoverEffect = false,
    this.canUnselect = false,
    this.autoClosePopover = true,
    this.ignoreGlobalScaling = false,
    this.ignoreGlobalRadius = false,
  });

  final BoxConstraints? popupConstraints;
  final AlignmentGeometry popoverAlignment;
  final AlignmentGeometry? popoverAnchorAlignment;
  final BorderRadiusGeometry? borderRadius;
  final EdgeInsetsGeometry? padding;
  final bool disableHoverEffect;
  final bool canUnselect;
  final bool autoClosePopover;
  final bool ignoreGlobalScaling;
  final bool ignoreGlobalRadius;
}

const selectThemeTokens = SelectThemeTokens();
