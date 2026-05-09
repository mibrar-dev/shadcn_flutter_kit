// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../flex.dart';

/// Parent data mixin that adds custom paint-order metadata.
mixin PaintOrderParentDataMixin
    on rendering.ContainerBoxParentData<rendering.RenderBox> {
  /// Higher values are painted on top.
  int? paintOrder;

  /// Next sibling in paint-sorted order.
  rendering.RenderBox? nextSortedSibling;

  /// Previous sibling in paint-sorted order.
  rendering.RenderBox? previousSortedSibling;

  /// Cached numeric order used during sort.
  int paintIndex = 0;
}
