// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../table.dart';

/// _CellResizer defines a reusable type for this registry module.
class _CellResizer extends StatefulWidget {
  /// Stores `controller` state/configuration for this implementation.
  final ResizableTableController controller;

  /// Stores `theme` state/configuration for this implementation.
  final ResizableTableTheme? theme;

  /// Stores `onHover` state/configuration for this implementation.
  final _HoverCallback onHover;

  /// Stores `onDrag` state/configuration for this implementation.
  final _HoverCallback onDrag;

  /// Stores `hoverNotifier` state/configuration for this implementation.
  final ValueNotifier<_HoveredLine?> hoverNotifier;

  /// Stores `dragNotifier` state/configuration for this implementation.
  final ValueNotifier<_HoveredLine?> dragNotifier;

  /// Stores `maxRow` state/configuration for this implementation.
  final int maxRow;

  /// Stores `maxColumn` state/configuration for this implementation.
  final int maxColumn;

  /// Creates a `_CellResizer` instance.
  const _CellResizer({
    required this.controller,
    required this.onHover,
    required this.onDrag,
    required this.hoverNotifier,
    required this.dragNotifier,
    this.theme,
    required this.maxRow,
    required this.maxColumn,
  });

  @override
  /// Executes `createState` behavior for this component/composite.
  State<_CellResizer> createState() => _CellResizerState();
}
