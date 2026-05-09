// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../navigation_bar.dart';

/// NavigationDivider defines a reusable type for this registry module.
class NavigationDivider extends StatelessWidget implements NavigationBarItem {
  /// Optional thickness of the divider line.
  final double? thickness;

  /// Optional color for the divider.
  final Color? color;

  /// Creates a navigation divider.
  ///
  /// Parameters:
  /// - [thickness] (double?): Line thickness
  /// - [color] (Color?): Divider color
  const NavigationDivider({super.key, this.thickness, this.color});

  @override
  /// Stores `selectable` state/configuration for this implementation.
  bool get selectable => false;

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    /// Stores `scaling` state/configuration for this implementation.
    final scaling = theme.scaling;
    final data = Data.maybeOf<NavigationControlData>(context);

    /// Stores `parentPadding` state/configuration for this implementation.
    final parentPadding = data?.parentPadding ?? EdgeInsets.zero;

    /// Stores `direction` state/configuration for this implementation.
    final direction = data?.direction ?? Axis.vertical;

    /// Stores `child` state/configuration for this implementation.
    Widget child;
    if (direction == Axis.vertical) {
      child = Divider(
        indent: parentPadding.left,
        endIndent: parentPadding.right,
        thickness: thickness ?? (1 * scaling),
        color: color ?? theme.colorScheme.muted,
      );
    } else {
      child = VerticalDivider(
        indent: parentPadding.top,
        endIndent: parentPadding.bottom,
        thickness: thickness ?? (1 * scaling),
        color: color ?? theme.colorScheme.muted,
      );
    }
    child = NavigationPadding(child: child);
    if (data?.containerType == NavigationContainerType.sidebar) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: direction == Axis.vertical
              ? EdgeInsets.symmetric(vertical: theme.density.baseGap * scaling)
              : EdgeInsets.symmetric(
                  horizontal: theme.density.baseGap * scaling,
                ),
          child: child,
        ),
      );
    }
    return Padding(
      padding: direction == Axis.vertical
          ? EdgeInsets.symmetric(
              vertical: theme.density.baseGap * scaling * 0.5,
            )
          : EdgeInsets.symmetric(
              horizontal: theme.density.baseGap * scaling * 0.5,
            ),
      child: child,
    );
  }
}
