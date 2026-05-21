// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../tab_pane.dart';

/// TabPane defines a reusable type for this registry module.
class TabPane<T> extends StatefulWidget {
  /// List of tab data items to display in the tab pane.
  final List<TabPaneData<T>> items;

  /// Builder function to create tab child widgets from data items.
  final TabPaneItemBuilder<T> itemBuilder;

  /// Callback invoked when tabs are reordered through drag-and-drop.
  final ValueChanged<List<TabPaneData<T>>>? onSort;

  /// Index of the currently focused/selected tab.
  final int focused;

  /// Callback invoked when the focused tab changes.
  final ValueChanged<int> onFocused;

  /// Widgets displayed at the leading edge of the tab bar.
  final List<Widget> leading;

  /// Widgets displayed at the trailing edge of the tab bar.
  final List<Widget> trailing;

  /// Border radius for the tab pane container.
  final BorderRadiusGeometry? borderRadius;

  /// Background color for the content area and active tabs.
  final Color? backgroundColor;

  /// Border styling for the tab pane container.
  final BorderSide? border;

  /// The main content widget displayed in the content area.
  final Widget child;

  /// Height of the tab bar area in logical pixels.
  final double? barHeight;

  /// Creates a [TabPane] with sortable tabs and integrated content display.
  const TabPane({
    super.key,
    required this.items,
    required this.itemBuilder,
    this.focused = 0,
    required this.onFocused,
    this.leading = const [],
    this.trailing = const [],
    this.borderRadius,
    this.backgroundColor,
    this.border,
    this.onSort,
    required this.child,
    this.barHeight,
  });

  @override
  /// Executes `createState` behavior for this component/composite.
  State<TabPane<T>> createState() => TabPaneState<T>();
}
