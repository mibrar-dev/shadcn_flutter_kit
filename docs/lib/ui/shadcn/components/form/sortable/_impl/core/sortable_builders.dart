// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../sortable.dart';

/// Builder function that creates sortable list items.
///
/// Called to construct items for a sortable list at the specified [index].
///
/// Parameters:
/// - [context] (`BuildContext`): Build context.
/// - [index] (`int`): Item index in the list.
///
/// Returns: `T` — the item data.
///
/// Upstream parity: ported from `sortable.dart` upstream.
typedef SortableItemBuilder<T> = T Function(BuildContext context, int index);

/// Builder function that creates widgets for sortable list items.
///
/// Called to build the visual representation of a sortable item.
///
/// Parameters:
/// - [context] (`BuildContext`): Build context.
/// - [index] (`int`): Item index in the list.
/// - [item] (`T`): The item data to display.
///
/// Returns: `Widget` — the visual representation.
///
/// Upstream parity: ported from `sortable.dart` upstream.
typedef SortableWidgetBuilder<T> =
    Widget Function(BuildContext context, int index, T item);
