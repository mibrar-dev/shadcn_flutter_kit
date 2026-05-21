// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../item_picker.dart';

/// A list-based layout for item pickers.
///
/// Displays items in a vertical scrolling list using [ListView.builder].
///
/// Example:
/// ```dart
/// const ListItemPickerLayout()
/// ```
class ListItemPickerLayout extends ItemPickerLayout {
  /// Creates a [ListItemPickerLayout].
  const ListItemPickerLayout();
  @override
  Widget build(
    BuildContext context,
    ItemChildDelegate items,
    ItemPickerBuilder builder,
  ) {
    final padding = MediaQuery.paddingOf(context);
    return MediaQuery.removePadding(
      context: context,
      removeBottom: true,
      removeLeft: true,
      removeRight: true,
      removeTop: true,
      child: ListView.builder(
        itemCount: items.itemCount,
        padding: padding,
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
