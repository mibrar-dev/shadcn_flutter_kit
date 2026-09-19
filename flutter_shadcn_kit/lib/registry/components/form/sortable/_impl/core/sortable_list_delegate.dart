// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../sortable.dart';

/// Abstract base for providing items to a sortable list.
///
/// Implement this class to create custom item sources for sortable lists.
/// Provides item count and item retrieval methods.
///
/// Upstream parity: ported from `sortable.dart` upstream.
abstract class SortableListDelegate<T> {
  /// Creates a [SortableListDelegate].
  const SortableListDelegate();

  /// The number of items in the list.
  ///
  /// Returns `null` for infinite or unknown-length lists.
  int? get itemCount;

  /// Retrieves the item at the specified [index].
  ///
  /// Parameters:
  /// - [context] (`BuildContext`, required): Build context.
  /// - [index] (`int`, required): Item index.
  ///
  /// Returns: `T` — the item data.
  T getItem(BuildContext context, int index);
}

/// A delegate that provides items from an explicit list.
///
/// Wraps a fixed [List] of items for use in a sortable list.
///
/// Upstream parity: ported from `sortable.dart` upstream.
class SortableChildListDelegate<T> extends SortableListDelegate<T> {
  /// The list of items.
  final List<T> items;

  /// Builder for creating item widgets.
  final SortableWidgetBuilder<T> builder;

  /// Creates a [SortableChildListDelegate].
  ///
  /// Parameters:
  /// - [items] (`List<T>`, required): The list of items.
  /// - [builder] (`SortableWidgetBuilder<T>`, required): Item widget builder.
  const SortableChildListDelegate(this.items, this.builder);

  @override
  int get itemCount => items.length;

  @override
  T getItem(BuildContext context, int index) => items[index];
}

/// A delegate that builds items on demand.
///
/// Creates items using a builder function rather than from a fixed list.
/// Useful for large or lazily-generated item sets.
///
/// Upstream parity: ported from `sortable.dart` upstream.
class SortableChildBuilderDelegate<T> extends SortableListDelegate<T> {
  @override
  /// The number of items, or `null` for infinite lists.
  final int? itemCount;

  /// Builder function for creating items.
  final SortableItemBuilder<T> builder;

  /// Creates a [SortableChildBuilderDelegate].
  ///
  /// Parameters:
  /// - [itemCount] (`int?`, optional): Number of items, or `null` for infinite.
  /// - [builder] (`SortableItemBuilder<T>`, required): Item builder function.
  const SortableChildBuilderDelegate({this.itemCount, required this.builder});

  @override
  T getItem(BuildContext context, int index) => builder(context, index);
}
