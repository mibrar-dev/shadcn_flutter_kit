// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../tabs.dart';

/// TabContainer defines a reusable type for this registry module.
class TabContainer extends StatelessWidget {
  /// Currently selected tab index.
  final int selected;

  /// Callback when tab selection changes.
  final ValueChanged<int>? onSelect;

  /// List of tab children to display.
  final List<TabChild> children;

  /// Optional custom tab layout builder.
  final TabBuilder? builder;

  /// Optional custom child widget builder.
  final TabChildBuilder? childBuilder;

  /// Creates a [TabContainer].
  ///
  /// Parameters:
  /// - [selected] (`int`, required): index of the selected tab
  /// - [onSelect] (`ValueChanged<int>?`, optional): callback when tab changes
  /// - [children] (`List<TabChild>`, required): list of tab items
  /// - [builder] (`TabBuilder?`, optional): custom tab layout builder
  /// - [childBuilder] (`TabChildBuilder?`, optional): custom child builder
  const TabContainer({
    super.key,
    required this.selected,
    required this.onSelect,
    required this.children,
    this.builder,
    this.childBuilder,
  });

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    final compTheme = ComponentTheme.maybeOf<TabContainerTheme>(context);
    final tabBuilder =
        builder ??
        compTheme?.builder ??
        (context, children) => Column(children: children);
    final tabChildBuilder =
        childBuilder ?? compTheme?.childBuilder ?? ((_, __, child) => child);

    /// Stores `wrappedChildren` state/configuration for this implementation.
    List<Widget> wrappedChildren = [];

    /// Stores `index` state/configuration for this implementation.
    int index = 0;
    for (TabChild child in children) {
      if (child.indexed) {
        /// Creates a `wrappedChildren.add` instance.
        wrappedChildren.add(
          /// Creates a `Data.inherit` instance.
          Data.inherit(
            key: ValueKey(child),
            data: TabContainerData(
              index: index,
              selected: selected,
              onSelect: onSelect,
              childBuilder: tabChildBuilder,
            ),
            child: child,
          ),
        );
        index++;
      } else {
        wrappedChildren.add(child);
      }
    }
    return tabBuilder(context, wrappedChildren);
  }
}
