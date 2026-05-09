// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../../switch.dart';

/// Theme configuration for switch styling.
class SwitchTheme extends ComponentThemeData {
  /// Field storing `activeColor` for this form implementation.
  final Color? activeColor;

  /// Field storing `inactiveColor` for this form implementation.
  final Color? inactiveColor;

  /// Field storing `activeThumbColor` for this form implementation.
  final Color? activeThumbColor;

  /// Field storing `inactiveThumbColor` for this form implementation.
  final Color? inactiveThumbColor;

  /// Field storing `gap` for this form implementation.
  final double? gap;

  /// Field storing `borderRadius` for this form implementation.
  final BorderRadiusGeometry? borderRadius;

  /// Constructs `SwitchTheme` with the provided parameters.
  const SwitchTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.activeColor,
    this.inactiveColor,
    this.activeThumbColor,
    this.inactiveThumbColor,
    this.gap,
    this.borderRadius,
  });

  SwitchTheme copyWith({
    ValueGetter<Color?>? activeColor,
    ValueGetter<Color?>? inactiveColor,
    ValueGetter<Color?>? activeThumbColor,
    ValueGetter<Color?>? inactiveThumbColor,
    ValueGetter<double?>? gap,
    ValueGetter<BorderRadiusGeometry?>? borderRadius,
  }) {
    return SwitchTheme(
      activeColor: activeColor == null ? this.activeColor : activeColor(),
      inactiveColor: inactiveColor == null
          ? this.inactiveColor
          : inactiveColor(),
      activeThumbColor: activeThumbColor == null
          ? this.activeThumbColor
          : activeThumbColor(),
      inactiveThumbColor: inactiveThumbColor == null
          ? this.inactiveThumbColor
          : inactiveThumbColor(),
      gap: gap == null ? this.gap : gap(),
      borderRadius: borderRadius == null ? this.borderRadius : borderRadius(),
    );
  }

  /// Compares this object with another for value equality.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SwitchTheme &&
        other.activeColor == activeColor &&
        other.inactiveColor == inactiveColor &&
        other.activeThumbColor == activeThumbColor &&
        other.inactiveThumbColor == inactiveThumbColor &&
        other.gap == gap &&
        other.borderRadius == borderRadius;
  }

  @override
  int get hashCode => Object.hash(
    activeColor,
    inactiveColor,
    activeThumbColor,
    inactiveThumbColor,
    gap,
    borderRadius,
  );
}
