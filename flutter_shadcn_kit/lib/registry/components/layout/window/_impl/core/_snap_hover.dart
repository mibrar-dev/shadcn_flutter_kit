// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../window.dart';

/// _SnapHover defines a reusable type for this registry module.
class _SnapHover extends StatefulWidget {
  /// Stores `topLeft` state/configuration for this implementation.
  final bool topLeft;

  /// Stores `topRight` state/configuration for this implementation.
  final bool topRight;

  /// Stores `bottomLeft` state/configuration for this implementation.
  final bool bottomLeft;

  /// Stores `bottomRight` state/configuration for this implementation.
  final bool bottomRight;

  /// Stores `hovering` state/configuration for this implementation.
  final ValueChanged<bool> hovering;

  /// Creates a `_SnapHover` instance.
  const _SnapHover({
    this.topLeft = false,
    this.topRight = false,
    this.bottomLeft = false,
    this.bottomRight = false,
    required this.hovering,
  });

  @override
  /// Executes `createState` behavior for this component/composite.
  State<_SnapHover> createState() => _SnapHoverState();
}
