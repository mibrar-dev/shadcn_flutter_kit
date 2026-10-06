// Layout helper for connected buttons: [ButtonGroup] hands each child a
// [ButtonGroupData] whose corner multipliers flatten the inner edges, and the
// `Button` widget applies them to its resolved border radius.
//
// Not independently installable; ships inside the `button` component.

import 'package:flutter/widgets.dart';

import '../../foundation/data.dart';

/// Corner-radius multipliers for one button inside a [ButtonGroup].
///
/// Start/end values are mapped to left/right by the ambient text direction in
/// [apply], so groups flip correctly under RTL.
class ButtonGroupData {
  /// Creates data with per-corner multipliers.
  const ButtonGroupData({
    required this.topStart,
    required this.topEnd,
    required this.bottomStart,
    required this.bottomEnd,
  });

  /// Multiplies every corner by [value].
  const ButtonGroupData.all(double value)
    : topStart = value,
      topEnd = value,
      bottomStart = value,
      bottomEnd = value;

  /// Multiplies the horizontal edges (start/end).
  const ButtonGroupData.horizontal({double start = 1, double end = 1})
    : topStart = start,
      topEnd = end,
      bottomStart = start,
      bottomEnd = end;

  /// Multiplies the vertical edges (top/bottom).
  const ButtonGroupData.vertical({double top = 1, double bottom = 1})
    : topStart = top,
      topEnd = top,
      bottomStart = bottom,
      bottomEnd = bottom;

  /// No modification: full radius on every corner.
  static const ButtonGroupData none = ButtonGroupData.all(1);

  /// Removes every corner: an inner button of a group.
  static const ButtonGroupData zero = ButtonGroupData.all(0);

  /// First button of a horizontal group: start radius kept, end flattened.
  static const ButtonGroupData horizontalStart = ButtonGroupData.horizontal(
    end: 0,
  );

  /// Last button of a horizontal group: start flattened, end radius kept.
  static const ButtonGroupData horizontalEnd = ButtonGroupData.horizontal(
    start: 0,
  );

  /// First button of a vertical group: top radius kept, bottom flattened.
  static const ButtonGroupData verticalTop = ButtonGroupData.vertical(
    bottom: 0,
  );

  /// Last button of a vertical group: top flattened, bottom radius kept.
  static const ButtonGroupData verticalBottom = ButtonGroupData.vertical(
    top: 0,
  );

  /// Outer top-start corner multiplier.
  final double topStart;

  /// Outer top-end corner multiplier.
  final double topEnd;

  /// Outer bottom-start corner multiplier.
  final double bottomStart;

  /// Outer bottom-end corner multiplier.
  final double bottomEnd;

  /// Data for the button at [index] of a horizontal group of [length].
  factory ButtonGroupData.horizontalIndex(int index, int length) {
    if (length <= 1) {
      return none;
    }
    if (index == 0) {
      return horizontalStart;
    }
    if (index == length - 1) {
      return horizontalEnd;
    }
    return zero;
  }

  /// Data for the button at [index] of a vertical group of [length].
  factory ButtonGroupData.verticalIndex(int index, int length) {
    if (length <= 1) {
      return none;
    }
    if (index == 0) {
      return verticalTop;
    }
    if (index == length - 1) {
      return verticalBottom;
    }
    return zero;
  }

  /// Scales [radius] by the corner multipliers for [direction].
  BorderRadius apply(BorderRadius radius, TextDirection direction) {
    final bool ltr = direction == TextDirection.ltr;
    return BorderRadius.only(
      topLeft: _scale(radius.topLeft, ltr ? topStart : topEnd),
      topRight: _scale(radius.topRight, ltr ? topEnd : topStart),
      bottomLeft: _scale(radius.bottomLeft, ltr ? bottomStart : bottomEnd),
      bottomRight: _scale(radius.bottomRight, ltr ? bottomEnd : bottomStart),
    );
  }

  /// Multiplies this data with an enclosing group's data (nested groups).
  ButtonGroupData combine(ButtonGroupData other) {
    return ButtonGroupData(
      topStart: topStart * other.topStart,
      topEnd: topEnd * other.topEnd,
      bottomStart: bottomStart * other.bottomStart,
      bottomEnd: bottomEnd * other.bottomEnd,
    );
  }

  static Radius _scale(Radius radius, double value) {
    return Radius.elliptical(radius.x * value, radius.y * value);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is ButtonGroupData &&
        other.topStart == topStart &&
        other.topEnd == topEnd &&
        other.bottomStart == bottomStart &&
        other.bottomEnd == bottomEnd;
  }

  @override
  int get hashCode => Object.hash(topStart, topEnd, bottomStart, bottomEnd);

  @override
  String toString() =>
      'ButtonGroupData(topStart: $topStart, topEnd: $topEnd, '
      'bottomStart: $bottomStart, bottomEnd: $bottomEnd)';
}

/// Arranges [children] as one connected control.
///
/// Wraps every child in a [ButtonGroupData] that flattens the shared inner
/// edges; children keep their own variants, sizes and states.
class ButtonGroup extends StatelessWidget {
  /// Creates a button group.
  const ButtonGroup({
    super.key,
    this.direction = Axis.horizontal,
    this.expands = false,
    required this.children,
  });

  /// Creates a horizontal (row) button group.
  const ButtonGroup.horizontal({
    super.key,
    this.expands = false,
    required this.children,
  }) : direction = Axis.horizontal;

  /// Creates a vertical (column) button group.
  const ButtonGroup.vertical({
    super.key,
    this.expands = false,
    required this.children,
  }) : direction = Axis.vertical;

  /// Layout direction of the group.
  final Axis direction;

  /// Whether the group takes the full main-axis extent of its parent.
  final bool expands;

  /// Buttons in visual order. First and last are rounded; the rest are not.
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final ButtonGroupData? parent = Data.maybeOf<ButtonGroupData>(context);
    final List<Widget> wrapped = <Widget>[];
    for (var i = 0; i < children.length; i++) {
      var data = direction == Axis.horizontal
          ? ButtonGroupData.horizontalIndex(i, children.length)
          : ButtonGroupData.verticalIndex(i, children.length);
      if (parent != null) {
        data = parent.combine(data);
      }
      wrapped.add(
        Data<ButtonGroupData>.inherit(data: data, child: children[i]),
      );
    }
    Widget flex = Flex(
      direction: direction,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      clipBehavior: Clip.none,
      children: wrapped,
    );
    if (!expands) {
      flex = direction == Axis.horizontal
          ? IntrinsicHeight(child: flex)
          : IntrinsicWidth(child: flex);
    }
    return flex;
  }
}
