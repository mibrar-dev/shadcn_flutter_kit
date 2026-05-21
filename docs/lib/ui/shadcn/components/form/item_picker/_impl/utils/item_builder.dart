// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../item_picker.dart';

/// A delegate that builds items on demand using a builder function.
///
/// Allows lazy generation of items, useful for large or infinite lists.
///
/// Example:
/// ```dart
/// ItemBuilder<int>(
///   itemCount: 100,
///   itemBuilder: (index) => index * 2,
/// )
/// ```
class ItemBuilder<T> extends ItemChildDelegate<T> {
  /// The total number of items, or null if infinite.
  @override
  final int? itemCount;

  /// Builder function that returns an item for the given index.
  final T? Function(int index) itemBuilder;

  /// Creates an [ItemBuilder].
  ///
  /// Parameters:
  /// - [itemCount] (`int?`, optional): Number of items, or null if infinite.
  /// - [itemBuilder] (`T? Function(int)`, required): Function to build items.
  const ItemBuilder({this.itemCount, required this.itemBuilder});

  /// Performs `operator []` logic for this form component.
  @override
  T? operator [](int index) => itemBuilder(index);
}
