// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/widgets.dart';

/// Renders a configurable row or column of dots.
class MoreDots extends StatelessWidget {
  /// Input parameter used by `MoreDots` during rendering and behavior handling.
  final Axis direction;

  /// Positional/count metadata used by `MoreDots` rendering logic.
  final int count;

  /// Layout/size setting that affects triple dots rendering.
  final double? size;

  /// Color value used by triple dots painting or state styling.
  final Color? color;

  /// Layout/size setting that affects triple dots rendering.
  final double spacing;

  /// Layout/size setting that affects triple dots rendering.
  final EdgeInsetsGeometry? padding;

  /// Creates `MoreDots` for configuring or rendering triple dots.
  const MoreDots({
    super.key,
    this.direction = Axis.horizontal,
    this.count = 3,
    this.size,
    this.color,
    this.spacing = 2,
    this.padding,
  });

  /// Builds the widget tree for triple dots.
  @override
  Widget build(BuildContext context) {
    TextStyle style = DefaultTextStyle.of(context).style;

    Color resolvedColor = color ?? style.color!;
    double resolvedSize = size ?? (style.fontSize ?? 12) * 0.2;

    List<Widget> children = [];
    for (int i = 0; i < count; i++) {
      children.add(
        Container(
          width: resolvedSize,
          height: resolvedSize,
          decoration: BoxDecoration(
            color: resolvedColor,
            borderRadius: BorderRadius.circular(resolvedSize / 2),
          ),
        ),
      );
      if (i < count - 1) {
        children.add(
          SizedBox(
            width: direction == Axis.horizontal ? spacing : null,
            height: direction == Axis.vertical ? spacing : null,
          ),
        );
      }
    }
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: direction == Axis.horizontal
          ? Row(mainAxisSize: MainAxisSize.min, children: children)
          : Column(mainAxisSize: MainAxisSize.min, children: children),
    );
  }
}
