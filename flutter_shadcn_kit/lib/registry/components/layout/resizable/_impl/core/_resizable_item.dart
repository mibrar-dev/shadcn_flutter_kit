// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../resizable.dart';

/// _ResizableItem defines a reusable type for this registry module.
class _ResizableItem extends ResizableItem {
  /// Creates a `_ResizableItem` instance.
  _ResizableItem({
    required super.value,
    super.min,
    super.max,
    super.collapsed,
    super.collapsedSize,
    required this.controller,
  });

  /// Stores `controller` state/configuration for this implementation.
  final ResizablePaneController controller;
}
