// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../item_picker.dart';

/// A grid-based layout for item pickers.
///
/// Displays items in a scrollable grid using [GridView.builder]. The number
/// of columns can be configured via [crossAxisCount].
///
/// Example:
/// ```dart
/// GridItemPickerLayout(crossAxisCount: 3)
/// ```
class GridItemPickerLayout extends ItemPickerLayout {
  /// Number of columns in the grid.
  final int crossAxisCount;

  /// Creates a [GridItemPickerLayout].
  ///
  /// Parameters:
  /// - [crossAxisCount] (`int`, default: `4`): The number of grid columns.
  const GridItemPickerLayout({this.crossAxisCount = 4});

  /// Creates a copy of this layout with a different column count.
  ///
  /// Parameters:
  /// - [crossAxisCount] (`int`, default: `4`): The new column count.
  ///
  /// Returns: A new [GridItemPickerLayout] with the specified columns.
  ItemPickerLayout call({int crossAxisCount = 4}) {
    return GridItemPickerLayout(crossAxisCount: crossAxisCount);
  }

  @override
  Widget build(
    BuildContext context,
    ItemChildDelegate items,
    ItemPickerBuilder builder,
  ) {
    final theme = Theme.of(context);
    final padding = MediaQuery.paddingOf(context);
    return MediaQuery.removePadding(
      context: context,
      removeBottom: true,
      removeLeft: true,
      removeRight: true,
      removeTop: true,
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: 4.0 * theme.scaling,
          crossAxisSpacing: 4.0 * theme.scaling,
        ),
        padding: padding,
        itemCount: items.itemCount,
        itemBuilder: (context, index) {
          var item = items[index];
          if (item == null) {
            return null;
          }
          return builder(context, item);
        },
      ),
    );
  }
}
