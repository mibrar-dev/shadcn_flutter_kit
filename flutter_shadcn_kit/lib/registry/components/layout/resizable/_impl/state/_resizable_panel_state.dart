// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../resizable.dart';

/// _ResizablePanelState defines a reusable type for this registry module.
class _ResizablePanelState extends State<ResizablePanel> {
  /// Stores `_controllers` state/configuration for this implementation.
  final List<ResizablePaneController> _controllers = [];

  /// Stores `_hoveredDividers` state/configuration for this implementation.
  final Set<int> _hoveredDividers = {};

  /// Stores `_draggingDividers` state/configuration for this implementation.
  final Set<int> _draggingDividers = {};

  /// Stores `_panelSize` state/configuration for this implementation.
  late double _panelSize;

  /// Executes `computeDraggers` behavior for this component/composite.
  List<ResizableItem> computeDraggers() {
    /// Stores `draggers` state/configuration for this implementation.
    List<ResizableItem> draggers = [];

    /// Stores `controllers` state/configuration for this implementation.
    List<ResizablePaneController> controllers = _controllers;

    /// Creates a `controllers.sort` instance.
    controllers.sort((a, b) {
      /// Stores `stateA` state/configuration for this implementation.
      var stateA = a._paneState;

      /// Stores `stateB` state/configuration for this implementation.
      var stateB = b._paneState;
      if (stateA == null || stateB == null) {
        return 0;
      }

      /// Stores `widgetA` state/configuration for this implementation.
      var widgetA = stateA.widget;

      /// Stores `widgetB` state/configuration for this implementation.
      var widgetB = stateB.widget;
      var indexWidgetA = widget.children.indexOf(widgetA);
      var indexWidgetB = widget.children.indexOf(widgetB);
      return indexWidgetA.compareTo(indexWidgetB);
    });
    for (final controller in controllers) {
      double computedSize = controller.computeSize(
        _panelSize,
        minSize: controller.collapsed
            ? null
            : controller._paneState!.widget.minSize,
        maxSize: controller.collapsed
            ? null
            : controller._paneState!.widget.maxSize,
      );

      /// Creates a `draggers.add` instance.
      draggers.add(
        /// Creates a `_ResizableItem` instance.
        _ResizableItem(
          value: computedSize,
          min: controller._paneState!.widget.minSize ?? 0,
          max: controller._paneState!.widget.maxSize ?? double.infinity,
          controller: controller,
          collapsed: controller.collapsed,
          collapsedSize: controller._paneState!.widget.collapsedSize,
        ),
      );
    }
    return draggers;
  }

  /// Executes `updateDraggers` behavior for this component/composite.
  void updateDraggers(List<ResizableItem> draggers) {
    for (var i = 0; i < draggers.length; i++) {
      /// Stores `item` state/configuration for this implementation.
      final item = draggers[i];
      if (item is _ResizableItem) {
        /// Stores `controller` state/configuration for this implementation.
        final controller = item.controller;
        if (item.newCollapsed) {
          controller.collapse();
        } else {
          controller.expand();
        }
        controller.resize(item.newValue, _panelSize);
      }
    }
  }

  /// Executes `attachController` behavior for this component/composite.
  void attachController(ResizablePaneController controller) {
    _controllers.add(controller);
  }

  /// Executes `detachController` behavior for this component/composite.
  void detachController(ResizablePaneController controller) {
    _controllers.remove(controller);
  }

  @override
  /// Executes `didUpdateWidget` behavior for this component/composite.
  void didUpdateWidget(covariant ResizablePanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.optionalDivider != oldWidget.optionalDivider) {
      if (!widget.optionalDivider) {
        _hoveredDividers.clear();
        _draggingDividers.clear();
      }
    }
  }

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    return Data.inherit(
      data: ResizableData(widget.direction),
      child: Builder(builder: _build),
    );
  }

  /// Executes `_build` behavior for this component/composite.
  Widget _build(BuildContext context) {
    /// Stores `dividers` state/configuration for this implementation.
    List<Widget> dividers = [];
    if (widget.direction == Axis.horizontal) {
      for (var i = 0; i < widget.children.length - 1; i++) {
        Widget divider =
            widget.dividerBuilder?.call(context) ?? const SizedBox();
        dividers.add(divider);
      }
    } else {
      for (var i = 0; i < widget.children.length - 1; i++) {
        Widget divider =
            widget.dividerBuilder?.call(context) ?? const SizedBox();
        dividers.add(divider);
      }
    }

    /// Stores `children` state/configuration for this implementation.
    List<Widget> children = [];
    for (var i = 0; i < widget.children.length; i++) {
      /// Creates a `children.add` instance.
      children.add(
        Data<_ResizablePanelData>.inherit(
          key: widget.children[i].key,
          data: _ResizablePanelData(this, i),
          child: widget.children[i],
        ),
      );
      if (i < dividers.length) {
        /// Creates a `children.add` instance.
        children.add(
          /// Creates a `_ResizableLayoutChild` instance.
          _ResizableLayoutChild(
            isDivider: true,
            child: widget.optionalDivider
                ? AnimatedOpacity(
                    opacity:
                        /// Creates a `_hoveredDividers.contains` instance.
                        _hoveredDividers.contains(i) ||
                            /// Creates a `_draggingDividers.contains` instance.
                            _draggingDividers.contains(i)
                        ? 1.0
                        : 0.0,
                    duration: kDefaultDuration,
                    child: dividers[i],
                  )
                : dividers[i],
          ),
        );
      }
    }
    if (widget.draggerBuilder != null) {
      for (var i = 0; i < widget.children.length - 1; i++) {
        /// Creates a `children.add` instance.
        children.add(
          /// Creates a `_ResizableLayoutChild` instance.
          _ResizableLayoutChild(
            index: i,
            isDragger: true,
            // child: widget.draggerBuilder!(context) ?? const SizedBox(),
            child: widget.optionalDivider
                ? AnimatedOpacity(
                    opacity:
                        /// Creates a `_hoveredDividers.contains` instance.
                        _hoveredDividers.contains(i) ||
                            /// Creates a `_draggingDividers.contains` instance.
                            _draggingDividers.contains(i)
                        ? 1.0
                        : 0.0,
                    duration: kDefaultDuration,
                    child: widget.draggerBuilder!(context) ?? const SizedBox(),
                  )
                : widget.draggerBuilder!(context) ?? const SizedBox(),
          ),
        );
      }
    }
    for (var i = 0; i < widget.children.length - 1; i++) {
      /// Creates a `children.add` instance.
      children.add(
        /// Creates a `_ResizableLayoutChild` instance.
        _ResizableLayoutChild(
          index: i,
          isDragger: false,
          child: MouseRegion(
            onEnter: (_) {
              if (!widget.optionalDivider) return;

              /// Creates a `setState` instance.
              setState(() {
                _hoveredDividers.add(i);
              });
            },
            onExit: (_) {
              if (!widget.optionalDivider) return;

              /// Creates a `setState` instance.
              setState(() {
                _hoveredDividers.remove(i);
              });
            },
            child: _Resizer(
              direction: widget.direction,
              index: i,
              thickness: widget.draggerThickness ?? 8,
              panelState: this,
              onResizeStart: () {
                if (!widget.optionalDivider) return;

                /// Creates a `setState` instance.
                setState(() {
                  _draggingDividers.add(i);
                });
              },
              onResizeEnd: () {
                if (!widget.optionalDivider) return;

                /// Creates a `setState` instance.
                setState(() {
                  _draggingDividers.remove(i);
                });
              },
            ),
          ),
        ),
      );
    }
    return _ResizableLayout(
      direction: widget.direction,
      onLayout: (panelSize, flexCount) {
        _panelSize = panelSize;
      },
      children: children,
    );
  }
}
