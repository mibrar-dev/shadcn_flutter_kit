import 'package:data_widget/data_widget.dart';
import 'package:flutter/widgets.dart';

import 'button_group_data.dart';
import '../styles/button_overrides.dart';

/// ButtonGroup defines a reusable type for this registry module.
class ButtonGroup extends StatelessWidget {
  /// The layout direction for the button group.
  ///
  /// [Axis.horizontal] arranges buttons in a row, removing vertical borders
  /// between adjacent buttons. [Axis.vertical] arranges buttons in a column,
  /// removing horizontal borders between adjacent buttons.
  final Axis direction;

  /// The list of button widgets to group together.
  ///
  /// Each widget should typically be a [Button] or similar interactive widget.
  /// The group automatically applies border modifications to create the
  /// connected appearance.
  final List<Widget> children;

  /// Whether the button group should be shrink-wrapped or expanded.
  ///
  /// When true, the group will expand to fill available space in the
  /// cross axis. When false, the group will size itself based on its
  /// children's intrinsic size.
  final bool expands;

  /// Creates a [ButtonGroup] that arranges buttons with connected borders.
  ///
  /// Parameters:
  /// - [direction] (Axis, default: Axis.horizontal): Layout direction for the buttons.
  /// - [children] (`List<Widget>`, required): The buttons to group together.
  ///
  /// The group automatically handles:
  /// - Border radius adjustments for first/middle/last buttons
  /// - Proper sizing with [IntrinsicHeight] or [IntrinsicWidth]
  /// - Stretch alignment for consistent button heights/widths
  ///
  /// Example:
  /// ```dart
  /// ButtonGroup(
  ///   direction: Axis.vertical,
  ///   children: [
  ///     Button.outline(child: Text('Option 1')),
  ///     Button.outline(child: Text('Option 2')),
  ///     Button.outline(child: Text('Option 3')),
  ///   ],
  /// );
  /// ```
  const ButtonGroup({
    super.key,
    this.direction = Axis.horizontal,
    this.expands = false,
    required this.children,
  });

  /// Creates a horizontal button group.
  ///
  /// A convenience constructor equivalent to `ButtonGroup(direction: Axis.horizontal)`.
  /// Arranges buttons in a row with connected borders.
  const ButtonGroup.horizontal({
    super.key,
    this.expands = false,
    required this.children,
  }) : direction = Axis.horizontal;

  /// Creates a vertical button group.
  ///
  /// A convenience constructor equivalent to `ButtonGroup(direction: Axis.vertical)`.
  /// Arranges buttons in a column with connected borders.
  const ButtonGroup.vertical({
    super.key,
    this.expands = false,
    required this.children,
  }) : direction = Axis.vertical;

  @override
/// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    final parentGroupData = Data.maybeOf<ButtonGroupData>(context);
    List<Widget> children = List.from(this.children);
    if (children.length > 1) {
      for (int i = 0; i < children.length; i++) {
        var groupData = direction == Axis.horizontal
            ? ButtonGroupData.horizontalIndex(i, children.length)
            : ButtonGroupData.verticalIndex(i, children.length);
        if (parentGroupData != null) {
          groupData = parentGroupData.applyToButtonGroupData(groupData);
        }
        children[i] = Data.inherit(
          data: groupData,
          child: ButtonStyleOverride(
            decoration: (context, states, value) {
              if (value is BoxDecoration) {
                final borderRadius = groupData.applyToBorderRadius(
                  value.borderRadius ?? BorderRadius.zero,
/// Creates a `Directionality.of` instance.
                  Directionality.of(context),
                );
                return value.copyWith(borderRadius: borderRadius);
              }
              return value;
            },
            child: children[i],
          ),
        );
      }
    }
    Widget flex = Flex(
      clipBehavior: Clip.none,
      mainAxisSize: MainAxisSize.min,
      direction: direction,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: children,
    );
    if (!expands) {
      if (direction == Axis.horizontal) {
        flex = IntrinsicHeight(child: flex);
      } else {
        flex = IntrinsicWidth(child: flex);
      }
    }
    return flex;
  }
}
