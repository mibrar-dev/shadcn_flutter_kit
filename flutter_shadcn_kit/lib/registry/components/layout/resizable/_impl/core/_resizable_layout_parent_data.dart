// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../resizable.dart';

/// _ResizableLayoutParentData defines a reusable type for this registry module.
class _ResizableLayoutParentData extends ContainerBoxParentData<RenderBox> {
  // if index is null, then its an overlay that handle the resize dragger (on the border/edge)
  /// Stores `index` state/configuration for this implementation.
  int? index;
  // if isDragger is true, then its a dragger that should be placed above "index" panel right border
  /// Stores `isDragger` state/configuration for this implementation.
  bool? isDragger;
  // there are total "totalPanes" - 1 of dragger
  /// Stores `isDivider` state/configuration for this implementation.
  bool? isDivider;

  /// Stores `size` state/configuration for this implementation.
  double? size;

  /// Stores `flex` state/configuration for this implementation.
  double? flex;
}
