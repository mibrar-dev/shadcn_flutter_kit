// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../dot_indicator.dart';

/// Common base for dots.
class DotItem extends StatelessWidget {
  /// Creates `DotItem` for configuring or rendering dot indicator.
  const DotItem({
    super.key,
    this.size,
    this.color,
    this.borderRadius,
    this.borderColor,
    this.borderWidth,
  });

  /// Layout/size setting that affects dot indicator rendering.
  final double? size;

  /// Color value used by dot indicator painting or state styling.
  final Color? color;

  /// Layout/size setting that affects dot indicator rendering.
  final double? borderRadius;

  /// Color value used by dot indicator painting or state styling.
  final Color? borderColor;

  /// Layout/size setting that affects dot indicator rendering.
  final double? borderWidth;

  /// Builds the widget tree for dot indicator.
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: kDefaultDuration,
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        borderRadius: borderRadius != null
            ? BorderRadius.circular(borderRadius!)
            : null,
        border: borderColor != null && borderWidth != null
            ? Border.all(color: borderColor!, width: borderWidth!)
            : null,
      ),
    );
  }
}
