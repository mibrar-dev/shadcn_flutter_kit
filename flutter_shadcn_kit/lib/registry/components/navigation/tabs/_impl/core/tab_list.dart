// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../tabs.dart';

/// TabList defines a reusable type for this registry module.
class TabList extends StatelessWidget {
  /// List of tab child widgets to display in the tab list.
  ///
  /// Type: `List<TabChild>`. Each TabChild represents one selectable tab
  /// with its own label and optional content. The tabs are displayed in
  /// the order provided in the list.
  final List<TabChild> children;

  /// Index of the currently active/selected tab.
  ///
  /// Type: `int`. Zero-based index indicating which tab is currently active.
  /// Must be within the bounds of the [children] list. The active tab
  /// receives special styling and the indicator line.
  final int index;

  /// Callback invoked when a tab is selected.
  ///
  /// Type: `ValueChanged<int>?`. Called with the index of the newly selected
  /// tab when the user taps on a tab button. If null, tabs are not interactive.
  final ValueChanged<int>? onChanged;

  /// Creates a [TabList] with horizontal tab selection.
  ///
  /// Configures a tab list widget that displays a horizontal row of selectable
  /// tab buttons with visual feedback for the active tab.
  ///
  /// Parameters:
  /// - [key] (Key?): Widget identifier for the widget tree
  /// - [children] (`List<TabChild>`, required): List of tab items to display
  /// - [index] (int, required): Index of the currently active tab
  /// - [onChanged] (`ValueChanged<int>?`, required): Callback for tab selection
  ///
  /// Example:
  /// ```dart
  /// TabList(
  ///   index: selectedIndex,
  ///   onChanged: (newIndex) {
  ///     setState(() {
  ///       selectedIndex = newIndex;
  ///       // Update content based on new tab selection
  ///     });
  ///   },
  ///   children: [
  ///     TabChild(child: Text('Overview')),
  ///     TabChild(child: Text('Details')),
  ///     TabChild(child: Text('Settings')),
  ///   ],
  /// )
  /// ```
  const TabList({
    super.key,
    required this.children,
    required this.index,
    required this.onChanged,
  });

  Widget _childBuilder(
    BuildContext context,
    TabContainerData data,
    Widget child,
  ) {
    final theme = Theme.of(context);
    final compTheme = ComponentTheme.maybeOf<TabListTheme>(context);
    final indicatorColor = styleValue(
      defaultValue: theme.colorScheme.primary,
      themeValue: compTheme?.indicatorColor,
    );
    final indicatorHeight = styleValue(
      defaultValue: 2 * theme.scaling,
      themeValue: compTheme?.indicatorHeight,
    );
    child = TabButton(
      enabled: data.onSelect != null,
      onPressed: () {
        data.onSelect?.call(data.index);
      },
      child: child,
    );
    return Stack(
      fit: StackFit.passthrough,
      children: [
        data.index == index ? child.foreground() : child.muted(),
        if (data.index == index)
          /// Creates a `Positioned` instance.
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(height: indicatorHeight, color: indicatorColor),
          ),
      ],
    );
  }

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    /// Stores `scaling` state/configuration for this implementation.
    final scaling = theme.scaling;
    final compTheme = ComponentTheme.maybeOf<TabListTheme>(context);
    final borderColor = styleValue(
      defaultValue: theme.colorScheme.border,
      themeValue: compTheme?.borderColor,
    );
    final borderWidth = styleValue(
      defaultValue: 1 * scaling,
      themeValue: compTheme?.borderWidth,
    );
    return TabContainer(
      selected: index,
      onSelect: onChanged,
      builder: (context, children) {
        return Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: borderColor, width: borderWidth),
            ),
          ),
          child: Row(children: children),
        );
      },
      childBuilder: _childBuilder,
      children: children,
    );
  }
}
