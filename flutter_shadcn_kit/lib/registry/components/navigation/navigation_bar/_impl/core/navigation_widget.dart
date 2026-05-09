// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../navigation_bar.dart';

/// NavigationWidget defines a reusable type for this registry module.
class NavigationWidget extends StatelessWidget implements NavigationBarItem {
  /// Optional index for selection tracking.
  final int? index;

  /// Static child widget.
  final Widget? child;

  /// Builder function that receives selection state.
  final NavigationWidgetBuilder? builder;

  /// Creates a navigation widget with a static child.
  ///
  /// Parameters:
  /// - [index] (int?): Selection index
  /// - [child] (Widget, required): Static child widget
  const NavigationWidget({super.key, this.index, required Widget this.child})
    : builder = null;

  /// Creates a navigation widget with a selection-aware builder.
  ///
  /// Parameters:
  /// - [index] (int?): Selection index
  /// - [builder] (NavigationWidgetBuilder, required): Builder receiving selection state
  const NavigationWidget.builder({
    super.key,
    this.index,
    required NavigationWidgetBuilder this.builder,
  }) : child = null;

  @override
  bool get selectable {
    return index == null;
  }

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    var data = Data.maybeOf<NavigationControlData>(context);
    var childData = Data.maybeOf<NavigationChildControlData>(context);

    /// Stores `index` state/configuration for this implementation.
    var index = childData?.index ?? this.index;

    /// Stores `isSelected` state/configuration for this implementation.
    var isSelected = index == data?.selectedIndex;
    return child ?? builder!(context, isSelected);
  }
}
