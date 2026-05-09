// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../item_picker.dart';

/// A delegate that wraps a fixed list of items.
///
/// Provides items from a pre-defined `List<T>`.
///
/// Example:
/// ```dart
/// ItemList<String>(['Apple', 'Banana', 'Cherry'])
/// ```
class ItemList<T> extends ItemChildDelegate<T> {
  /// The list of items.
  final List<T> items;

  /// Creates an [ItemList].
  ///
  /// Parameters:
  /// - [items] (`List<T>`, required): The items to provide.
  const ItemList(this.items);

  /// Field storing `itemCount` for this form implementation.
  @override
  int get itemCount => items.length;

  /// Performs `operator []` logic for this form component.
  @override
  T operator [](int index) => items[index];
}
