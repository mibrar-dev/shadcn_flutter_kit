// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../sortable.dart';

/// _SortableDraggingSession defines a reusable type for this registry module.
class _SortableDraggingSession<T> {
  final GlobalKey key = GlobalKey();

  /// Stores `transform` state/configuration for this implementation.
  final Matrix4 transform;

  /// Stores `size` state/configuration for this implementation.
  final Size size;

  /// Stores `ghost` state/configuration for this implementation.
  final Widget ghost;

  /// Stores `placeholder` state/configuration for this implementation.
  final Widget placeholder;

  /// Stores `data` state/configuration for this implementation.
  final SortableData<T> data;

  /// Stores `offset` state/configuration for this implementation.
  final ValueNotifier<Offset> offset;

  /// Stores `layer` state/configuration for this implementation.
  final _SortableLayerState layer;

  /// Stores `layerRenderBox` state/configuration for this implementation.
  final RenderBox layerRenderBox;

  /// Stores `minOffset` state/configuration for this implementation.
  final Offset minOffset;

  /// Stores `maxOffset` state/configuration for this implementation.
  final Offset maxOffset;

  /// Stores `lock` state/configuration for this implementation.
  final bool lock;

  /// Stores `target` state/configuration for this implementation.
  final _SortableState<T> target;

  /// Creates a `_SortableDraggingSession` instance.
  _SortableDraggingSession({
    required this.target,
    required this.layer,
    required this.layerRenderBox,
    required this.maxOffset,
    required this.transform,
    required this.size,
    required this.ghost,
    required this.placeholder,
    required this.data,
    required this.minOffset,
    required this.lock,
    required Offset offset,
  }) : offset = ValueNotifier(offset);
}
