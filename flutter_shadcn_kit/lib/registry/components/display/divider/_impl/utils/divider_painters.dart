// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../divider.dart';

/// Immutable divider properties used for lerping transitions.
class DividerProperties {
  /// Color value used by divider painting or state styling.
  final Color color;

  /// Input parameter used by `DividerProperties` during rendering and behavior handling.
  final double thickness;

  /// Input parameter used by `DividerProperties` during rendering and behavior handling.
  final double indent;

  /// Input parameter used by `DividerProperties` during rendering and behavior handling.
  final double endIndent;

  /// Creates `DividerProperties` for configuring or rendering divider.
  const DividerProperties({
    required this.color,
    required this.thickness,
    required this.indent,
    required this.endIndent,
  });

  static DividerProperties lerp(
    DividerProperties? a,
    DividerProperties? b,
    double t,
  ) {
    final start = a ?? b;

    final end = b ?? a;
    assert(start != null && end != null);
    return DividerProperties(
      color: Color.lerp(start!.color, end!.color, t)!,
      thickness: lerpDouble(start.thickness, end.thickness, t)!,
      indent: lerpDouble(start.indent, end.indent, t)!,
      endIndent: lerpDouble(start.endIndent, end.endIndent, t)!,
    );
  }
}
