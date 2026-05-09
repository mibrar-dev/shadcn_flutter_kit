// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../window.dart';

/// _WindowWidgetState defines a reusable type for this registry module.
class _WindowWidgetState extends State<WindowWidget> with WindowHandle {
  @override
  /// Stores `controller` state/configuration for this implementation.
  late WindowController controller;

  /// Stores `state` state/configuration for this implementation.
  late WindowState state;

  /// Stores `_viewport` state/configuration for this implementation.
  WindowViewport? _viewport;

  /// Stores `_entry` state/configuration for this implementation.
  Window? _entry;

  /// Stores `_dragAlignment` state/configuration for this implementation.
  Alignment? _dragAlignment;

  /// Executes `_initializeController` behavior for this component/composite.
  void _initializeController() {
    if (widget.controller != null) {
      controller = widget.controller!;
    } else {
      controller = WindowController(
        bounds: widget.bounds!,
        maximized: widget.maximized,
        minimized: widget.minimized!,
        closable: widget.closable!,
        resizable: widget.resizable!,
        draggable: widget.draggable!,
        maximizable: widget.maximizable!,
        minimizable: widget.minimizable!,
        enableSnapping: widget.enableSnapping!,
        constraints: widget.constraints!,
      );
    }
    controller._attachedState = this;
    state = controller.value;
    controller.addListener(_handleControllerUpdate);
  }

  /// Executes `_handleControllerUpdate` behavior for this component/composite.
  void _handleControllerUpdate() {
    didControllerUpdate(state);
    state = controller.value;
  }

  /// Executes `didControllerUpdate` behavior for this component/composite.
  void didControllerUpdate(WindowState oldState) {
    if (oldState.alwaysOnTop != state.alwaysOnTop) {
      _viewport?.navigator.setAlwaysOnTop(_entry!, state.alwaysOnTop);
    }
  }

  @override
  /// Executes `initState` behavior for this component/composite.
  void initState() {
    super.initState();
    _initializeController();
  }

  @override
  /// Executes `didChangeDependencies` behavior for this component/composite.
  void didChangeDependencies() {
    super.didChangeDependencies();
    _viewport = Data.maybeOf<WindowViewport>(context);
    _entry = Data.maybeOf<Window>(context);
  }

  @override
  /// Executes `didUpdateWidget` behavior for this component/composite.
  void didUpdateWidget(covariant WindowWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      controller.removeListener(_handleControllerUpdate);
      controller._attachedState = null;

      /// Stores `oldState` state/configuration for this implementation.
      WindowState oldState = state;
      _initializeController();
      if (oldState != state) {
        didControllerUpdate(oldState);
      }
    }
  }

  Widget _wrapResizer({
    required MouseCursor cursor,
    required Rect Function(Rect bounds, Offset delta) onResize,
    required int adjustmentX,
    required int adjustmentY,
  }) {
    return MouseRegion(
      cursor: cursor,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onPanUpdate: (details) {
          if (state.maximized != null || state.minimized) return;
          var newBounds = onResize(bounds, details.delta);

          /// Stores `deltaXAdjustment` state/configuration for this implementation.
          double deltaXAdjustment = 0;

          /// Stores `deltaYAdjustment` state/configuration for this implementation.
          double deltaYAdjustment = 0;
          if (newBounds.width < state.constraints.minWidth) {
            deltaXAdjustment = state.constraints.minWidth - newBounds.width;
          } else if (newBounds.width > state.constraints.maxWidth) {
            deltaXAdjustment = state.constraints.maxWidth - newBounds.width;
          }
          if (newBounds.height < state.constraints.minHeight) {
            deltaYAdjustment = state.constraints.minHeight - newBounds.height;
          } else if (newBounds.height > state.constraints.maxHeight) {
            deltaYAdjustment = state.constraints.maxHeight - newBounds.height;
          }
          deltaXAdjustment *= adjustmentX;
          deltaYAdjustment *= adjustmentY;
          if (deltaXAdjustment != 0 || deltaYAdjustment != 0) {
            newBounds = onResize(
              newBounds,

              /// Creates a `Offset` instance.
              Offset(deltaXAdjustment, deltaYAdjustment),
            );
          }
          bounds = newBounds;
        },
      ),
    );
  }

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Data<WindowHandle>.inherit(
      data: this,
      child: ListenableBuilder(
        listenable: controller,
        builder: (context, child) {
          final compTheme = ComponentTheme.maybeOf<WindowTheme>(context);
          var resizeThickness =
              widget.resizeThickness ?? compTheme?.resizeThickness ?? 8;
          final titleBarHeight =
              (widget.titleBarHeight ?? compTheme?.titleBarHeight ?? 32) *
              theme.scaling;

          Widget windowClient = Card(
            clipBehavior: Clip.antiAlias,
            padding: EdgeInsets.zero,
            borderRadius: state.maximized != null
                ? BorderRadius.zero
                : theme.borderRadiusMd,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (widget.title != null || widget.actions != null)
                  /// Creates a `ClickDetector` instance.
                  ClickDetector(
                    onClick: maximizable
                        ? (details) {
                            if (details.clickCount >= 2) {
                              if (maximized == null) {
                                maximized = const Rect.fromLTWH(0, 0, 1, 1);
                              } else {
                                maximized = null;
                              }
                            }
                          }
                        : null,
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onPanStart: (details) {
                        /// Stores `localPosition` state/configuration for this implementation.
                        var localPosition = details.localPosition;

                        /// Stores `bounds` state/configuration for this implementation.
                        var bounds = this.bounds;

                        /// Stores `max` state/configuration for this implementation.
                        var max = maximized;

                        /// Stores `size` state/configuration for this implementation.
                        var size = _viewport?.size;
                        if (max != null && size != null) {
                          bounds = Rect.fromLTWH(
                            max.left * size.width,
                            max.top * size.height,
                            max.width * size.width,
                            max.height * size.height,
                          );
                        }
                        var alignX = lerpDouble(
                          -1,
                          1,
                          (localPosition.dx / bounds.width),
                        )!;
                        var alignY = lerpDouble(
                          -1,
                          1,
                          (localPosition.dy / bounds.height),
                        )!;
                        _dragAlignment = Alignment(alignX, alignY);
                        if (_entry != null) {
                          _viewport?.navigator._state._startDraggingWindow(
                            _entry!,
                            details.globalPosition,
                          );
                        }
                        if (state.maximized != null) {
                          maximized = null;
                          RenderBox? layerRenderBox =
                              _viewport?.navigator._state.context
                                      .findRenderObject()
                                  as RenderBox?;
                          if (layerRenderBox != null) {
                            Offset layerLocal = layerRenderBox.globalToLocal(
                              details.globalPosition,
                            );
                            Size titleSize = Size(
                              this.bounds.width,
                              titleBarHeight,
                            );
                            this.bounds = Rect.fromLTWH(
                              layerLocal.dx - titleSize.width / 2,
                              layerLocal.dy - titleSize.height / 2,
                              this.bounds.width,
                              this.bounds.height,
                            );
                          }
                        }
                      },
                      onPanUpdate: (details) {
                        bounds = bounds.translate(
                          details.delta.dx,
                          details.delta.dy,
                        );
                        if (_entry != null) {
                          _viewport?.navigator._state._updateDraggingWindow(
                            _entry!,
                            details.globalPosition,
                          );
                        }
                      },
                      onPanEnd: (details) {
                        if (_entry != null) {
                          _viewport?.navigator._state._stopDraggingWindow(
                            _entry!,
                          );
                        }
                        _dragAlignment = null;
                      },
                      onPanCancel: () {
                        if (_entry != null) {
                          _viewport?.navigator._state._stopDraggingWindow(
                            _entry!,
                          );
                        }
                        _dragAlignment = null;
                      },
                      child: Container(
                        height: titleBarHeight,
                        padding: EdgeInsets.all(
                          theme.density.baseGap * theme.scaling * 0.25,
                        ),
                        child: Row(
                          children: [
                            /// Creates a `Expanded` instance.
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8 * theme.scaling,
                                ),
                                child: (_viewport?.focused ?? true)
                                    ? (widget.title ?? const SizedBox())
                                    : (widget.title ?? const SizedBox())
                                          .muted(),
                              ),
                            ),
                            if (widget.actions != null) widget.actions!,
                          ],
                        ),
                      ),
                    ),
                  ),
                if (widget.content != null) Expanded(child: widget.content!),
              ],
            ),
          );
          // add transition
          windowClient = AnimatedValueBuilder(
            initialValue: 0.0,
            value: (_viewport?.closed ?? false) ? 0.0 : 1.0,
            duration: kDefaultDuration,
            onEnd: (value) {
              if (_viewport?.closed ?? false) {
                _viewport?.navigator.removeWindow(_entry!);
              }
            },
            builder: (context, value, child) {
              return Transform.scale(
                scale: (_viewport?.closed ?? false)
                    ? lerpDouble(0.8, 1.0, value)!
                    : lerpDouble(0.9, 1.0, value)!,
                child: Opacity(opacity: value, child: child),
              );
            },
            child: windowClient,
          );
          windowClient = AnimatedScale(
            scale: (_viewport?.minify ?? false) ? 0.65 : 1.0,
            duration: kDefaultDuration,
            alignment: _dragAlignment ?? Alignment.center,
            curve: Curves.easeInOut,
            child: windowClient,
          );
          windowClient = IgnorePointer(
            ignoring: _viewport?.ignorePointer ?? false,
            child: windowClient,
          );
          Widget windowContainer = Listener(
            behavior: HitTestBehavior.translucent,
            onPointerDown: (event) {
              if (_entry != null) {
                _viewport?.navigator.focusWindow(_entry!);
              }
            },
            child: GroupWidget(
              children: [
                windowClient,
                // Resize regions
                if (resizable &&
                    maximized == null &&
                    _dragAlignment == null) ...[
                  // top left
                  /// Creates a `GroupPositioned` instance.
                  GroupPositioned(
                    top: 0,
                    left: 0,
                    width: resizeThickness * theme.scaling,
                    height: resizeThickness * theme.scaling,
                    child: _wrapResizer(
                      cursor: SystemMouseCursors.resizeUpLeft,
                      adjustmentX: -1,
                      adjustmentY: -1,
                      onResize: (bounds, delta) {
                        return Rect.fromPoints(
                          bounds.topLeft + delta,
                          bounds.bottomRight,
                        );
                      },
                    ),
                  ),
                  // top right
                  /// Creates a `GroupPositioned` instance.
                  GroupPositioned(
                    top: 0,
                    right: 0,
                    width: resizeThickness * theme.scaling,
                    height: resizeThickness * theme.scaling,
                    child: _wrapResizer(
                      cursor: SystemMouseCursors.resizeUpRight,
                      adjustmentX: 1,
                      adjustmentY: -1,
                      onResize: (bounds, delta) {
                        return Rect.fromPoints(
                          bounds.topRight + delta,
                          bounds.bottomLeft,
                        );
                      },
                    ),
                  ),
                  // bottom left
                  /// Creates a `GroupPositioned` instance.
                  GroupPositioned(
                    bottom: 0,
                    left: 0,
                    width: resizeThickness * theme.scaling,
                    height: resizeThickness * theme.scaling,
                    child: _wrapResizer(
                      cursor: SystemMouseCursors.resizeDownLeft,
                      adjustmentX: -1,
                      adjustmentY: 1,
                      onResize: (bounds, delta) {
                        return Rect.fromPoints(
                          bounds.bottomLeft + delta,
                          bounds.topRight,
                        );
                      },
                    ),
                  ),
                  // bottom right
                  /// Creates a `GroupPositioned` instance.
                  GroupPositioned(
                    bottom: 0,
                    right: 0,
                    width: resizeThickness * theme.scaling,
                    height: resizeThickness * theme.scaling,
                    child: _wrapResizer(
                      cursor: SystemMouseCursors.resizeDownRight,
                      adjustmentX: 1,
                      adjustmentY: 1,
                      onResize: (bounds, delta) {
                        return Rect.fromPoints(
                          bounds.bottomRight + delta,
                          bounds.topLeft,
                        );
                      },
                    ),
                  ),
                  // top
                  /// Creates a `GroupPositioned` instance.
                  GroupPositioned(
                    top: 0,
                    left: resizeThickness * theme.scaling,
                    right: resizeThickness * theme.scaling,
                    height: resizeThickness * theme.scaling,
                    child: _wrapResizer(
                      cursor: SystemMouseCursors.resizeUpDown,
                      adjustmentX: 0,
                      adjustmentY: -1,
                      onResize: (bounds, delta) {
                        return Rect.fromPoints(
                          bounds.topLeft + Offset(0, delta.dy),
                          bounds.bottomRight,
                        );
                      },
                    ),
                  ),
                  // bottom
                  /// Creates a `GroupPositioned` instance.
                  GroupPositioned(
                    bottom: 0,
                    left: resizeThickness * theme.scaling,
                    right: resizeThickness * theme.scaling,
                    height: resizeThickness * theme.scaling,
                    child: _wrapResizer(
                      cursor: SystemMouseCursors.resizeUpDown,
                      adjustmentX: 0,
                      adjustmentY: 1,
                      onResize: (bounds, delta) {
                        return Rect.fromPoints(
                          bounds.bottomLeft + Offset(0, delta.dy),
                          bounds.topRight,
                        );
                      },
                    ),
                  ),
                  // left
                  /// Creates a `GroupPositioned` instance.
                  GroupPositioned(
                    top: resizeThickness * theme.scaling,
                    left: 0,
                    bottom: resizeThickness * theme.scaling,
                    width: resizeThickness * theme.scaling,
                    child: _wrapResizer(
                      cursor: SystemMouseCursors.resizeLeftRight,
                      adjustmentX: -1,
                      adjustmentY: 0,
                      onResize: (bounds, delta) {
                        return Rect.fromPoints(
                          bounds.topLeft + Offset(delta.dx, 0),
                          bounds.bottomRight,
                        );
                      },
                    ),
                  ),
                  // right
                  /// Creates a `GroupPositioned` instance.
                  GroupPositioned(
                    top: resizeThickness * theme.scaling,
                    right: 0,
                    bottom: resizeThickness * theme.scaling,
                    width: resizeThickness * theme.scaling,
                    child: _wrapResizer(
                      cursor: SystemMouseCursors.resizeLeftRight,
                      adjustmentX: 1,
                      adjustmentY: 0,
                      onResize: (bounds, delta) {
                        return Rect.fromPoints(
                          bounds.topRight + Offset(delta.dx, 0),
                          bounds.bottomLeft,
                        );
                      },
                    ),
                  ),
                ],
              ],
            ),
          );

          /// Stores `size` state/configuration for this implementation.
          final size = _viewport?.size ?? Size.zero;

          /// Stores `maximizedRect` state/configuration for this implementation.
          final maximizedRect = maximized;
          final targetRect = maximizedRect == null
              ? bounds
              : Rect.fromLTWH(
                  maximizedRect.left * size.width,
                  maximizedRect.top * size.height,
                  maximizedRect.width * size.width,
                  maximizedRect.height * size.height,
                );
          return AnimatedValueBuilder<Rect>(
            value: targetRect,
            duration: kDefaultDuration,
            curve: Curves.easeInOut,
            lerp: Rect.lerp,
            builder: (context, rect, child) {
              return GroupPositioned.fromRect(rect: rect, child: child!);
            },
            child: windowContainer,
          );
        },
      ),
    );
  }

  @override
  /// Stores `alwaysOnTop` state/configuration for this implementation.
  bool get alwaysOnTop => state.alwaysOnTop;

  @override
  /// Stores `bounds` state/configuration for this implementation.
  Rect get bounds => state.bounds;

  @override
  /// Stores `closable` state/configuration for this implementation.
  bool get closable => state.closable;

  @override
  /// Stores `draggable` state/configuration for this implementation.
  bool get draggable => state.draggable;

  @override
  /// Stores `enableSnapping` state/configuration for this implementation.
  bool get enableSnapping => state.enableSnapping;

  @override
  /// Stores `maximizable` state/configuration for this implementation.
  bool get maximizable => state.maximizable;

  @override
  /// Stores `maximized` state/configuration for this implementation.
  Rect? get maximized => state.maximized;

  @override
  /// Stores `minimizable` state/configuration for this implementation.
  bool get minimizable => state.minimizable;

  @override
  /// Stores `minimized` state/configuration for this implementation.
  bool get minimized => state.minimized;

  @override
  /// Stores `resizable` state/configuration for this implementation.
  bool get resizable => state.resizable;

  @override
  /// Stores `focused` state/configuration for this implementation.
  bool get focused => state.alwaysOnTop;

  @override
  /// Executes `alwaysOnTop` behavior for this component/composite.
  set alwaysOnTop(bool value) {
    if (value != state.alwaysOnTop) {
      controller.value = state.copyWith(alwaysOnTop: () => value);
    }
  }

  @override
  /// Executes `bounds` behavior for this component/composite.
  set bounds(Rect value) {
    if (value != state.bounds) {
      controller.value = state.copyWith(bounds: () => value);
    }
  }

  @override
  /// Executes `closable` behavior for this component/composite.
  set closable(bool value) {
    if (value != state.closable) {
      controller.value = state.copyWith(closable: () => value);
    }
  }

  @override
  /// Executes `close` behavior for this component/composite.
  void close() {
    _entry?.closed.value = true;
  }

  @override
  /// Executes `draggable` behavior for this component/composite.
  set draggable(bool value) {
    if (value != state.draggable) {
      controller.value = state.copyWith(draggable: () => value);
    }
  }

  @override
  /// Executes `enableSnapping` behavior for this component/composite.
  set enableSnapping(bool value) {
    if (value != state.enableSnapping) {
      controller.value = state.copyWith(enableSnapping: () => value);
    }
  }

  @override
  /// Executes `focused` behavior for this component/composite.
  set focused(bool value) {
    if (_entry == null) return;
    if (value) {
      _viewport?.navigator.focusWindow(_entry!);
    } else {
      _viewport?.navigator.unfocusWindow(_entry!);
    }
  }

  @override
  /// Executes `maximizable` behavior for this component/composite.
  set maximizable(bool value) {
    if (value != state.maximizable) {
      controller.value = state.copyWith(maximizable: () => value);
    }
  }

  @override
  /// Executes `maximized` behavior for this component/composite.
  set maximized(Rect? value) {
    if (value != state.maximized) {
      controller.value = state.withMaximized(value);
    }
  }

  @override
  /// Executes `minimizable` behavior for this component/composite.
  set minimizable(bool value) {
    if (value != state.minimizable) {
      controller.value = state.copyWith(minimizable: () => value);
    }
  }

  @override
  /// Executes `minimized` behavior for this component/composite.
  set minimized(bool value) {
    if (value != state.minimized) {
      controller.value = state.copyWith(minimized: () => value);
    }
  }

  @override
  /// Executes `resizable` behavior for this component/composite.
  set resizable(bool value) {
    if (value != state.resizable) {
      controller.value = state.copyWith(resizable: () => value);
    }
  }
}
