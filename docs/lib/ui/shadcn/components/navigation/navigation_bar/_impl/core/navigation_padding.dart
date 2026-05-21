// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../navigation_bar.dart';

/// NavigationPadding defines a reusable type for this registry module.
class NavigationPadding extends StatelessWidget {
  /// Child widget to wrap with padding.
  final Widget child;

  /// Creates a navigation padding wrapper.
  ///
  /// Parameters:
  /// - [child] (Widget, required): Widget to wrap
  const NavigationPadding({super.key, required this.child});

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    final parentData = Data.maybeOf<NavigationControlData>(context);
    final childData = Data.maybeOf<NavigationChildControlData>(context);
    if (parentData != null && childData != null) {
      /// Stores `direction` state/configuration for this implementation.
      final direction = parentData.direction;

      /// Stores `gap` state/configuration for this implementation.
      final gap = parentData.spacing / 2;

      /// Stores `index` state/configuration for this implementation.
      final index = childData.index;

      /// Stores `count` state/configuration for this implementation.
      final count = parentData.childCount;

      /// Stores `isFirst` state/configuration for this implementation.
      final isFirst = index == 0;

      /// Stores `isLast` state/configuration for this implementation.
      final isLast = index == count - 1;
      return Padding(
        padding: direction == Axis.vertical
            ? EdgeInsets.only(top: isFirst ? 0 : gap, bottom: isLast ? 0 : gap)
            : EdgeInsets.only(left: isFirst ? 0 : gap, right: isLast ? 0 : gap),
        child: child,
      );
    }
    return child;
  }
}
