// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../../badge.dart';

/// Theme data for customizing badge widget appearance across different styles.
class BadgeTheme extends ComponentThemeData {
  /// Style for [PrimaryBadge].
  final AbstractButtonStyle? primaryStyle;

  /// Style for [SecondaryBadge].
  final AbstractButtonStyle? secondaryStyle;

  /// Style for [OutlineBadge].
  final AbstractButtonStyle? outlineStyle;

  /// Style for [DestructiveBadge].
  final AbstractButtonStyle? destructiveStyle;

  /// Creates a [BadgeTheme].
  const BadgeTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.primaryStyle,
    this.secondaryStyle,
    this.outlineStyle,
    this.destructiveStyle,
  });

  /// Returns a copy of this theme with the given fields replaced.
  BadgeTheme copyWith({
    ValueGetter<AbstractButtonStyle?>? primaryStyle,
    ValueGetter<AbstractButtonStyle?>? secondaryStyle,
    ValueGetter<AbstractButtonStyle?>? outlineStyle,
    ValueGetter<AbstractButtonStyle?>? destructiveStyle,
  }) {
    return BadgeTheme(
      primaryStyle: primaryStyle == null ? this.primaryStyle : primaryStyle(),
      secondaryStyle: secondaryStyle == null
          ? this.secondaryStyle
          : secondaryStyle(),
      outlineStyle: outlineStyle == null ? this.outlineStyle : outlineStyle(),
      destructiveStyle: destructiveStyle == null
          ? this.destructiveStyle
          : destructiveStyle(),
    );
  }

  /// Compares two badge values for structural equality.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BadgeTheme &&
        other.primaryStyle == primaryStyle &&
        other.secondaryStyle == secondaryStyle &&
        other.outlineStyle == outlineStyle &&
        other.destructiveStyle == destructiveStyle;
  }

  @override
  int get hashCode =>
      Object.hash(primaryStyle, secondaryStyle, outlineStyle, destructiveStyle);
}
