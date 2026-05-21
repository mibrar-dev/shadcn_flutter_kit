// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/widgets.dart';

import '../../../../../../shared/theme/theme.dart';

/// Theme overrides for the EmptyState widget.
class EmptyStateTheme extends ComponentThemeData {
  /// Creates `EmptyStateTheme` for configuring or rendering empty state.
  const EmptyStateTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.iconColor,
    this.iconSize,
    this.titleStyle,
    this.descriptionStyle,
    this.padding,
    this.maxWidth,
    this.cardBorderRadius,
    this.cardFillColor,
    this.iconContainerColor,
    this.iconContainerBorderColor,
    this.iconContainerBorderRadius,
    this.iconContainerPadding,
  });

  /// Color value used by empty state painting or state styling.
  final Color? iconColor;

  /// Layout/size setting that affects empty state rendering.
  final double? iconSize;

  /// Style/theme override that customizes `EmptyStateTheme` appearance.
  final TextStyle? titleStyle;

  /// Style/theme override that customizes `EmptyStateTheme` appearance.
  final TextStyle? descriptionStyle;

  /// Layout/size setting that affects empty state rendering.
  final EdgeInsetsGeometry? padding;

  /// Layout/size setting that affects empty state rendering.
  final double? maxWidth;

  /// Layout/size setting that affects empty state rendering.
  final BorderRadiusGeometry? cardBorderRadius;

  /// Color value used by empty state painting or state styling.
  final Color? cardFillColor;

  /// Color value used by empty state painting or state styling.
  final Color? iconContainerColor;

  /// Color value used by empty state painting or state styling.
  final Color? iconContainerBorderColor;

  /// Layout/size setting that affects empty state rendering.
  final BorderRadiusGeometry? iconContainerBorderRadius;

  /// Layout/size setting that affects empty state rendering.
  final EdgeInsetsGeometry? iconContainerPadding;
}
