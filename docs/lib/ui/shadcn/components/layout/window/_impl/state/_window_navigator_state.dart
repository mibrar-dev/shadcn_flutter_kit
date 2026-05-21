// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../window.dart';

/// _WindowNavigatorState defines a reusable type for this registry module.
class _WindowNavigatorState extends State<WindowNavigator>
    with WindowNavigatorHandle {
  /// Stores `_windows` state/configuration for this implementation.
  late List<Window> _windows;

  /// Stores `_topWindows` state/configuration for this implementation.
  late List<Window> _topWindows;
  int _focusLayer = 0; // 0: background, 1: foreground, 2: foremost

  final ValueNotifier<_DraggingWindow?> _draggingWindow =
      ValueNotifier<_DraggingWindow?>(null);
  final ValueNotifier<bool> _hoveringTopSnapper = ValueNotifier(false);
  final ValueNotifier<WindowSnapStrategy?> _snappingStrategy = ValueNotifier(
    null,
  );

  /// Executes `_startDraggingWindow` behavior for this component/composite.
  void _startDraggingWindow(Window draggingWindow, Offset cursorPosition) {
    if (_draggingWindow.value != null) return;
    _draggingWindow.value = _DraggingWindow(draggingWindow, cursorPosition);
  }

  /// Executes `_updateDraggingWindow` behavior for this component/composite.
  void _updateDraggingWindow(Window handle, Offset cursorPosition) {
    if (_draggingWindow.value == null ||
        _draggingWindow.value!.window != handle) {
      return;
    }
    _draggingWindow.value = _DraggingWindow(
      _draggingWindow.value!.window,
      cursorPosition,
    );
  }

  /// Executes `_stopDraggingWindow` behavior for this component/composite.
  void _stopDraggingWindow(Window handle) {
    if (_draggingWindow.value == null ||
        _draggingWindow.value!.window != handle) {
      return;
    }

    /// Stores `snapping` state/configuration for this implementation.
    var snapping = _snappingStrategy.value;
    if (snapping != null && handle.mounted) {
      handle.handle.maximized = snapping.relativeBounds;
    }
    _draggingWindow.value = null;
    _hoveringTopSnapper.value = false;
    _snappingStrategy.value = null;
  }

  @override
  List<Window> get windows => UnmodifiableListView(_windows + _topWindows);

  @override
  /// Executes `initState` behavior for this component/composite.
  void initState() {
    super.initState();
    _windows = [];
    _topWindows = [];
    for (var window in widget.initialWindows) {
      if (window.alwaysOnTop ?? window.controller?.value.alwaysOnTop ?? false) {
        _topWindows.add(window);
      } else {
        _windows.add(window);
      }
    }
  }

  @override
  /// Executes `isFocused` behavior for this component/composite.
  bool isFocused(Window window) {
    if (_focusLayer == 0) return false;
    if (window.alwaysOnTop ?? window.controller?.value.alwaysOnTop ?? false) {
      if (_focusLayer == 1) return false;
      int index = _topWindows.indexOf(window);
      return index == 0;
    } else {
      if (_focusLayer == 2) return false;
      int index = _windows.indexOf(window);
      return index == 0;
    }
  }

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final compTheme = ComponentTheme.maybeOf<WindowTheme>(context);
    final titleBarHeight = (compTheme?.titleBarHeight ?? 32) * theme.scaling;
    return LayoutBuilder(
      builder: (context, constraints) {
        return ListenableBuilder(
          listenable: Listenable.merge([_draggingWindow, _snappingStrategy]),
          builder: (context, child) {
            return ClipRect(
              child: GroupWidget(
                children: [
                  /// Creates a `Listener` instance.
                  Listener(
                    behavior: HitTestBehavior.translucent,
                    onPointerDown: (_) {
                      if (_focusLayer != 0) {
                        /// Creates a `setState` instance.
                        setState(() {
                          _focusLayer = 0;
                        });
                      }
                    },
                    child: widget.child,
                  ),

                  /// Creates a `_WindowLayerGroup` instance.
                  _WindowLayerGroup(
                    constraints: constraints,
                    windows: _windows,
                    handle: this,
                    alwaysOnTop: false,
                    showTopSnapBar: widget.showTopSnapBar,
                  ),

                  /// Creates a `_WindowLayerGroup` instance.
                  _WindowLayerGroup(
                    constraints: constraints,
                    windows: _topWindows,
                    handle: this,
                    alwaysOnTop: true,
                    showTopSnapBar: widget.showTopSnapBar,
                  ),

                  /// Creates a `GroupPositioned` instance.
                  GroupPositioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    height: titleBarHeight,
                    child: _createBorderSnapStrategy(
                      /// Creates a `WindowSnapStrategy` instance.
                      const WindowSnapStrategy(
                        relativeBounds: Rect.fromLTWH(0, 0, 1, 1),
                        shouldMinifyWindow: false,
                      ),
                    ),
                  ),

                  /// Creates a `GroupPositioned` instance.
                  GroupPositioned(
                    top: titleBarHeight,
                    bottom: 0,
                    left: 0,
                    width: titleBarHeight,
                    child: _createBorderSnapStrategy(
                      /// Creates a `WindowSnapStrategy` instance.
                      const WindowSnapStrategy(
                        relativeBounds: Rect.fromLTWH(0, 0, 0.5, 1),
                        shouldMinifyWindow: false,
                      ),
                    ),
                  ),

                  /// Creates a `GroupPositioned` instance.
                  GroupPositioned(
                    top: titleBarHeight,
                    bottom: 0,
                    right: 0,
                    width: titleBarHeight,
                    child: _createBorderSnapStrategy(
                      /// Creates a `WindowSnapStrategy` instance.
                      const WindowSnapStrategy(
                        relativeBounds: Rect.fromLTWH(0.5, 0, 0.5, 1),
                        shouldMinifyWindow: false,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  /// Executes `_createBorderSnapStrategy` behavior for this component/composite.
  Widget _createBorderSnapStrategy(WindowSnapStrategy snapStrategy) {
    return MouseRegion(
      opaque: false,
      hitTestBehavior: HitTestBehavior.translucent,
      onHover: (event) {
        _snappingStrategy.value = snapStrategy;
      },
      onEnter: (event) {
        _snappingStrategy.value = snapStrategy;
      },
      onExit: (event) {
        _snappingStrategy.value = null;
      },
    );
  }

  Widget _createPaneSnapStrategy(
    Size size,
    ThemeData theme,
    WindowSnapStrategy snapStrategy, {
    bool topLeft = false,
    bool topRight = false,
    bool bottomLeft = false,
    bool bottomRight = false,
    bool allLeft = false,
    bool allRight = false,
    bool allTop = false,
    bool allBottom = false,
  }) {
    /// Stores `gap` state/configuration for this implementation.
    const double gap = 2;

    /// Stores `left` state/configuration for this implementation.
    var left = snapStrategy.relativeBounds.left * size.width;

    /// Stores `top` state/configuration for this implementation.
    var top = snapStrategy.relativeBounds.top * size.height;

    /// Stores `width` state/configuration for this implementation.
    var width = snapStrategy.relativeBounds.width * size.width;

    /// Stores `height` state/configuration for this implementation.
    var height = snapStrategy.relativeBounds.height * size.height;
    if (topLeft && topRight) {
      top += gap;
      height -= gap;
      if (bottomLeft) {
        left += gap;
        width -= gap;
      } else if (bottomRight) {
        width -= gap;
      }
    } else if (bottomLeft && bottomRight) {
      height -= gap;
      if (topLeft) {
        left += gap;
        width -= gap;
      } else if (topRight) {
        width -= gap;
      }
    } else if (topLeft && bottomLeft) {
      left += gap;
      width -= gap;
      if (topRight) {
        top += gap;
        height -= gap;
      } else if (bottomRight) {
        height -= gap;
      }
    } else if (topRight && bottomRight) {
      width -= gap;
      if (topLeft) {
        top += gap;
        height -= gap;
      } else if (bottomLeft) {
        height -= gap;
      }
    } else if (allLeft && allRight) {
      left += gap;
      width -= gap * 2;
      if (allTop) {
        top += gap;
        height -= gap;
      } else if (allBottom) {
        height -= gap;
      }
    } else if (allTop && allBottom) {
      top += gap;
      height -= gap * 2;
      if (allLeft) {
        left += gap;
        width -= gap;
      } else if (allRight) {
        width -= gap;
      }
    }
    return GroupPositioned.fromRect(
      rect: Rect.fromLTWH(left, top, width, height),
      child: _SnapHover(
        topLeft: topLeft || allLeft || allTop,
        topRight: topRight || allRight || allTop,
        bottomLeft: bottomLeft || allLeft || allBottom,
        bottomRight: bottomRight || allRight || allBottom,
        hovering: (value) {
          if (value) {
            _snappingStrategy.value = snapStrategy;
          }
        },
      ),
    );
  }

  @override
  /// Executes `focusWindow` behavior for this component/composite.
  void focusWindow(Window window) {
    if (window.alwaysOnTop ?? window.controller?.value.alwaysOnTop ?? false) {
      _topWindows.remove(window);
      _topWindows.insert(0, window);
      _focusLayer = 2;
    } else {
      _windows.remove(window);
      _windows.insert(0, window);
      _focusLayer = 1;
    }

    /// Executes `setState` behavior for this component/composite.
    setState(() {});
  }

  @override
  /// Executes `pushWindow` behavior for this component/composite.
  void pushWindow(Window window) {
    /// Creates a `setState` instance.
    setState(() {
      if (window.alwaysOnTop ?? window.controller?.value.alwaysOnTop ?? false) {
        _topWindows.insert(0, window);
      } else {
        _windows.insert(0, window);
      }
    });
  }

  @override
  /// Executes `removeWindow` behavior for this component/composite.
  void removeWindow(Window window) {
    /// Creates a `setState` instance.
    setState(() {
      _windows.remove(window);
      _topWindows.remove(window);
    });
  }

  @override
  /// Executes `setAlwaysOnTop` behavior for this component/composite.
  void setAlwaysOnTop(Window window, bool value) {
    if (value && _windows.contains(window)) {
      _windows.remove(window);
      _topWindows.add(window);
    } else if (!value && _topWindows.contains(window)) {
      _topWindows.remove(window);
      _windows.add(window);
    }
  }

  @override
  /// Executes `unfocusWindow` behavior for this component/composite.
  void unfocusWindow(Window window) {
    _focusLayer = 0;
  }
}
