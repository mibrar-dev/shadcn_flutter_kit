// The `swiper` component: a swipe-to-open wrapper that reveals a drawer or
// sheet panel when the user drags its child towards the panel's edge.
//
// The panel is in-tree so the drag can scrub it: a `Navigator` route cancels
// active pointers when pushed, so a pushed route cannot follow a gesture. The
// panel uses the shared `DrawerPanelSurface` chrome and settles on release by
// position + fling velocity.

import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../primitives/drawer_route/drawer_panel_surface.dart';
import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';
import '../drawer/drawer.dart';
import 'swiper_style.dart';

export '../drawer/drawer.dart' show OverlayPosition;
export 'swiper_style.dart';

/// Velocity (logical px/s) in the reveal direction that opens on release even
/// when the drag distance is short.
const double kSwiperOpenVelocity = 300;

/// Fallback barrier colour (black at 50%).
const ThemedColor kSwiperFallbackBarrier = ThemedColor.value(Color(0x80000000));

/// Programmatic control of a [Swiper]'s panel: [open] / [close] animate it and
/// [isOpen] / [progress] report its state.
class SwiperController extends ChangeNotifier {
  _SwiperState? _state;

  /// Whether this controller is attached to a mounted [Swiper].
  bool get isAttached => _state != null;

  /// Whether the panel is currently open (or opening).
  bool get isOpen => _state?._isOpen ?? false;

  /// Current open progress, 0 (closed) to 1 (fully open).
  double get progress => _state?._progressValue ?? 0;

  /// Opens the panel with its transition.
  void open() => _state?._openAnimated();

  /// Closes the panel with its transition.
  void close() => _state?._closeAnimated();

  void _attach(_SwiperState state) {
    _state = state;
    notifyListeners();
  }

  void _detach(_SwiperState state) {
    if (identical(_state, state)) {
      _state = null;
    }
  }

  void _notify() => notifyListeners();
}

/// Wraps [child] and reveals a [SwiperVariant.drawer] or [SwiperVariant.sheet]
/// panel when the user swipes towards the panel's edge. The panel is painted
/// in-tree so the gesture can scrub it. Provide a non-swipe trigger for
/// keyboard and assistive-technology users.
class Swiper extends StatefulWidget {
  /// Creates a swiper.
  const Swiper({
    super.key,
    required this.position,
    required this.builder,
    required this.child,
    this.variant = SwiperVariant.drawer,
    this.enabled = true,
    this.controller,
    this.theme,
  });

  /// Edge the panel slides in from; `start`/`end` follow the text direction.
  final OverlayPosition position;

  /// Builds the panel content.
  final WidgetBuilder builder;

  /// The widget that responds to the swipe gesture.
  final Widget child;

  /// Which panel to reveal.
  final SwiperVariant variant;

  /// Whether the swipe gesture is active.
  final bool enabled;

  /// Optional programmatic control; the swiper never disposes it.
  final SwiperController? controller;

  /// Widget-leg theme override; other legs resolve from the tree and the app.
  final SwiperTheme? theme;

  @override
  State<Swiper> createState() => _SwiperState();
}

class _SwiperState extends State<Swiper> with SingleTickerProviderStateMixin {
  late final AnimationController _progress;
  final VelocityTracker _tracker = VelocityTracker.withKind(
    PointerDeviceKind.touch,
  );
  Offset? _pointerStart;
  bool _dragging = false;

  /// Route extent captured by the [LayoutBuilder] in `build`.
  double _routeExtent = 0;

  bool get _isOpen => _progress.value > 0;
  double get _progressValue => _progress.value;

  @override
  void initState() {
    super.initState();
    _progress = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    widget.controller?._attach(this);
  }

  @override
  void didUpdateWidget(covariant Swiper oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?._detach(this);
      widget.controller?._attach(this);
    }
  }

  @override
  void dispose() {
    widget.controller?._detach(this);
    _progress.dispose();
    super.dispose();
  }

  /// The edge after resolving `start`/`end` against the text direction.
  OverlayPosition get _resolvedPosition =>
      widget.position.resolve(Directionality.of(context));

  /// Whether the panel slides along the vertical axis.
  bool get _isVertical {
    final OverlayPosition resolved = _resolvedPosition;
    return resolved == OverlayPosition.top ||
        resolved == OverlayPosition.bottom;
  }

  /// Sign that turns a primary drag delta into "reveal" distance.
  double get _revealSign {
    final OverlayPosition resolved = _resolvedPosition;
    return resolved == OverlayPosition.top || resolved == OverlayPosition.left
        ? 1
        : -1;
  }

  SwiperTheme _resolveStyle() {
    return resolveComponentStyle<SwiperTheme, SwiperTheme>(
      context,
      widget: widget.theme,
      select: (SwiperTheme theme) => theme,
      defaults: swiperDefaults(widget.variant),
    );
  }

  DrawerTheme _resolveDrawerStyle() {
    return resolveComponentStyle<DrawerTheme, DrawerTheme>(
      context,
      select: (DrawerTheme theme) => theme,
      defaults: drawerDefaults,
    );
  }

  double _panelExtent(SwiperTheme style, double routeExtent) {
    if (style.expands ?? false) {
      return routeExtent;
    }
    final double maxSize = style.maxSize ?? 320;
    return math.min(maxSize, routeExtent);
  }

  void _onDown(PointerDownEvent event) {
    _pointerStart = event.position;
    _dragging = false;
    _tracker.addPosition(event.timeStamp, event.position);
  }

  void _onMove(PointerMoveEvent event) {
    if (!widget.enabled || _pointerStart == null) {
      return;
    }
    _tracker.addPosition(event.timeStamp, event.position);
    final Offset total = event.position - _pointerStart!;
    final double axis = _isVertical ? total.dy : total.dx;
    final double cross = _isVertical ? total.dx : total.dy;
    if (!_dragging) {
      if (axis.abs() < kTouchSlop || axis.abs() <= cross.abs()) {
        return;
      }
      _dragging = true;
    }
    final double extent = _panelExtent(_resolveStyle(), _routeExtent);
    if (extent <= 0) {
      return;
    }
    final double delta =
        _revealSign * (_isVertical ? event.delta.dy : event.delta.dx);
    _progress.value = (_progress.value + delta / extent).clamp(0.0, 1.0);
  }

  void _onUp(PointerUpEvent event) {
    _pointerStart = null;
    if (!_dragging) {
      return;
    }
    _dragging = false;
    _settleFromGesture();
  }

  void _onCancel(PointerCancelEvent event) {
    _pointerStart = null;
    if (!_dragging) {
      return;
    }
    _dragging = false;
    _settleFromGesture();
  }

  void _settleFromGesture() {
    final SwiperTheme style = _resolveStyle();
    final Offset velocity = _tracker.getVelocity().pixelsPerSecond;
    final double axisVelocity =
        _revealSign * (_isVertical ? velocity.dy : velocity.dx);
    final double threshold = style.threshold ?? 0.5;
    final bool open =
        _progress.value >= threshold || axisVelocity >= kSwiperOpenVelocity;
    _settle(open: open);
  }

  /// Settles the panel open or closed; reduced motion jumps to the end.
  void _settle({required bool open}) {
    final bool reduced =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    if (reduced) {
      _progress.value = open ? 1 : 0;
      if (mounted) {
        setState(() {});
      }
      widget.controller?._notify();
      return;
    }
    final Future<void> done = open ? _progress.forward() : _progress.reverse();
    done.whenComplete(() {
      if (mounted) {
        widget.controller?._notify();
      }
    });
  }

  void _openAnimated() {
    if (_progress.value >= 1) {
      return;
    }
    _settle(open: true);
  }

  void _closeAnimated() {
    if (_progress.value <= 0) {
      return;
    }
    _settle(open: false);
  }

  @override
  Widget build(BuildContext context) {
    final SwiperTheme style = _resolveStyle();
    final OverlayPosition position = _resolvedPosition;
    final bool vertical =
        position == OverlayPosition.top || position == OverlayPosition.bottom;
    return Listener(
      behavior: style.behavior ?? HitTestBehavior.translucent,
      onPointerDown: _onDown,
      onPointerMove: _onMove,
      onPointerUp: _onUp,
      onPointerCancel: _onCancel,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final double routeExtent = vertical
              ? constraints.maxHeight
              : constraints.maxWidth;
          _routeExtent = routeExtent.isFinite ? routeExtent : 0;
          return AnimatedBuilder(
            animation: _progress,
            child: widget.child,
            builder: (BuildContext context, Widget? child) {
              final double t = _progress.value;
              if (t <= 0) {
                return child ?? const SizedBox.shrink();
              }
              return Stack(
                fit: StackFit.passthrough,
                children: <Widget>[
                  ?child,
                  _buildOverlay(
                    context,
                    style,
                    position,
                    vertical,
                    _routeExtent,
                    t,
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildOverlay(
    BuildContext context,
    SwiperTheme style,
    OverlayPosition position,
    bool vertical,
    double routeExtent,
    double t,
  ) {
    final ShadcnThemeData ambient = ShadcnTheme.of(context);
    final double extent = _panelExtent(style, routeExtent);
    final bool expands = style.expands ?? false;
    final Offset slide = vertical
        ? Offset(0, position.slideOffset.dy * extent * (1 - t))
        : Offset(position.slideOffset.dx * extent * (1 - t), 0);
    final Color barrier = (style.barrierColor ?? kSwiperFallbackBarrier)
        .resolve(ambient.colors);
    final bool dismissible = style.barrierDismissible ?? true;

    Widget panel = DrawerPanelSurface(
      position: position,
      theme: _resolveDrawerStyle(),
      showDragHandle: style.showDragHandle ?? true,
      borderRadius: style.borderRadius,
      child: Builder(builder: widget.builder),
    );
    panel = SizedBox(
      width: vertical ? double.infinity : (expands ? double.infinity : extent),
      height: vertical ? (expands ? double.infinity : extent) : double.infinity,
      child: panel,
    );
    panel = Align(
      alignment: position.alignment,
      child: Transform.translate(offset: slide, child: panel),
    );
    if (style.useSafeArea ?? true) {
      panel = SafeArea(
        top: position != OverlayPosition.top,
        bottom: position != OverlayPosition.bottom,
        left: position != OverlayPosition.left,
        right: position != OverlayPosition.right,
        child: panel,
      );
    }
    panel = CallbackShortcuts(
      bindings: <ShortcutActivator, VoidCallback>{
        const SingleActivator(LogicalKeyboardKey.escape): () =>
            _settle(open: false),
      },
      child: FocusScope(autofocus: true, child: panel),
    );

    return Positioned.fill(
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: dismissible ? () => _settle(open: false) : null,
              child: ColoredBox(
                color: barrier.withValues(alpha: barrier.a * t),
              ),
            ),
          ),
          panel,
        ],
      ),
    );
  }
}
