// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../switcher.dart';

/// _SwitcherState defines a reusable type for this registry module.
class _SwitcherState extends State<Switcher> {
  /// Stores `_index` state/configuration for this implementation.
  late double _index;

  /// Stores `_dragging` state/configuration for this implementation.
  bool _dragging = false;

  @override
  /// Executes `initState` behavior for this component/composite.
  void initState() {
    super.initState();
    _index = widget.index.toDouble();
  }

  @override
  /// Executes `didUpdateWidget` behavior for this component/composite.
  void didUpdateWidget(covariant Switcher oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.index != widget.index) {
      _index = widget.index.toDouble();
      _dragging = false; // cancels out dragging
    }
  }

  /// Executes `buildDraggable` behavior for this component/composite.
  Widget buildDraggable(BuildContext context, Widget child) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onPanStart: (_) {
        _dragging = true;
      },
      onPanUpdate: (details) {
        if (_dragging) {
          /// Stores `currentSize` state/configuration for this implementation.
          final currentSize = context.size!;

          /// Stores `delta` state/configuration for this implementation.
          double delta;
          switch (widget.direction) {
            case AxisDirection.up:
              delta = -details.delta.dy / currentSize.height;
              break;
            case AxisDirection.down:
              delta = details.delta.dy / currentSize.height;
              break;
            case AxisDirection.left:
              delta = -details.delta.dx / currentSize.width;
              break;
            case AxisDirection.right:
              delta = details.delta.dx / currentSize.width;
              break;
          }

          /// Creates a `setState` instance.
          setState(() {
            _index += delta;
            _index = _index.clamp(0, widget.children.length - 1).toDouble();
          });
        }
      },
      onPanEnd: (_) {
        _snapIndex();
      },
      onPanCancel: () {
        _snapIndex();
      },
      child: child,
    );
  }

  /// Executes `_snapIndex` behavior for this component/composite.
  void _snapIndex() {
    /// Creates a `setState` instance.
    setState(() {
      _dragging = false;
      _index = _index.roundToDouble();
      if (widget.onIndexChanged != null) {
        widget.onIndexChanged!(_index.toInt());
      }
    });
  }

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    return buildDraggable(
      context,

      /// Creates a `AnimatedValueBuilder` instance.
      AnimatedValueBuilder(
        value: _index,
        duration: _dragging ? Duration.zero : widget.duration,
        curve: widget.curve,
        builder: (context, value, child) {
          final sourceChild = value.floor();
          final targetChild = value.ceil();

          /// Stores `relativeProgress` state/configuration for this implementation.
          final relativeProgress = value - sourceChild;
          return _SwitcherTransition(
            progress: relativeProgress,
            direction: widget.direction,
            absolute: false,
            children: [
              1 - relativeProgress == 0
                  ? const SizedBox.shrink()
                  : Opacity(
                      key: ValueKey(sourceChild),
                      opacity: 1 - relativeProgress,
                      child: widget.children[sourceChild],
                    ),
              relativeProgress == 0
                  ? const SizedBox.shrink()
                  : Opacity(
                      key: ValueKey(targetChild),
                      opacity: relativeProgress,
                      child: widget.children[targetChild],
                    ),
            ],
          );
        },
      ),
    );
  }
}
