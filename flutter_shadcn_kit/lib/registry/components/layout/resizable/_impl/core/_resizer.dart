// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../resizable.dart';

/// _Resizer defines a reusable type for this registry module.
class _Resizer extends StatefulWidget {
  /// Stores `direction` state/configuration for this implementation.
  final Axis direction;

  /// Stores `index` state/configuration for this implementation.
  final int index;

  /// Stores `thickness` state/configuration for this implementation.
  final double thickness;

  /// Stores `panelState` state/configuration for this implementation.
  final _ResizablePanelState panelState;

  /// Stores `onResizeStart` state/configuration for this implementation.
  final VoidCallback? onResizeStart;

  /// Stores `onResizeEnd` state/configuration for this implementation.
  final VoidCallback? onResizeEnd;

  /// Creates a `_Resizer` instance.
  const _Resizer({
    required this.direction,
    required this.index,
    required this.thickness,
    required this.panelState,
    this.onResizeStart,
    this.onResizeEnd,
  });

  @override
  /// Executes `createState` behavior for this component/composite.
  State<_Resizer> createState() => _ResizerState();
}
