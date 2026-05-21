// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../select.dart';

/// Abstract base class for building select item lists.
///
/// Provides interface for rendering select items with optional caching
/// and change detection.
abstract class SelectItemDelegate with CachedValue {
  /// An empty select item delegate constant.
  static const empty = EmptySelectItem();

  /// Creates a select item delegate.
  const SelectItemDelegate();

  /// Builds a widget for the item at the given index.
  Widget? build(BuildContext context, int index);

  /// Estimated number of children in this delegate.
  int? get estimatedChildCount => null;

  @override
  bool shouldRebuild(covariant SelectItemDelegate oldDelegate);
}
