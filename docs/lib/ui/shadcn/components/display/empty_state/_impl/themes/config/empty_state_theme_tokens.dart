// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/widgets.dart';

// ═══════════════════════════════════════════════════════════
// COMPONENT THEME TOKENS
// User customization layer (replace this file from website output)
// ═══════════════════════════════════════════════════════════

class EmptyStateThemeTokens {
  final Color iconColor;
  final double iconSize;
  final TextStyle? titleStyle;
  final TextStyle? descriptionStyle;
  final EdgeInsetsGeometry padding;
  final double maxWidth;
  final BorderRadiusGeometry? cardBorderRadius;
  final Color? cardFillColor;
  final Color iconContainerColor;
  final Color iconContainerBorderColor;
  final BorderRadiusGeometry iconContainerBorderRadius;
  final EdgeInsetsGeometry iconContainerPadding;
  final bool ignoreGlobalScaling;
  final bool ignoreGlobalRadius;

  const EmptyStateThemeTokens({
    this.iconColor = const Color(0xFF737373),
    this.iconSize = 36.0,
    this.titleStyle,
    this.descriptionStyle,
    this.padding = const EdgeInsets.all(32.0),
    this.maxWidth = 520.0,
    this.cardBorderRadius,
    this.cardFillColor,
    this.iconContainerColor = const Color(0xFFF5F5F5),
    this.iconContainerBorderColor = const Color(0xFFE5E5E5),
    this.iconContainerBorderRadius = const BorderRadius.all(
      Radius.circular(14.0),
    ),
    this.iconContainerPadding = const EdgeInsets.all(12.0),
    this.ignoreGlobalScaling = false,
    this.ignoreGlobalRadius = false,
  });
}

const emptyStateThemeTokens = EmptyStateThemeTokens();
