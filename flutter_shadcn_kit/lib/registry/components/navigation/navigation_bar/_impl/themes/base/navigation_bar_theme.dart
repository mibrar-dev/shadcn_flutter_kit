// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../../navigation_bar.dart';

/// Theme data for customizing [NavigationBar] widget appearance.
class NavigationBarTheme extends ComponentThemeData {
  /// Background color of the navigation bar.
  final Color? backgroundColor;

  /// Alignment of navigation items.
  final NavigationBarAlignment? alignment;

  /// Layout direction (horizontal or vertical).
  final Axis? direction;

  /// Spacing between navigation items.
  final double? spacing;

  /// Type of label display (e.g., always show, hide, etc.).
  final NavigationLabelType? labelType;

  /// Position of labels relative to icons.
  final NavigationLabelPosition? labelPosition;

  /// Size variant for labels.
  final NavigationLabelSize? labelSize;

  /// Internal padding of the navigation bar.
  final EdgeInsetsGeometry? padding;

  /// Creates a [NavigationBarTheme].
  const NavigationBarTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.backgroundColor,
    this.alignment,
    this.direction,
    this.spacing,
    this.labelType,
    this.labelPosition,
    this.labelSize,
    this.padding,
  });

  /// Creates a copy of this theme with the given fields replaced.
  NavigationBarTheme copyWith({
    ValueGetter<Color?>? backgroundColor,
    ValueGetter<NavigationBarAlignment?>? alignment,
    ValueGetter<Axis?>? direction,
    ValueGetter<double?>? spacing,
    ValueGetter<NavigationLabelType?>? labelType,
    ValueGetter<NavigationLabelPosition?>? labelPosition,
    ValueGetter<NavigationLabelSize?>? labelSize,
    ValueGetter<EdgeInsetsGeometry?>? padding,
  }) {
    return NavigationBarTheme(
      backgroundColor: backgroundColor == null
          ? this.backgroundColor
          : backgroundColor(),
      alignment: alignment == null ? this.alignment : alignment(),
      direction: direction == null ? this.direction : direction(),
      spacing: spacing == null ? this.spacing : spacing(),
      labelType: labelType == null ? this.labelType : labelType(),
      labelPosition: labelPosition == null
          ? this.labelPosition
          : labelPosition(),
      labelSize: labelSize == null ? this.labelSize : labelSize(),
      padding: padding == null ? this.padding : padding(),
    );
  }

  @override
  /// Executes `operator ==` behavior for this component/composite.
  bool operator ==(Object other) {
    return other is NavigationBarTheme &&
        other.backgroundColor == backgroundColor &&
        other.alignment == alignment &&
        other.direction == direction &&
        other.spacing == spacing &&
        other.labelType == labelType &&
        other.labelPosition == labelPosition &&
        other.labelSize == labelSize &&
        other.padding == padding;
  }

  @override
  int get hashCode => Object.hash(
    backgroundColor,
    alignment,
    direction,
    spacing,
    labelType,
    labelPosition,
    labelSize,
    padding,
  );
}
