// The window host (z-order, focus, drag previews, edge snapping), the resize
// engine and [WindowActions] — moved down from `components/window/window.dart`
// (P4-B23, file budget). Chrome-agnostic: the component supplies the snap
// preview through [WindowHost.snapOverlayBuilder].

import 'package:flutter/widgets.dart';

import '../foundation/data.dart';
import '../foundation/icons/lucide_icons.dart';
import '../theme/theme.dart';
import '../theme/density.dart';
import 'clickable.dart';
import 'window_manager.dart';
import 'window_snap.dart';

/// A window that a [WindowHost] can manage: its identity and layer.
abstract class ManagedWindow extends Widget {
  const ManagedWindow({super.key});

  /// Whether the window belongs to the always-on-top layer.
  bool get alwaysOnTop;
}

/// Hosts [ManagedWindow]s; each positions itself from [WindowViewport].
class WindowHost extends StatefulWidget {
  const WindowHost({
    super.key,
    required this.initialWindows,
    this.background,
    this.titleBarHeight = 32,
    this.showTopSnapBar = true,
    this.snapOverlayBuilder,
  });

  final List<ManagedWindow> initialWindows;

  final Widget? background;

  final double titleBarHeight;

  /// Whether the top preset bar is shown while dragging.
  final bool showTopSnapBar;

  final WidgetBuilder? snapOverlayBuilder;

  @override
  State<WindowHost> createState() => _WindowHostState();
}

class _WindowHostState extends State<WindowHost> implements WindowManager {
  late List<ManagedWindow> _windows;
  late List<ManagedWindow> _topWindows;
  int _focusLayer = 0;

  @override
  final WindowDragController drag = WindowDragController();

  @override
  void initState() {
    super.initState();
    _windows = <ManagedWindow>[];
    _topWindows = <ManagedWindow>[];
    for (final ManagedWindow window in widget.initialWindows) {
      (_isTop(window) ? _topWindows : _windows).add(window);
    }
  }

  @override
  void dispose() {
    drag.dispose();
    super.dispose();
  }

  bool _isTop(ManagedWindow window) => window.alwaysOnTop;

  @override
  List<Object> get windows => <Object>[..._windows, ..._topWindows];

  @override
  void push(Object window) {
    if (window is! ManagedWindow) {
      return;
    }
    setState(() => (_isTop(window) ? _topWindows : _windows).insert(0, window));
  }

  @override
  void focus(Object window) {
    if (window is! ManagedWindow) {
      return;
    }
    final List<ManagedWindow> layer = _isTop(window) ? _topWindows : _windows;
    _focusLayer = _isTop(window) ? 2 : 1;
    if (layer.isEmpty || layer.first == window) {
      setState(() {});
      return;
    }
    setState(() {
      layer
        ..remove(window)
        ..insert(0, window);
    });
  }

  @override
  void unfocus(Object window) {
    if (_focusLayer != 0) setState(() => _focusLayer = 0);
  }

  @override
  void remove(Object window) {
    if (window is! ManagedWindow || !mounted) {
      return;
    }
    setState(() {
      _windows.remove(window);
      _topWindows.remove(window);
    });
  }

  @override
  void setAlwaysOnTop(Object window, bool value) {
    if (window is! ManagedWindow || !mounted) {
      return;
    }
    // Mirror push/focus (P7-Q2): the destination layer's front is index 0,
    // and the move must schedule a rebuild (this runs from a controller
    // listener, and previously mutated the lists silently).
    if (value && _windows.contains(window) && !_topWindows.contains(window)) {
      setState(() {
        _windows.remove(window);
        _topWindows.insert(0, window);
      });
    } else if (!value &&
        _topWindows.contains(window) &&
        !_windows.contains(window)) {
      setState(() {
        _topWindows.remove(window);
        _windows.insert(0, window);
      });
    }
  }

  @override
  bool isFocused(Object window) {
    if (_focusLayer == 0 || window is! ManagedWindow) {
      return false;
    }
    final bool top = _isTop(window);
    if ((top && _focusLayer == 1) || (!top && _focusLayer == 2)) {
      return false;
    }
    final List<ManagedWindow> layer = top ? _topWindows : _windows;
    return layer.isNotEmpty && layer.first == window;
  }

  List<Widget> _layer(
    List<ManagedWindow> windows,
    bool alwaysOnTop,
    Size size,
  ) {
    final Object? dragged = drag.window;
    final List<ManagedWindow> ordered = <ManagedWindow>[
      for (final ManagedWindow window in windows)
        if (window != dragged) window,
      if (dragged is ManagedWindow && windows.contains(dragged)) dragged,
    ];
    return <Widget>[
      for (int i = ordered.length - 1; i >= 0; i--)
        KeyedSubtree(
          key: ObjectKey(ordered[i]),
          child: Data<WindowViewport>.inherit(
            data: WindowViewport(
              size: size,
              manager: this,
              focused: i == 0,
              alwaysOnTop: alwaysOnTop,
              minify:
                  ordered[i] == dragged &&
                  (drag.strategy?.shouldMinifyWindow ?? false),
              ignorePointer: ordered[i] == dragged,
            ),
            child: ordered[i],
          ),
        ),
    ];
  }

  void _hoverSnap(WindowSnapStrategy strategy) {
    if (drag.window != null) {
      drag.hover(strategy);
    }
  }

  Iterable<Widget> _snapRegions(Size size) sync* {
    Widget region(
      WindowSnapStrategy strategy, {
      double? top,
      double? left,
      double? right,
      double? bottom,
      double? width,
      double? height,
    }) {
      return Positioned(
        top: top,
        left: left,
        right: right,
        bottom: bottom,
        width: width,
        height: height,
        child: MouseRegion(
          opaque: false,
          hitTestBehavior: HitTestBehavior.translucent,
          onEnter: (_) => _hoverSnap(strategy),
          onHover: (_) => _hoverSnap(strategy),
          onExit: (_) {
            if (drag.strategy == strategy) {
              drag.hover(null);
            }
          },
          child: const SizedBox.expand(),
        ),
      );
    }

    const WindowSnapStrategy left = WindowSnapStrategy(
      relativeBounds: Rect.fromLTWH(0, 0, 0.5, 1),
      shouldMinifyWindow: false,
    );
    const WindowSnapStrategy right = WindowSnapStrategy(
      relativeBounds: Rect.fromLTWH(0.5, 0, 0.5, 1),
      shouldMinifyWindow: false,
    );
    final double bar = widget.titleBarHeight;
    yield region(left, top: bar, left: 0, bottom: 0, width: bar);
    yield region(right, top: bar, right: 0, bottom: 0, width: bar);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final Size size = constraints.biggest;
        return ListenableBuilder(
          listenable: drag,
          builder: (BuildContext context, Widget? child) {
            final WindowSnapStrategy? strategy = drag.window == null
                ? null
                : drag.strategy;
            return ClipRect(
              child: Stack(
                clipBehavior: Clip.none,
                children: <Widget>[
                  Positioned.fill(
                    child: Listener(
                      behavior: HitTestBehavior.translucent,
                      onPointerDown: (_) {
                        if (_focusLayer != 0) {
                          setState(() => _focusLayer = 0);
                        }
                      },
                      child: widget.background ?? const SizedBox.expand(),
                    ),
                  ),
                  ..._layer(_windows, false, size),
                  ..._layer(_topWindows, true, size),
                  ..._snapRegions(size),
                  if (strategy != null && widget.snapOverlayBuilder != null)
                    Positioned.fromRect(
                      rect: relativeRect(strategy.relativeBounds, size),
                      child: IgnorePointer(
                        child: widget.snapOverlayBuilder!(context),
                      ),
                    ),
                  if (widget.showTopSnapBar)
                    WindowSnapBar(
                      drag: drag,
                      titleBarHeight: widget.titleBarHeight,
                      viewportSize: size,
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

/// Default minimize / maximize / close buttons for a window title bar.
class WindowActions extends StatelessWidget {
  /// Creates the default window actions.
  const WindowActions({super.key});

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData ambient = ShadcnTheme.of(context);
    final WindowHandle? handle = Data.maybeOf<WindowHandle>(context);
    final WindowViewport? viewport = Data.maybeOf<WindowViewport>(context);
    Widget action(IconData icon, VoidCallback? onPressed) {
      return Clickable(
        enabled: onPressed != null,
        onPressed: onPressed,
        focusOutline: false,
        padding: WidgetStatePropertyAll<EdgeInsetsGeometry>(
          resolveEdgeInsets(
            EdgeInsetsDensity.pxAll(6),
            ambient.density.baseContentPadding * ambient.scaling,
          ),
        ),
        decoration: WidgetStateProperty.resolveWith(
          (Set<WidgetState> states) => BoxDecoration(
            color: states.contains(WidgetState.hovered)
                ? ambient.colors.muted
                : null,
            borderRadius: ambient.borderRadiusSm,
          ),
        ),
        child: Icon(icon, size: 16, color: ambient.colors.foreground),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (handle?.minimizable ?? true)
          action(
            LucideIcons.minus,
            handle == null ? null : () => handle.minimized = !handle.minimized,
          ),
        if (handle?.maximizable ?? true)
          action(
            handle?.maximized == null
                ? LucideIcons.maximize
                : LucideIcons.minimize2,
            handle == null
                ? null
                : () {
                    final Rect? snap =
                        viewport?.manager.drag.strategy?.relativeBounds;
                    handle.maximized = handle.maximized == null
                        ? (snap ?? const Rect.fromLTWH(0, 0, 1, 1))
                        : null;
                  },
          ),
        if (handle?.closable ?? true) action(LucideIcons.x, handle?.close),
      ],
    );
  }
}

Rect relativeRect(Rect relative, Size size) {
  return Rect.fromLTWH(
    relative.left * size.width,
    relative.top * size.height,
    relative.width * size.width,
    relative.height * size.height,
  );
}

/// Which edges a window resize handle moves.
enum WindowResizeEdge {
  topLeft(SystemMouseCursors.resizeUpLeft),
  top(SystemMouseCursors.resizeUpDown),
  topRight(SystemMouseCursors.resizeUpRight),
  right(SystemMouseCursors.resizeLeftRight),
  bottomRight(SystemMouseCursors.resizeDownRight),
  bottom(SystemMouseCursors.resizeUpDown),
  bottomLeft(SystemMouseCursors.resizeDownLeft),
  left(SystemMouseCursors.resizeLeftRight);

  const WindowResizeEdge(this.cursor);

  final MouseCursor cursor;

  /// Whether the left edge moves.
  bool get affectsLeft => this == topLeft || this == bottomLeft || this == left;

  /// Whether the right edge moves.
  bool get affectsRight =>
      this == topRight || this == bottomRight || this == right;

  /// Whether the top edge moves.
  bool get affectsTop => this == topLeft || this == topRight || this == top;

  /// Whether the bottom edge moves.
  bool get affectsBottom =>
      this == bottomLeft || this == bottomRight || this == bottom;
}

/// Applies a resize [delta] to [edge], clamped to the state's constraints.
Rect resizeWindow(WindowState state, WindowResizeEdge edge, Offset delta) {
  final Rect b = state.bounds;
  final BoxConstraints c = state.constraints;
  double l = b.left + (edge.affectsLeft ? delta.dx : 0);
  double t = b.top + (edge.affectsTop ? delta.dy : 0);
  double r = b.right + (edge.affectsRight ? delta.dx : 0);
  double bo = b.bottom + (edge.affectsBottom ? delta.dy : 0);
  final double w = r - l;
  final double h = bo - t;
  if (w < c.minWidth) {
    edge.affectsLeft ? l = r - c.minWidth : r = l + c.minWidth;
  } else if (w > c.maxWidth) {
    edge.affectsLeft ? l = r - c.maxWidth : r = l + c.maxWidth;
  }
  if (h < c.minHeight) {
    edge.affectsTop ? t = bo - c.minHeight : bo = t + c.minHeight;
  } else if (h > c.maxHeight) {
    edge.affectsTop ? t = bo - c.maxHeight : bo = t + c.maxHeight;
  }
  return Rect.fromLTRB(l, t, r, bo);
}
