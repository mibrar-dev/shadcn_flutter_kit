// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/widgets.dart';

// ═══════════════════════════════════════════════════════════
// COMPONENT THEME DEFAULTS
// Built-in defaults (never changes)
// Hard-coded widget/variant fallbacks are documented per field
// ═══════════════════════════════════════════════════════════

class EmptyStateThemeDefaults {
  /// Widget fallback: theme.colorScheme.mutedForeground
  final Color iconColor;
  final double iconSize;
  final TextStyle? titleStyle;
  final TextStyle? descriptionStyle;
  final EdgeInsetsGeometry padding;

  /// Widget fallback: maxWidth ?? 520 * scaling
  final double maxWidth;
  final BorderRadiusGeometry? cardBorderRadius;
  final Color? cardFillColor;

  /// Widget fallback: theme.colorScheme.muted
  final Color iconContainerColor;
  final Color iconContainerBorderColor;
  final BorderRadiusGeometry iconContainerBorderRadius;
  final EdgeInsetsGeometry iconContainerPadding;

  const EmptyStateThemeDefaults({
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
  });
}
