// The `window` component: [Window] (title bar, resize, maximize, close),
// [WindowNavigator] (z-order, focus, snap presets) and the re-exported
// [WindowActions]. Ported from `layout/window/**` (old tree): Material
// `Icons`/imports are gone (Lucide), `data_widget`/`gap` became foundation
// `Data`/`Gap`, and `Styleable<WindowTheme>` collapsed into `WindowTheme` + the
// resolver. The machinery lives in `primitives/window_manager.dart`,
// `window_host.dart` and `window_snap.dart` (file budget).
//
// Old bugs fixed, not ported: dual `maximized` update paths (now one),
// detached `WindowActions` throwing on a null handle, ghost navigator entries
// when close raced the exit animation, and a 0x0 viewport on first layout.

import 'dart:ui' show lerpDouble;

import 'package:flutter/widgets.dart';

import '../../foundation/constants.dart';
import '../../foundation/data.dart';
import '../../foundation/gap.dart';
import '../../primitives/animated_value_builder.dart';
import '../../primitives/text/text_extension.dart';
import '../../primitives/window_host.dart';
import '../../primitives/window_manager.dart';
import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';
import '../card/card.dart';
import '../outlined_container/outlined_container.dart';
import '../patch/patch.dart';
import 'window_style.dart';

export 'window_style.dart';
export '../../primitives/window_manager.dart';
export '../../primitives/window_host.dart';
export '../../primitives/window_snap.dart'
    show WindowSnapBar, windowMaximizeSnapStrategy, windowSnapPresets;

/// A draggable, resizable window frame driven by a [WindowController].
///
/// Put one or more in a [WindowNavigator]:
///
/// ```dart
/// WindowNavigator(initialWindows: <Window>[
///   Window(controller: controller, title: const Text('Notes')),
/// ]);
/// ```
class Window extends StatefulWidget implements ManagedWindow {
  /// Creates a window.
  const Window({
    super.key,
    required this.controller,
    this.title,
    this.actions = const WindowActions(),
    this.content,
    this.theme,
  });

  /// The window's state controller.
  final WindowController controller;

  final Widget? title;

  /// Title bar action area; defaults to [WindowActions].
  final Widget? actions;

  /// Window body.
  final Widget? content;

  final WindowTheme? theme;

  @override
  bool get alwaysOnTop => controller.alwaysOnTop;

  @override
  State<Window> createState() => _WindowState();
}

class _WindowState extends State<Window> implements WindowHandle {
  final ValueNotifier<bool> _closed = ValueNotifier<bool>(false);
  WindowViewport? _viewport;

  WindowState get _state => widget.controller.value;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_syncAlwaysOnTop);
  }

  @override
  void didUpdateWidget(covariant Window oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller.removeListener(_syncAlwaysOnTop);
      widget.controller.addListener(_syncAlwaysOnTop);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _viewport = Data.maybeOf<WindowViewport>(context);
    _syncAlwaysOnTop();
  }

  @override
  void dispose() {
    widget.controller.removeListener(_syncAlwaysOnTop);
    _closed.dispose();
    super.dispose();
  }

  void _syncAlwaysOnTop() {
    _viewport?.manager.setAlwaysOnTop(widget, widget.controller.alwaysOnTop);
  }

  @override
  Rect get bounds => _state.bounds;
  @override
  set bounds(Rect value) => widget.controller.bounds = value;

  @override
  Rect? get maximized => _state.maximized;
  @override
  set maximized(Rect? value) => widget.controller.maximized = value;

  @override
  bool get minimized => _state.minimized;
  @override
  set minimized(bool value) => widget.controller.minimized = value;

  @override
  bool get closable => _state.closable;
  @override
  bool get resizable => _state.resizable;
  @override
  bool get draggable => _state.draggable;
  @override
  bool get maximizable => _state.maximizable;
  @override
  bool get minimizable => _state.minimizable;

  @override
  bool get focused => _viewport?.focused ?? false;

  @override
  void close() => _closed.value = true;

  Widget _titleBar(
    ShadcnThemeData ambient,
    WindowTheme style,
    double titleBarHeight,
  ) {
    Widget title = DefaultTextStyle.merge(
      style: TextStyle(
        color:
            style.titleColor?.resolve(ambient.colors) ??
            ambient.colors.foreground,
      ),
      child: widget.title ?? const SizedBox.shrink(),
    );
    if (!(_viewport?.focused ?? true)) {
      title = title.muted();
    }
    return ClickDetector(
      behavior: HitTestBehavior.translucent,
      onClick: (ClickDetails details) {
        if (details.clickCount >= 2 && maximizable) {
          maximized = maximized == null
              ? const Rect.fromLTWH(0, 0, 1, 1)
              : null;
        }
      },
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onPanStart: _onDragStart,
        onPanUpdate: _onDragUpdate,
        onPanEnd: (_) => _onDragEnd(),
        onPanCancel: _onDragEnd,
        child: SizedBox(
          height: titleBarHeight,
          child: Padding(
            padding: style.titleBarPadding ?? EdgeInsets.zero,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: title,
                  ),
                ),
                Gap(ambient.spacing.xs),
                if (widget.actions != null) widget.actions!,
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onDragStart(DragStartDetails details) {
    final WindowViewport? viewport = _viewport;
    if (!draggable || viewport == null) {
      return;
    }
    final Rect? max = maximized;
    if (max != null) {
      final Rect maxPixels = relativeRect(max, viewport.size);
      final Rect restored = bounds;
      maximized = null;
      bounds = Rect.fromLTWH(
        maxPixels.left + details.localPosition.dx - restored.width / 2,
        maxPixels.top + details.localPosition.dy,
        restored.width,
        restored.height,
      );
    }
    viewport.manager.drag.start(widget);
  }

  void _onDragUpdate(DragUpdateDetails details) {
    if (!draggable) {
      return;
    }
    bounds = bounds.translate(details.delta.dx, details.delta.dy);
    _viewport?.manager.drag.update();
  }

  void _onDragEnd() {
    final WindowSnapStrategy? strategy = _viewport?.manager.drag.stop();
    if (strategy != null) {
      maximized = strategy.relativeBounds;
    }
  }

  Iterable<Widget> _resizeHandles(double thickness) sync* {
    for (final WindowResizeEdge edge in WindowResizeEdge.values) {
      final bool horizontal = edge.affectsLeft || edge.affectsRight;
      final bool vertical = edge.affectsTop || edge.affectsBottom;
      yield Positioned(
        top: edge.affectsTop ? 0 : (vertical ? null : thickness),
        bottom: edge.affectsBottom ? 0 : (vertical ? null : thickness),
        left: edge.affectsLeft ? 0 : (horizontal ? null : thickness),
        right: edge.affectsRight ? 0 : (horizontal ? null : thickness),
        width: horizontal ? thickness : null,
        height: vertical ? thickness : null,
        child: MouseRegion(
          cursor: edge.cursor,
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onPanUpdate: (DragUpdateDetails details) {
              if (resizable && _state.maximized == null) {
                bounds = resizeWindow(_state, edge, details.delta);
              }
            },
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData ambient = ShadcnTheme.of(context);
    final WindowTheme style = resolveComponentStyle<WindowTheme, WindowTheme>(
      context,
      widget: widget.theme,
      select: (t) => t,
      defaults: windowDefaults,
    );
    final double titleBarHeight =
        (style.titleBarHeight ?? 32) * ambient.scaling;
    final double thickness = (style.resizeThickness ?? 8) * ambient.scaling;

    return Data<WindowHandle>.inherit(
      data: this,
      child: ListenableBuilder(
        listenable: Listenable.merge(<Listenable>[widget.controller, _closed]),
        builder: (BuildContext context, Widget? child) {
          Widget frame = Card(
            clipBehavior: Clip.antiAlias,
            padding: EdgeInsets.zero,
            borderRadius: _state.maximized != null
                ? BorderRadius.zero
                : ambient.borderRadiusMd,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                if (widget.title != null || widget.actions != null)
                  _titleBar(ambient, style, titleBarHeight),
                if (widget.content != null) Expanded(child: widget.content!),
              ],
            ),
          );
          frame = AnimatedValueBuilder<double>(
            initialValue: 0,
            value: _closed.value ? 0 : 1,
            duration: kDefaultDuration,
            onEnd: (double? value) {
              if (_closed.value) {
                _viewport?.manager.remove(widget);
              }
            },
            builder: (context, value, child) => Transform.scale(
              scale: _closed.value ? lerpDouble(0.8, 1, value)! : 1,
              child: Opacity(opacity: value, child: child),
            ),
            child: frame,
          );
          frame = AnimatedScale(
            scale: (_viewport?.minify ?? false) ? 0.65 : 1,
            duration: kDefaultDuration,
            curve: Curves.easeInOut,
            child: frame,
          );
          final Widget container = Listener(
            behavior: HitTestBehavior.translucent,
            onPointerDown: (_) => _viewport?.manager.focus(widget),
            child: IgnorePointer(
              ignoring: _viewport?.ignorePointer ?? false,
              child: Stack(
                clipBehavior: Clip.none,
                children: <Widget>[
                  frame,
                  if (resizable && _state.maximized == null)
                    ..._resizeHandles(thickness),
                ],
              ),
            ),
          );
          final WindowViewport? viewport = _viewport;
          if (viewport == null) {
            return container;
          }
          final Rect? max = _state.maximized;
          final Rect target = max == null
              ? _state.bounds
              : relativeRect(max, viewport.size);
          return AnimatedValueBuilder<Rect>(
            value: target,
            duration: kDefaultDuration,
            curve: Curves.easeInOut,
            lerp: Rect.lerp,
            builder: (context, rect, child) =>
                Positioned.fromRect(rect: rect, child: child!),
            child: container,
          );
        },
      ),
    );
  }
}

/// Hosts a set of [Window]s: z-order, focus and edge snapping.
class WindowNavigator extends StatelessWidget {
  /// Creates a window navigator.
  const WindowNavigator({
    super.key,
    required this.initialWindows,
    this.child,
    this.theme,
    this.showTopSnapBar = true,
  });

  /// Windows to show on first build.
  final List<Window> initialWindows;

  /// Background content behind every window.
  final Widget? child;

  final WindowTheme? theme;

  /// Whether the top preset snap bar is shown while dragging.
  final bool showTopSnapBar;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData ambient = ShadcnTheme.of(context);
    final WindowTheme style = resolveComponentStyle<WindowTheme, WindowTheme>(
      context,
      widget: theme,
      select: (t) => t,
      defaults: windowDefaults,
    );
    return WindowHost(
      initialWindows: initialWindows,
      background: child,
      showTopSnapBar: showTopSnapBar,
      titleBarHeight: (style.titleBarHeight ?? 32) * ambient.scaling,
      snapOverlayBuilder: (BuildContext context) => OutlinedContainer(
        backgroundColor: style.snapOverlayColor,
        surfaceOpacity: style.snapOverlayOpacity,
        surfaceBlur: style.snapOverlayBlur,
        borderRadius: ambient.borderRadiusMd,
        child: const SizedBox.expand(),
      ),
    );
  }
}
