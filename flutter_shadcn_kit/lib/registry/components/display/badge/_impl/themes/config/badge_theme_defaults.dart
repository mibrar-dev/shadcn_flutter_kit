// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/widgets.dart';

import '../../../../../control/button/button.dart';

// ═══════════════════════════════════════════════════════════
// COMPONENT THEME DEFAULTS
// Built-in defaults (never changes)
// Extracted from hard-coded values in badge widgets
// ═══════════════════════════════════════════════════════════

class BadgeThemeDefaults {
  const BadgeThemeDefaults({
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
  });

  /// From `PrimaryBadge`: `const ButtonStyle.primary(...small, dense, rectangle)`
  final AbstractButtonStyle primaryStyle;

  /// From `SecondaryBadge`: `const ButtonStyle.secondary(...small, dense, rectangle)`
  final AbstractButtonStyle secondaryStyle;

  /// From `OutlineBadge`: `const ButtonStyle.outline(...small, dense, rectangle)`
  final AbstractButtonStyle outlineStyle;

  /// From `DestructiveBadge`: `const ButtonStyle.destructive(...small, dense, rectangle)`
  final AbstractButtonStyle destructiveStyle;

  /// From all badge variants: `.copyWith(textStyle: ... fontWeight: FontWeight.w500)`
  final FontWeight textFontWeight;

  /// From all badge variants: `enabled: true`
  final bool enabled;
}
