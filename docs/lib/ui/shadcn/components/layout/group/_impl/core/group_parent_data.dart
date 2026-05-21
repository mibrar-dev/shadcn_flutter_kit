// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../group_widget.dart';

/// Parent data that stores explicit offsets and sizes for each child.
class GroupParentData extends ContainerBoxParentData<RenderBox> {
  /// Stores `top` state/configuration for this implementation.
  double? top;

  /// Stores `left` state/configuration for this implementation.
  double? left;

  /// Stores `right` state/configuration for this implementation.
  double? right;

  /// Stores `bottom` state/configuration for this implementation.
  double? bottom;

  /// Stores `width` state/configuration for this implementation.
  double? width;

  /// Stores `height` state/configuration for this implementation.
  double? height;
}
