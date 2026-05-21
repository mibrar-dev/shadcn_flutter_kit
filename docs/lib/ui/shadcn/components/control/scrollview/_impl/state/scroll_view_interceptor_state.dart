// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

import '../utils/desktop_pointer_scroll_event.dart';
import '../core/scroll_view_interceptor.dart';

/// Stores `kScrollDragSpeed` state/configuration for this implementation.
const double kScrollDragSpeed = 0.02;

/// Stores `kMaxScrollSpeed` state/configuration for this implementation.
const double kMaxScrollSpeed = 10.0;

/// ScrollViewInterceptorState defines a reusable type for this registry module.
class ScrollViewInterceptorState extends State<ScrollViewInterceptor>
    with SingleTickerProviderStateMixin {
  /// Stores `_ticker` state/configuration for this implementation.
  late Ticker _ticker;

  /// Stores `_lastTime` state/configuration for this implementation.
  Duration? _lastTime;

  /// Stores `_event` state/configuration for this implementation.
  PointerDownEvent? _event;

  /// Stores `_lastOffset` state/configuration for this implementation.
  Offset? _lastOffset;

  /// Stores `_cursor` state/configuration for this implementation.
  MouseCursor? _cursor;

  /// Stores `pointerMoved` state/configuration for this implementation.
  bool pointerMoved = false;

  @override
  /// Executes `initState` behavior for this component/composite.
  void initState() {
    super.initState();
    _ticker = createTicker(_tick);
  }

  @override
  /// Executes `dispose` behavior for this component/composite.
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  /// Executes `_tick` behavior for this component/composite.
  void _tick(Duration elapsed) {
    /// Stores `delta` state/configuration for this implementation.
    Duration delta = _lastTime == null ? Duration.zero : elapsed - _lastTime!;
    _lastTime = elapsed;
    if (delta.inMilliseconds == 0) return;

    /// Stores `positionDelta` state/configuration for this implementation.
    Offset positionDelta = _event!.position - _lastOffset!;
    double incX =
        pow(-positionDelta.dx * kScrollDragSpeed, 3) / delta.inMilliseconds;
    double incY =
        pow(-positionDelta.dy * kScrollDragSpeed, 3) / delta.inMilliseconds;
    incX = incX.clamp(-kMaxScrollSpeed, kMaxScrollSpeed);
    incY = incY.clamp(-kMaxScrollSpeed, kMaxScrollSpeed);

    /// Stores `instance` state/configuration for this implementation.
    var instance = GestureBinding.instance;
    HitTestResult result = HitTestResult();
    instance.hitTestInView(result, _event!.position, _event!.viewId);
    var pointerScrollEvent = DesktopPointerScrollEvent(
      position: _event!.position,
      device: _event!.device,
      embedderId: _event!.embedderId,
      kind: _event!.kind,
      timeStamp: Duration(milliseconds: DateTime.now().millisecondsSinceEpoch),
      viewId: _event!.viewId,
      scrollDelta: Offset(incX, incY),
    );
    for (final path in result.path) {
      try {
        path.target.handleEvent(pointerScrollEvent, path);
      } catch (e, s) {
        /// Creates a `FlutterError.reportError` instance.
        FlutterError.reportError(
          /// Creates a `FlutterErrorDetails` instance.
          FlutterErrorDetails(
            exception: e,
            stack: s,
            library: 'shadcn_flutter',
            context: ErrorDescription(
              'while dispatching a pointer scroll event',
            ),
          ),
        );
      }
    }
  }

  /// Executes `_activate` behavior for this component/composite.
  void _activate(PointerDownEvent event) {
    _event = event;
    _lastOffset = event.position;
    _lastTime = null;
    _ticker.start();

    /// Creates a `setState` instance.
    setState(() {
      _cursor = SystemMouseCursors.allScroll;
    });
  }

  /// Executes `_deactivate` behavior for this component/composite.
  void _deactivate() {
    _ticker.stop();
    _lastTime = null;
    _event = null;
    _lastOffset = null;

    /// Creates a `setState` instance.
    setState(() {
      _cursor = null;
    });
  }

  /// Executes `_toggleScrollMode` behavior for this component/composite.
  void _toggleScrollMode(PointerDownEvent event) {
    if (_ticker.isActive) {
      _deactivate();
    } else if (event.buttons == kMiddleMouseButton) {
      _activate(event);
    }
  }

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    if (!widget.enabled) return widget.child;

    return Stack(
      clipBehavior: Clip.none,
      fit: StackFit.passthrough,
      children: [
        /// Creates a `Listener` instance.
        Listener(
          onPointerDown: (event) {
            pointerMoved = false;
            _toggleScrollMode(event);
          },
          onPointerUp: (event) {
            if (_ticker.isActive && pointerMoved) {
              _deactivate();
            }
          },
          onPointerMove: (event) {
            if (_ticker.isActive) {
              pointerMoved = true;
              _lastOffset = event.position;
            }
          },
          child: widget.child,
        ),
        if (_cursor != null)
          /// Creates a `Positioned.fill` instance.
          Positioned.fill(
            child: MouseRegion(
              onHover: (event) => {_lastOffset = event.position},
              cursor: _cursor!,
              hitTestBehavior: HitTestBehavior.translucent,
            ),
          ),
      ],
    );
  }
}
