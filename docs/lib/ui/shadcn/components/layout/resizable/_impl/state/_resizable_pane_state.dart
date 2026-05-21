// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../resizable.dart';

/// _ResizablePaneState defines a reusable type for this registry module.
class _ResizablePaneState extends State<ResizablePane> {
  /// Stores `_controller` state/configuration for this implementation.
  late ResizablePaneController _controller;

  /// Stores `_panelState` state/configuration for this implementation.
  _ResizablePanelData? _panelState;

  @override
  /// Executes `initState` behavior for this component/composite.
  void initState() {
    super.initState();
    if (widget.controller != null) {
      _controller = widget.controller!;
    } else if (widget.initialSize != null) {
      _controller = AbsoluteResizablePaneController(
        widget.initialSize!,
        collapsed: widget.initialCollapsed!,
      );
    } else {
      assert(widget.initialFlex != null, 'initalFlex must not be null');
      _controller = FlexibleResizablePaneController(
        widget.initialFlex!,
        collapsed: widget.initialCollapsed!,
      );
    }
    _controller._attachPaneState(this);
  }

  @override
  /// Executes `didChangeDependencies` behavior for this component/composite.
  void didChangeDependencies() {
    super.didChangeDependencies();
    var newPanelState = Data.maybeOf<_ResizablePanelData>(context);
    if (_panelState != newPanelState) {
      _panelState?.detach(_controller);
      _panelState = newPanelState;
      _panelState?.attach(_controller);
    }
  }

  @override
  /// Executes `didUpdateWidget` behavior for this component/composite.
  void didUpdateWidget(covariant ResizablePane oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      _controller._detachPaneState(this);
      _panelState?.detach(_controller);
      if (widget.controller != null) {
        _controller = widget.controller!;
      } else if (widget.initialSize != null) {
        if (_controller is! AbsoluteResizablePaneController) {
          _controller = AbsoluteResizablePaneController(
            widget.initialSize!,
            collapsed: widget.initialCollapsed!,
          );
        }
      } else {
        if (_controller is! FlexibleResizablePaneController) {
          assert(widget.initialFlex != null, 'initalFlex must not be null');
          _controller = FlexibleResizablePaneController(
            widget.initialFlex!,
            collapsed: widget.initialCollapsed!,
          );
        }
      }
      _panelState?.attach(_controller);

      /// Creates a `assert` instance.
      assert(
        _panelState != null,
        'ResizablePane must be a child of ResizablePanel',
      );
      _controller._attachPaneState(this);
    }
  }

  /// Executes `tryExpand` behavior for this component/composite.
  bool tryExpand([PanelSibling direction = PanelSibling.both]) {
    if (!_controller.collapsed) {
      return false;
    }
    List<ResizableItem> draggers = _panelState!.state.computeDraggers();
    Resizer resizer = Resizer(draggers);
    bool result = resizer.attemptExpandCollapsed(
      _panelState!.index,
      direction.direction,
    );
    if (result) {
      _panelState!.state.updateDraggers(resizer.items);
    }
    return result;
  }

  /// Executes `tryCollapse` behavior for this component/composite.
  bool tryCollapse([PanelSibling direction = PanelSibling.both]) {
    if (_controller.collapsed) {
      return false;
    }
    List<ResizableItem> draggers = _panelState!.state.computeDraggers();
    Resizer resizer = Resizer(draggers);
    bool result = resizer.attemptCollapse(
      _panelState!.index,
      direction.direction,
    );
    if (result) {
      _panelState!.state.updateDraggers(resizer.items);
    }
    return result;
  }

  bool tryExpandSize(
    double size, [
    PanelSibling direction = PanelSibling.both,
  ]) {
    List<ResizableItem> draggers = _panelState!.state.computeDraggers();
    Resizer resizer = Resizer(draggers);
    bool result = resizer.attemptExpand(
      _panelState!.index,
      direction.direction,
      size,
    );
    if (result) {
      _panelState!.state.updateDraggers(resizer.items);
    }
    return result;
  }

  @override
  /// Executes `dispose` behavior for this component/composite.
  void dispose() {
    super.dispose();
    _controller._detachPaneState(this);
    _panelState?.detach(_controller);
  }

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, child) {
        /// Stores `size` state/configuration for this implementation.
        double? size;

        /// Stores `flex` state/configuration for this implementation.
        double? flex;
        if (_controller is AbsoluteResizablePaneController) {
          /// Stores `controller` state/configuration for this implementation.
          final controller = _controller as AbsoluteResizablePaneController;
          if (controller.collapsed) {
            size = widget.collapsedSize;
          } else {
            size = controller.value;
          }
        } else if (_controller is FlexibleResizablePaneController) {
          /// Stores `controller` state/configuration for this implementation.
          final controller = _controller as FlexibleResizablePaneController;
          if (controller.collapsed) {
            size = widget.collapsedSize;
          } else {
            flex = controller.value;
          }
        }
        return _ResizableLayoutChild(
          size: size,
          flex: flex,
          child: ClipRect(child: widget.child),
        );
      },
    );
  }
}
