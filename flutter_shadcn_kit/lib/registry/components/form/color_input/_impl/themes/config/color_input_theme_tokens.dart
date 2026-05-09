// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/widgets.dart';

import '../../../../color_picker/color_picker.dart';
import '../../../../form_field/form_field.dart';

// ═══════════════════════════════════════════════════════════
// COMPONENT THEME TOKENS
// User customization layer (replace this file from website output)
// ═══════════════════════════════════════════════════════════

class ColorInputThemeTokens {
  const ColorInputThemeTokens({
    this.showAlpha = true,
    this.popoverAlignment = Alignment.topCenter,
    this.popoverAnchorAlignment = Alignment.bottomCenter,
    this.popoverPadding,
    this.mode = PromptMode.popover,
    this.pickerMode = ColorPickerMode.rgb,
    this.enableEyeDropper = true,
    this.showLabel = false,
    this.orientation,
    this.showHistory = true,
    this.ignoreGlobalScaling = false,
    this.ignoreGlobalRadius = false,
  });

  final bool showAlpha;
  final AlignmentGeometry popoverAlignment;
  final AlignmentGeometry popoverAnchorAlignment;
  final EdgeInsetsGeometry? popoverPadding;
  final PromptMode mode;
  final ColorPickerMode pickerMode;
  final bool enableEyeDropper;
  final bool showLabel;
  final Axis? orientation;
  final bool showHistory;
  final bool ignoreGlobalScaling;
  final bool ignoreGlobalRadius;
}

const colorInputThemeTokens = ColorInputThemeTokens();
