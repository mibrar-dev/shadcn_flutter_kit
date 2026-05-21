// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../tab_container.dart';

/// TabContainerData defines a reusable type for this registry module.
class TabContainerData {
  /// Retrieves the nearest [TabContainerData] from the widget tree.
  ///
  /// Throws an assertion error if no [TabContainer] is found in the
  /// ancestor chain, as tab children must be descendants of a tab container.
  ///
  /// Parameters:
  /// - [context]: Build context to search from
  ///
  /// Returns the container data.
  static TabContainerData of(BuildContext context) {
    var data = Data.maybeOf<TabContainerData>(context);
    assert(data != null, 'TabChild must be a descendant of TabContainer');
    return data!;
  }

  /// The index of this tab within the container (0-indexed).
  final int index;

  /// The index of the currently selected tab.
  final int selected;

  /// Callback to invoke when this tab should be selected.
  ///
  /// Called with the tab's index when the user interacts with the tab.
  final ValueChanged<int>? onSelect;

  /// Builder function for wrapping tab child content.
  ///
  /// Applies consistent styling or layout to tab children.
  final TabChildBuilder childBuilder;

  /// Creates tab container data.
  ///
  /// Parameters:
  /// - [index]: This tab's index (required)
  /// - [selected]: Currently selected tab index (required)
  /// - [onSelect]: Selection callback (required)
  /// - [childBuilder]: Child wrapping builder (required)
  TabContainerData({
    required this.index,
    required this.selected,
    required this.onSelect,
    required this.childBuilder,
  });

  @override
  /// Executes `operator ==` behavior for this component/composite.
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TabContainerData &&
        other.selected == selected &&
        other.onSelect == onSelect &&
        other.index == index &&
        other.childBuilder == childBuilder;
  }

  @override
  int get hashCode => Object.hash(index, selected, onSelect, childBuilder);
}
