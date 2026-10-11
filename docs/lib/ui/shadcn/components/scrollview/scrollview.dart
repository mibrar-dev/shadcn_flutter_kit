// The `scrollview` component: middle-button drag-to-scroll ("autoscroll")
// for desktop and web pointer devices.
//
// A middle-button press anchors the pointer; while the button is held the
// widget synthesises a [PointerScrollEvent] every frame whose speed grows
// with the distance from the anchor, and dispatches it to whatever is
// hit-tested under the anchor. Releasing the button always ends the drag.

import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

/// Speed factor applied to the cubed anchor distance.
const double _kScrollViewDragSpeed = 0.02;

/// Maximum synthetic scroll speed in logical pixels per millisecond.
const double _kScrollViewMaxSpeed = 10;

/// Wraps [child] with middle-button autoscroll.
///
/// ```dart
/// ScrollViewInterceptor(
///   child: SingleChildScrollView(child: content),
/// );
/// ```
class ScrollViewInterceptor extends StatefulWidget {
  /// Creates an interceptor around [child].
  const ScrollViewInterceptor({
    super.key,
    required this.child,
    this.enabled = true,
  });

  /// The subtree that receives the synthetic scroll events.
  final Widget child;

  /// When false the child renders untouched and no pointer is intercepted.
  final bool enabled;

  @override
  State<ScrollViewInterceptor> createState() => _ScrollViewInterceptorState();
}

class _ScrollViewInterceptorState extends State<ScrollViewInterceptor>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  Duration? _lastTick;
  PointerDownEvent? _anchor;
  Offset? _pointer;
  MouseCursor? _cursor;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_tick);
  }

  @override
  void didUpdateWidget(covariant ScrollViewInterceptor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.enabled) {
      _deactivate();
    }
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  /// One autoscroll frame: speed is the cubed distance from the anchor
  /// divided by the frame time, clamped to [_kScrollViewMaxSpeed].
  void _tick(Duration elapsed) {
    final PointerDownEvent? anchor = _anchor;
    final Offset? pointer = _pointer;
    if (anchor == null || pointer == null) {
      return;
    }
    final Duration delta = _lastTick == null
        ? Duration.zero
        : elapsed - _lastTick!;
    _lastTick = elapsed;
    if (delta.inMilliseconds == 0) {
      return;
    }
    final Offset distance = anchor.position - pointer;
    _dispatch(
      Offset(_speedFor(distance.dx, delta), _speedFor(distance.dy, delta)),
    );
  }

  /// Synthetic scroll speed for one axis, in logical pixels per millisecond.
  double _speedFor(double distance, Duration delta) {
    final double speed =
        math.pow(-distance * _kScrollViewDragSpeed, 3) / delta.inMilliseconds;
    return speed.clamp(-_kScrollViewMaxSpeed, _kScrollViewMaxSpeed);
  }

  /// Sends [scrollDelta] to every hit-test target under the anchor.
  void _dispatch(Offset scrollDelta) {
    final PointerDownEvent anchor = _anchor!;
    final HitTestResult result = HitTestResult();
    GestureBinding.instance.hitTestInView(
      result,
      anchor.position,
      anchor.viewId,
    );
    final PointerScrollEvent event = PointerScrollEvent(
      position: anchor.position,
      device: anchor.device,
      embedderId: anchor.embedderId,
      kind: anchor.kind,
      timeStamp: Duration(milliseconds: DateTime.now().millisecondsSinceEpoch),
      viewId: anchor.viewId,
      scrollDelta: scrollDelta,
    );
    for (final HitTestEntry<HitTestTarget> entry in result.path) {
      try {
        entry.target.handleEvent(event, entry);
      } catch (error, stack) {
        FlutterError.reportError(
          FlutterErrorDetails(
            exception: error,
            stack: stack,
            library: 'shadcn_flutter',
            context: ErrorDescription(
              'while dispatching a pointer scroll event',
            ),
          ),
        );
      }
    }
  }

  void _handlePointerDown(PointerDownEvent event) {
    if (event.buttons != kMiddleMouseButton) {
      return;
    }
    if (_ticker.isActive) {
      _deactivate();
      return;
    }
    _anchor = event;
    _pointer = event.position;
    _lastTick = null;
    _ticker.start();
    setState(() {
      _cursor = SystemMouseCursors.allScroll;
    });
  }

  void _handlePointerMove(PointerMoveEvent event) {
    if (_ticker.isActive) {
      _pointer = event.position;
    }
  }

  void _handlePointerUp(PointerUpEvent event) {
    _deactivate();
  }

  void _deactivate() {
    if (!_ticker.isActive) {
      return;
    }
    _ticker.stop();
    _lastTick = null;
    _anchor = null;
    _pointer = null;
    setState(() {
      _cursor = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) {
      return widget.child;
    }
    return Stack(
      clipBehavior: Clip.none,
      fit: StackFit.passthrough,
      children: <Widget>[
        Listener(
          onPointerDown: _handlePointerDown,
          onPointerMove: _handlePointerMove,
          onPointerUp: _handlePointerUp,
          child: widget.child,
        ),
        if (_cursor != null)
          Positioned.fill(
            child: MouseRegion(
              cursor: _cursor!,
              hitTestBehavior: HitTestBehavior.translucent,
              onHover: (event) => _pointer = event.position,
            ),
          ),
      ],
    );
  }
}
