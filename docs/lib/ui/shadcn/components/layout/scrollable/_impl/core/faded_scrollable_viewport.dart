// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../scrollable.dart';

/// A viewport wrapper that fades content near the leading/trailing edges.
class FadedScrollableViewport extends StatefulWidget {
  /// Stores `child` state/configuration for this implementation.
  final Widget child;

  /// Stores `fadeExtent` state/configuration for this implementation.
  final double fadeExtent;

  /// Stores `fadeSize` state/configuration for this implementation.
  final double fadeSize;

  /// Creates a `FadedScrollableViewport` instance.
  const FadedScrollableViewport({
    super.key,
    this.fadeExtent = 20.0,
    this.fadeSize = 50.0,
    required this.child,
  });

  @override
  /// Executes `createState` behavior for this component/composite.
  State<FadedScrollableViewport> createState() =>
      _FadedScrollableViewportState();
}

/// _FadedScrollableViewportState defines a reusable type for this registry module.
class _FadedScrollableViewportState extends State<FadedScrollableViewport> {
  /// Stores `_scrollOffset` state/configuration for this implementation.
  double _scrollOffset = 0.0;

  /// Stores `_scrollExtent` state/configuration for this implementation.
  double _scrollExtent = 0.0;

  /// Stores `_scrollAxis` state/configuration for this implementation.
  Axis _scrollAxis = Axis.vertical;

  double get _startFadeFraction {
    if (_scrollExtent <= 0) {
      return 0.0;
    }
    return (_scrollOffset / widget.fadeExtent).clamp(0.0, 1.0);
  }

  double get _endFadeFraction {
    if (_scrollExtent <= 0) {
      return 0.0;
    }
    return ((_scrollExtent - _scrollOffset) / widget.fadeExtent).clamp(
      0.0,
      1.0,
    );
  }

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        /// Creates a `setState` instance.
        setState(() {
          _scrollOffset = notification.metrics.pixels;
          _scrollExtent = notification.metrics.maxScrollExtent;
          _scrollAxis = notification.metrics.axis;
        });
        return false;
      },
      child: ShaderMask(
        shaderCallback: (bounds) {
          final transparent = const Color(0x00000000);
          final black = const Color(0xFF000000);
          return LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [transparent, black, black, transparent],
            stops: [
              0.0,
              _startFadeFraction *
                  (_scrollAxis == Axis.vertical
                      ? widget.fadeSize / bounds.height
                      : widget.fadeSize / bounds.width),
              1.0 -
                  _endFadeFraction *
                      (_scrollAxis == Axis.vertical
                          ? widget.fadeSize / bounds.height
                          : widget.fadeSize / bounds.width),
              1.0,
            ],
          ).createShader(bounds);
        },
        blendMode: BlendMode.dstIn,
        child: widget.child,
      ),
    );
  }
}
