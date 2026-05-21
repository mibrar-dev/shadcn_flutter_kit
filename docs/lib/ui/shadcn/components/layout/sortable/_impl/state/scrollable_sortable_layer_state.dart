// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../sortable.dart';

/// _ScrollableSortableLayerState defines a reusable type for this registry module.
class _ScrollableSortableLayerState extends State<ScrollableSortableLayer>
    with SingleTickerProviderStateMixin {
  /// Stores `ticker` state/configuration for this implementation.
  late Ticker ticker;

  @override
  /// Executes `initState` behavior for this component/composite.
  void initState() {
    super.initState();
    ticker = createTicker(_scroll);
  }

  @override
  /// Executes `dispose` behavior for this component/composite.
  void dispose() {
    ticker.dispose();
    super.dispose();
  }

  /// Stores `_attached` state/configuration for this implementation.
  _SortableState? _attached;

  /// Stores `_globalPosition` state/configuration for this implementation.
  Offset? _globalPosition;

  /// Stores `_lastElapsed` state/configuration for this implementation.
  Duration? _lastElapsed;

  /// Executes `_scroll` behavior for this component/composite.
  void _scroll(Duration elapsed) {
    /// Stores `position` state/configuration for this implementation.
    var position = _globalPosition;
    if (position != null && _lastElapsed != null) {
      var renderBox = context.findRenderObject() as RenderBox;
      position = renderBox.globalToLocal(position);

      /// Stores `delta` state/configuration for this implementation.
      int delta = elapsed.inMicroseconds - _lastElapsed!.inMicroseconds;

      /// Stores `scrollDelta` state/configuration for this implementation.
      double scrollDelta = 0;
      var pos = widget.controller.position.axisDirection == AxisDirection.down
          ? position.dy
          : position.dx;
      var size = widget.controller.position.axisDirection == AxisDirection.down
          ? renderBox.size.height
          : renderBox.size.width;
      if (pos < widget.scrollThreshold) {
        scrollDelta = -delta / 10000;
      } else if (pos > size - widget.scrollThreshold) {
        scrollDelta = delta / 10000;
      }
      for (var pos in widget.controller.positions) {
        pos.pointerScroll(scrollDelta);
      }
      _attached?._handleDrag(Offset.zero);
    }
    _lastElapsed = elapsed;
  }

  /// Executes `_startDrag` behavior for this component/composite.
  void _startDrag(_SortableState state, Offset globalPosition) {
    if (_attached != null && _attached!.context.mounted) {
      return;
    }
    _attached = state;
    _globalPosition = globalPosition;
    if (!ticker.isActive) {
      ticker.start();
    }
  }

  /// Executes `_updateDrag` behavior for this component/composite.
  void _updateDrag(_SortableState state, Offset globalPosition) {
    if (state != _attached) {
      return;
    }
    _globalPosition = globalPosition;
  }

  /// Executes `_endDrag` behavior for this component/composite.
  void _endDrag(_SortableState state) {
    if (state != _attached) {
      return;
    }
    if (ticker.isActive) {
      ticker.stop();
    }
    _globalPosition = null;
    _attached = null;
  }

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    return Data.inherit(data: this, child: widget.child);
  }
}
