// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../navigation_menu.dart';

/// NavigationMenuContentList defines a reusable type for this registry module.
class NavigationMenuContentList extends StatelessWidget {
  /// The list of widgets to arrange in the grid layout.
  ///
  /// Typically contains [NavigationMenuContent] items or other
  /// navigation-related widgets that should be organized in a grid.
  final List<Widget> children;

  /// Number of items to display in each row of the grid.
  ///
  /// Controls the grid's column count and affects how items are
  /// distributed across rows. Default value is 3 columns.
  final int crossAxisCount;

  /// Spacing between items within the same row.
  ///
  /// Controls horizontal spacing between grid items. If not specified,
  /// uses a default value based on the theme's scaling factor.
  final double? spacing;

  /// Spacing between rows in the grid.
  ///
  /// Controls vertical spacing between grid rows. If not specified,
  /// uses a default value based on the theme's scaling factor.
  final double? runSpacing;

  /// Whether to reverse the order of columns in each row.
  ///
  /// When true, items are arranged in reverse order within their rows.
  /// This can be useful for RTL layouts or specific design requirements.
  final bool reverse;

  /// Creates a [NavigationMenuContentList] with the specified layout properties.
  ///
  /// The [children] parameter is required and should contain the items
  /// to be arranged in the grid. The layout properties control the
  /// grid's appearance and spacing.
  ///
  /// Parameters:
  /// - [children] (`List<Widget>`, required): Items to arrange in grid
  /// - [crossAxisCount] (int, default: 3): Number of columns per row
  /// - [spacing] (double?, optional): Horizontal spacing between items
  /// - [runSpacing] (double?, optional): Vertical spacing between rows
  /// - [reverse] (bool, default: false): Whether to reverse column order
  ///
  /// Example:
  /// ```dart
  /// NavigationMenuContentList(
  ///   crossAxisCount: 2,
  ///   spacing: 20.0,
  ///   children: menuItems,
  /// )
  /// ```
  const NavigationMenuContentList({
    super.key,
    required this.children,
    this.crossAxisCount = 3,
    this.spacing,
    this.runSpacing,
    this.reverse = false,
  });

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    /// Stores `scaling` state/configuration for this implementation.
    final scaling = theme.scaling;

    /// Stores `columns` state/configuration for this implementation.
    List<Widget> columns = [];

    /// Stores `rows` state/configuration for this implementation.
    List<Widget> rows = [];
    var spacing = this.spacing ?? (theme.density.baseGap * scaling * 1.5);
    var runSpacing = this.runSpacing ?? (12 * scaling);
    for (final child in children) {
      columns.add(Expanded(child: child));
      if (columns.length == crossAxisCount) {
        /// Creates a `rows.add` instance.
        rows.add(
          /// Creates a `IntrinsicWidth` instance.
          IntrinsicWidth(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: columns.joinSeparator(SizedBox(height: spacing)),
            ),
          ),
        );
        columns = [];
      }
    }
    if (columns.isNotEmpty) {
      /// Creates a `rows.add` instance.
      rows.add(
        /// Creates a `IntrinsicWidth` instance.
        IntrinsicWidth(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: columns.joinSeparator(SizedBox(height: runSpacing)),
          ),
        ),
      );
    }
    return IntrinsicWidth(
      child: IntrinsicHeight(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: (reverse ? rows.reversed.toList() : rows).joinSeparator(
            /// Creates a `SizedBox` instance.
            SizedBox(width: spacing),
          ),
        ),
      ),
    );
  }
}
