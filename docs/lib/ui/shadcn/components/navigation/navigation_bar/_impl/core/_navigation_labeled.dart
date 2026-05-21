// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../navigation_bar.dart';

/// _NavigationLabeled defines a reusable type for this registry module.
class _NavigationLabeled extends StatelessWidget {
  /// Stores `child` state/configuration for this implementation.
  final Widget child;

  /// Stores `label` state/configuration for this implementation.
  final Widget label;

  /// Stores `position` state/configuration for this implementation.
  final NavigationLabelPosition position;

  /// Stores `spacing` state/configuration for this implementation.
  final double spacing;

  /// Stores `showLabel` state/configuration for this implementation.
  final bool showLabel;

  /// Stores `labelType` state/configuration for this implementation.
  final NavigationLabelType labelType;

  /// Stores `direction` state/configuration for this implementation.
  final Axis direction;

  /// Stores `keepCrossAxisSize` state/configuration for this implementation.
  final bool keepCrossAxisSize;

  /// Stores `keepMainAxisSize` state/configuration for this implementation.
  final bool keepMainAxisSize;

  /// Creates a `_NavigationLabeled` instance.
  const _NavigationLabeled({
    required this.child,
    required this.label,
    required this.spacing,
    required this.position,
    required this.showLabel,
    required this.labelType,
    required this.direction,
    required this.keepCrossAxisSize,
    required this.keepMainAxisSize,
  });

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    var direction =
        position == NavigationLabelPosition.top ||
            position == NavigationLabelPosition.bottom
        ? Axis.vertical
        : Axis.horizontal;
    var animatedSize = Hidden(
      hidden: !showLabel,
      direction: direction,
      reverse:
          position == NavigationLabelPosition.start ||
          position == NavigationLabelPosition.top,
      keepCrossAxisSize: (this.direction != direction
          ? keepCrossAxisSize
          : keepMainAxisSize),
      keepMainAxisSize: (this.direction != direction
          ? keepMainAxisSize
          : keepCrossAxisSize),
      child: Padding(
        padding: EdgeInsetsDirectional.only(
          top: position == NavigationLabelPosition.bottom ? spacing : 0,
          bottom: position == NavigationLabelPosition.top ? spacing : 0,
          start: position == NavigationLabelPosition.end ? spacing : 0,
          end: position == NavigationLabelPosition.start ? spacing : 0,
        ),
        child: label,
      ),
    );
    return IntrinsicHeight(
      child: IntrinsicWidth(
        child: Flex(
          direction: direction,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (position == NavigationLabelPosition.start ||
                position == NavigationLabelPosition.top)
              /// Creates a `Flexible` instance.
              Flexible(child: animatedSize),
            child,
            if (position == NavigationLabelPosition.end ||
                position == NavigationLabelPosition.bottom)
              /// Creates a `Flexible` instance.
              Flexible(child: animatedSize),
          ],
        ),
      ),
    );
  }
}
