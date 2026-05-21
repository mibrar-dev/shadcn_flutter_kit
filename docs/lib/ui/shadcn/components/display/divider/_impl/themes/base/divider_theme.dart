// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../../divider.dart';

/// Theme data for divider widgets.
class DividerTheme extends ComponentThemeData {
  /// Color value used by divider painting or state styling.
  final Color? color;

  /// Layout/size setting that affects divider rendering.
  final double? height;

  /// Input parameter used by `DividerTheme` during rendering and behavior handling.
  final double? thickness;

  /// Input parameter used by `DividerTheme` during rendering and behavior handling.
  final double? indent;

  /// Input parameter used by `DividerTheme` during rendering and behavior handling.
  final double? endIndent;

  /// Layout/size setting that affects divider rendering.
  final EdgeInsetsGeometry? padding;

  /// Child content displayed inside the divider widget.
  final AxisAlignmentGeometry? childAlignment;

  /// Creates `DividerTheme` for configuring or rendering divider.
  const DividerTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.color,
    this.height,
    this.thickness,
    this.indent,
    this.endIndent,
    this.padding,
    this.childAlignment,
  });

  DividerTheme copyWith({
    ValueGetter<Color?>? color,
    ValueGetter<double?>? height,
    ValueGetter<double?>? thickness,
    ValueGetter<double?>? indent,
    ValueGetter<double?>? endIndent,
    ValueGetter<EdgeInsetsGeometry?>? padding,
    ValueGetter<AxisAlignmentGeometry?>? childAlignment,
  }) {
    return DividerTheme(
      color: color == null ? this.color : color(),
      height: height == null ? this.height : height(),
      thickness: thickness == null ? this.thickness : thickness(),
      indent: indent == null ? this.indent : indent(),
      endIndent: endIndent == null ? this.endIndent : endIndent(),
      padding: padding == null ? this.padding : padding(),
      childAlignment: childAlignment == null
          ? this.childAlignment
          : childAlignment(),
    );
  }

  /// Compares two divider values for structural equality.
  @override
  bool operator ==(Object other) {
    return other is DividerTheme &&
        other.color == color &&
        other.height == height &&
        other.thickness == thickness &&
        other.indent == indent &&
        other.endIndent == endIndent &&
        other.padding == padding &&
        other.childAlignment == childAlignment;
  }

  @override
  int get hashCode => Object.hash(
    color,
    height,
    thickness,
    indent,
    endIndent,
    padding,
    childAlignment,
  );
}
