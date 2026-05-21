// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../resizable.dart';

/// ResizablePane defines a reusable type for this registry module.
class ResizablePane extends StatefulWidget {
  /// Optional external controller for managing this pane's size.
  final ResizablePaneController? controller;

  /// Initial size in pixels (for absolute sizing).
  final double? initialSize;

  /// Initial flex factor (for flexible sizing).
  final double? initialFlex;

  /// Minimum size constraint in pixels.
  final double? minSize;

  /// Maximum size constraint in pixels.
  final double? maxSize;

  /// Size when collapsed (defaults to 0).
  final double? collapsedSize;

  /// Child widget to display in this pane.
  final Widget child;

  /// Callback when resize drag starts.
  final ValueChanged<double>? onSizeChangeStart;

  /// Callback during resize drag.
  final ValueChanged<double>? onSizeChange;

  /// Callback when resize drag ends.
  final ValueChanged<double>? onSizeChangeEnd;

  /// Callback when resize drag is cancelled.
  final ValueChanged<double>? onSizeChangeCancel;

  /// Whether the pane starts collapsed.
  final bool? initialCollapsed;

  /// Creates a [ResizablePane] with absolute pixel sizing.
  const ResizablePane({
    super.key,
    required double this.initialSize,
    this.minSize,
    this.maxSize,
    this.collapsedSize,
    required this.child,
    this.onSizeChangeStart,
    this.onSizeChange,
    this.onSizeChangeEnd,
    this.onSizeChangeCancel,
    bool this.initialCollapsed = false,
  }) : controller = null,
       initialFlex = null;

  /// Creates a [ResizablePane] with flex-based proportional sizing.
  const ResizablePane.flex({
    super.key,
    double this.initialFlex = 1,
    this.minSize,
    this.maxSize,
    this.collapsedSize,
    required this.child,
    this.onSizeChangeStart,
    this.onSizeChange,
    this.onSizeChangeEnd,
    this.onSizeChangeCancel,
    bool this.initialCollapsed = false,
  }) : controller = null,
       initialSize = null;

  /// Creates a [ResizablePane] controlled by an external [controller].
  const ResizablePane.controlled({
    super.key,
    required ResizablePaneController this.controller,
    this.minSize,
    this.maxSize,
    this.collapsedSize,
    required this.child,
    this.onSizeChangeStart,
    this.onSizeChange,
    this.onSizeChangeEnd,
    this.onSizeChangeCancel,
  }) : initialSize = null,
       initialFlex = null,
       initialCollapsed = null;

  @override
  /// Executes `createState` behavior for this component/composite.
  State<ResizablePane> createState() => _ResizablePaneState();
}
