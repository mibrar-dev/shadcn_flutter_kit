// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../navigation_bar.dart';

/// _NavigationLabelDelegate defines a reusable type for this registry module.
class _NavigationLabelDelegate extends SliverPersistentHeaderDelegate {
  /// Stores `child` state/configuration for this implementation.
  final Widget child;
  @override
  /// Stores `maxExtent` state/configuration for this implementation.
  final double maxExtent;
  @override
  /// Stores `minExtent` state/configuration for this implementation.
  final double minExtent;

  /// Creates a `_NavigationLabelDelegate` instance.
  _NavigationLabelDelegate({
    required this.maxExtent,
    required this.minExtent,
    required this.child,
  });

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final theme = Theme.of(context);
    final data = Data.maybeOf<NavigationControlData>(context);

    /// Stores `parentPadding` state/configuration for this implementation.
    final parentPadding = data?.parentPadding ?? EdgeInsets.zero;

    /// Stores `direction` state/configuration for this implementation.
    final direction = data?.direction ?? Axis.vertical;

    /// Stores `color` state/configuration for this implementation.
    final color = theme.colorScheme.background;
    return CustomPaint(
      painter: _NavigationLabelBackgroundPainter(
        color: color,
        indent: -_startPadding(parentPadding, direction),
        endIndent: -_endPadding(parentPadding, direction),
        direction: direction,
      ),
      child: child,
    );
  }

  @override
  /// Executes `shouldRebuild` behavior for this component/composite.
  bool shouldRebuild(covariant _NavigationLabelDelegate oldDelegate) {
    return oldDelegate.child != child ||
        oldDelegate.maxExtent != maxExtent ||
        oldDelegate.minExtent != minExtent;
  }
}
