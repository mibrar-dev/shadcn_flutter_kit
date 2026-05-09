// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/widgets.dart';

import '../../../../../control/button/button.dart';

// ═══════════════════════════════════════════════════════════
// COMPONENT THEME TOKENS
// User customization layer (replace this file from website output)
// ═══════════════════════════════════════════════════════════

class BadgeThemeTokens {
  const BadgeThemeTokens({
    this.primaryStyle = const ButtonStyle.primary(
      size: ButtonSize.small,
      density: ButtonDensity.dense,
      shape: ButtonShape.rectangle,
    ),
    this.secondaryStyle = const ButtonStyle.secondary(
      size: ButtonSize.small,
      density: ButtonDensity.dense,
      shape: ButtonShape.rectangle,
    ),
    this.outlineStyle = const ButtonStyle.outline(
      size: ButtonSize.small,
      density: ButtonDensity.dense,
      shape: ButtonShape.rectangle,
    ),
    this.destructiveStyle = const ButtonStyle.destructive(
      size: ButtonSize.small,
      density: ButtonDensity.dense,
      shape: ButtonShape.rectangle,
    ),
    this.textFontWeight = FontWeight.w500,
    this.enabled = true,
    this.ignoreGlobalScaling = false,
    this.ignoreGlobalRadius = false,
  });

  final AbstractButtonStyle primaryStyle;
  final AbstractButtonStyle secondaryStyle;
  final AbstractButtonStyle outlineStyle;
  final AbstractButtonStyle destructiveStyle;
  final FontWeight textFontWeight;
  final bool enabled;
  final bool ignoreGlobalScaling;
  final bool ignoreGlobalRadius;
}

const badgeThemeTokens = BadgeThemeTokens();
