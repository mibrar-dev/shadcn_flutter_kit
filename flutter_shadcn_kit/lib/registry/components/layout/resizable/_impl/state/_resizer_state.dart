// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../resizable.dart';

/// _ResizerState defines a reusable type for this registry module.
class _ResizerState extends State<_Resizer> {
  /// Stores `_dragSession` state/configuration for this implementation.
  Resizer? _dragSession;

  /// Executes `_onDragStart` behavior for this component/composite.
  void _onDragStart(DragStartDetails details) {
    _dragSession = Resizer(widget.panelState.computeDraggers());

    // Call onSizeChangeStart callbacks for affected panes
    _callSizeChangeStartCallbacks();
    widget.onResizeStart?.call();
  }

  /// Executes `_onDragUpdate` behavior for this component/composite.
  void _onDragUpdate(DragUpdateDetails details) {
    _dragSession!.dragDivider(widget.index + 1, details.primaryDelta!);
    widget.panelState.updateDraggers(_dragSession!.items);

    // Call onSizeChange callbacks for affected panes
    _callSizeChangeCallbacks();
  }

  /// Executes `_onDragEnd` behavior for this component/composite.
  void _onDragEnd(DragEndDetails details) {
    // Call onSizeChangeEnd callbacks for affected panes
    _callSizeChangeEndCallbacks();
    _dragSession = null;
    widget.onResizeEnd?.call();
  }

  /// Executes `_onDragCancel` behavior for this component/composite.
  void _onDragCancel() {
    _dragSession!.reset();
    widget.panelState.updateDraggers(_dragSession!.items);

    // Call onSizeChangeCancel callbacks for affected panes
    _callSizeChangeCancelCallbacks();
    _dragSession = null;
    widget.onResizeEnd?.call();
  }

  /// Executes `_callSizeChangeStartCallbacks` behavior for this component/composite.
  void _callSizeChangeStartCallbacks() {
    if (_dragSession == null) return;

    // Call callbacks for the two panes adjacent to this divider
    /// Creates a `_callStartCallbackForPane` instance.
    _callStartCallbackForPane(
      widget.index,
      _dragSession!.items[widget.index].value,
    );
    if (widget.index + 1 < _dragSession!.items.length) {
      /// Creates a `_callStartCallbackForPane` instance.
      _callStartCallbackForPane(
        widget.index + 1,
        _dragSession!.items[widget.index + 1].value,
      );
    }
  }

  /// Executes `_callSizeChangeCallbacks` behavior for this component/composite.
  void _callSizeChangeCallbacks() {
    if (_dragSession == null) return;

    // Call callbacks for the two panes adjacent to this divider
    /// Creates a `_callChangeCallbackForPane` instance.
    _callChangeCallbackForPane(
      widget.index,
      _dragSession!.items[widget.index].newValue,
    );
    if (widget.index + 1 < _dragSession!.items.length) {
      /// Creates a `_callChangeCallbackForPane` instance.
      _callChangeCallbackForPane(
        widget.index + 1,
        _dragSession!.items[widget.index + 1].newValue,
      );
    }
  }

  /// Executes `_callSizeChangeEndCallbacks` behavior for this component/composite.
  void _callSizeChangeEndCallbacks() {
    if (_dragSession == null) return;

    // Call callbacks for the two panes adjacent to this divider
    /// Creates a `_callEndCallbackForPane` instance.
    _callEndCallbackForPane(
      widget.index,
      _dragSession!.items[widget.index].newValue,
    );
    if (widget.index + 1 < _dragSession!.items.length) {
      /// Creates a `_callEndCallbackForPane` instance.
      _callEndCallbackForPane(
        widget.index + 1,
        _dragSession!.items[widget.index + 1].newValue,
      );
    }
  }

  /// Executes `_callSizeChangeCancelCallbacks` behavior for this component/composite.
  void _callSizeChangeCancelCallbacks() {
    if (_dragSession == null) return;

    // Call callbacks for the two panes adjacent to this divider
    /// Creates a `_callCancelCallbackForPane` instance.
    _callCancelCallbackForPane(
      widget.index,
      _dragSession!.items[widget.index].newValue,
    );
    if (widget.index + 1 < _dragSession!.items.length) {
      /// Creates a `_callCancelCallbackForPane` instance.
      _callCancelCallbackForPane(
        widget.index + 1,
        _dragSession!.items[widget.index + 1].newValue,
      );
    }
  }

  /// Executes `_getControllerAtIndex` behavior for this component/composite.
  ResizablePaneController? _getControllerAtIndex(int paneIndex) {
    if (paneIndex < 0 ||
        paneIndex >= widget.panelState.widget.children.length) {
      return null;
    }

    // Find controller by matching the widget at the given index
    /// Stores `targetWidget` state/configuration for this implementation.
    final targetWidget = widget.panelState.widget.children[paneIndex];
    for (final controller in widget.panelState._controllers) {
      /// Stores `paneState` state/configuration for this implementation.
      final paneState = controller._paneState;
      if (paneState?.widget == targetWidget) {
        return controller;
      }
    }
    return null;
  }

  /// Executes `_callStartCallbackForPane` behavior for this component/composite.
  void _callStartCallbackForPane(int paneIndex, double size) {
    final controller = _getControllerAtIndex(paneIndex);

    /// Stores `callback` state/configuration for this implementation.
    final callback = controller?._paneState?.widget.onSizeChangeStart;
    callback?.call(size);
  }

  /// Executes `_callChangeCallbackForPane` behavior for this component/composite.
  void _callChangeCallbackForPane(int paneIndex, double size) {
    final controller = _getControllerAtIndex(paneIndex);

    /// Stores `callback` state/configuration for this implementation.
    final callback = controller?._paneState?.widget.onSizeChange;
    callback?.call(size);
  }

  /// Executes `_callEndCallbackForPane` behavior for this component/composite.
  void _callEndCallbackForPane(int paneIndex, double size) {
    final controller = _getControllerAtIndex(paneIndex);

    /// Stores `callback` state/configuration for this implementation.
    final callback = controller?._paneState?.widget.onSizeChangeEnd;
    callback?.call(size);
  }

  /// Executes `_callCancelCallbackForPane` behavior for this component/composite.
  void _callCancelCallbackForPane(int paneIndex, double size) {
    final controller = _getControllerAtIndex(paneIndex);

    /// Stores `callback` state/configuration for this implementation.
    final callback = controller?._paneState?.widget.onSizeChangeCancel;
    callback?.call(size);
  }

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.direction == Axis.horizontal ? widget.thickness : null,
      height: widget.direction == Axis.vertical ? widget.thickness : null,
      child: MouseRegion(
        cursor: widget.direction == Axis.horizontal
            ? SystemMouseCursors.resizeColumn
            : SystemMouseCursors.resizeRow,
        hitTestBehavior: HitTestBehavior.translucent,
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onVerticalDragStart: widget.direction == Axis.vertical
              ? _onDragStart
              : null,
          onHorizontalDragStart: widget.direction == Axis.horizontal
              ? _onDragStart
              : null,
          onVerticalDragUpdate: widget.direction == Axis.vertical
              ? _onDragUpdate
              : null,
          onHorizontalDragUpdate: widget.direction == Axis.horizontal
              ? _onDragUpdate
              : null,
          onVerticalDragEnd: widget.direction == Axis.vertical
              ? _onDragEnd
              : null,
          onHorizontalDragEnd: widget.direction == Axis.horizontal
              ? _onDragEnd
              : null,
          onVerticalDragCancel: widget.direction == Axis.vertical
              ? _onDragCancel
              : null,
          onHorizontalDragCancel: widget.direction == Axis.horizontal
              ? _onDragCancel
              : null,
        ),
      ),
    );
  }
}
