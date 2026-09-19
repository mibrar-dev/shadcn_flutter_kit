// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../sortable.dart';

/// Represents a collection of list modifications.
///
/// Encapsulates multiple [ListChange] objects that can be applied to a list
/// in sequence. Useful for batch operations or undo/redo functionality.
///
/// Upstream parity: ported from `sortable.dart` upstream.
class ListChanges<T> {
  /// The list of individual changes to apply.
  final List<ListChange<T>> changes;

  /// Creates a [ListChanges] with the specified [changes].
  const ListChanges(this.changes);

  /// Applies all changes to the given [list] in order.
  ///
  /// Parameters:
  /// - [list] (`List<T>`, required): The list to modify.
  void apply(List<T> list) {
    for (var change in changes) {
      change.apply(list);
    }
  }
}

/// Base class for list modification operations.
///
/// Extend this class to create custom list change types. Each change
/// implements [apply] to modify a list in a specific way.
///
/// Upstream parity: ported from `sortable.dart` upstream.
abstract class ListChange<T> {
  /// Creates a [ListChange].
  const ListChange();

  /// Applies this change to the given [list].
  ///
  /// Parameters:
  /// - [list] (`List<T>`, required): The list to modify.
  void apply(List<T> list);
}

/// A list change that swaps two items.
///
/// Exchanges the items at positions [from] and [to] in the list.
///
/// Upstream parity: ported from `sortable.dart` upstream.
class ListSwapChange<T> extends ListChange<T> {
  /// The source index.
  final int from;

  /// The destination index.
  final int to;

  /// Creates a [ListSwapChange] that swaps items at [from] and [to].
  const ListSwapChange(this.from, this.to);

  @override
  void apply(List<T> list) {
    var temp = list[from];
    list[from] = list[to];
    list[to] = temp;
  }
}

/// A list change that removes an item.
///
/// Removes the item at the specified [index] from the list.
///
/// Upstream parity: ported from `sortable.dart` upstream.
class ListRemoveChange<T> extends ListChange<T> {
  /// The index of the item to remove.
  final int index;

  /// Creates a [ListRemoveChange] that removes the item at [index].
  const ListRemoveChange(this.index);

  @override
  void apply(List<T> list) {
    list.removeAt(index);
  }
}

/// A list change that inserts an item.
///
/// Inserts [item] at the specified [index] in the list.
///
/// Upstream parity: ported from `sortable.dart` upstream.
class ListInsertChange<T> extends ListChange<T> {
  /// The index where the item will be inserted.
  final int index;

  /// The item to insert.
  final T item;

  /// Creates a [ListInsertChange] that inserts [item] at [index].
  const ListInsertChange(this.index, this.item);

  @override
  void apply(List<T> list) {
    list.insert(index, item);
  }
}
