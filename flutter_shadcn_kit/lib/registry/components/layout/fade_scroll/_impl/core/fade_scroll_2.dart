// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../fade_scroll.dart';

/// FadeScroll defines a reusable type for this registry module.
class FadeScroll extends StatelessWidget {
  /// The offset from the start where the fade begins.
  final double? startOffset;

  /// The offset from the end where the fade begins.
  final double? endOffset;

  /// The cross-axis offset for the start fade.
  final double startCrossOffset;

  /// The cross-axis offset for the end fade.
  final double endCrossOffset;

  /// The scrollable child widget.
  final Widget child;

  /// The scroll controller to monitor for scroll position.
  final ScrollController controller;

  /// The gradient colors for the fade effect.
  final List<Color>? gradient;

  /// Creates a fade scroll widget.
  const FadeScroll({
    super.key,
    this.startOffset,
    this.endOffset,
    required this.child,
    required this.controller,
    this.gradient,
    this.startCrossOffset = 0,
    this.endCrossOffset = 0,
  });

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    final compTheme = ComponentTheme.maybeOf<FadeScrollTheme>(context);
    final startOffset = styleValue(
      widgetValue: this.startOffset,
      themeValue: compTheme?.startOffset,
      defaultValue: 0.0,
    );
    final endOffset = styleValue(
      widgetValue: this.endOffset,
      themeValue: compTheme?.endOffset,
      defaultValue: 0.0,
    );
    final gradient = styleValue(
      widgetValue: this.gradient,
      themeValue: compTheme?.gradient,
      defaultValue: const [Colors.transparent, Colors.white],
    );
    return ListenableBuilder(
      listenable: controller,
      child: child,
      builder: (context, child) {
        if (!controller.hasClients) {
          return child!;
        }

        /// Stores `position` state/configuration for this implementation.
        final position = controller.position.pixels;

        /// Stores `max` state/configuration for this implementation.
        final max = controller.position.maxScrollExtent;

        /// Stores `min` state/configuration for this implementation.
        final min = controller.position.minScrollExtent;

        final direction = controller.position.axis;

        final size = controller.position.viewportDimension;

        /// Stores `shouldFadeStart` state/configuration for this implementation.
        bool shouldFadeStart = position > min;

        /// Stores `shouldFadeEnd` state/configuration for this implementation.
        bool shouldFadeEnd = position < max;
        if (!shouldFadeStart && !shouldFadeEnd) {
          return child!;
        }

        final startExtent = _edgeExtent(startOffset, size);
        final endExtent = _edgeExtent(endOffset, size);
        if (startExtent == 0 && endExtent == 0) {
          return child!;
        }

        return ClipRect(
          child: Stack(
            fit: StackFit.passthrough,
            children: [
              child!,
              if (shouldFadeStart && startExtent > 0)
                _EdgeFade(
                  axis: direction,
                  extent: startExtent,
                  crossStart: startCrossOffset,
                  crossEnd: endCrossOffset,
                  colors: gradient.reversed.toList(growable: false),
                  alignment: _EdgeFadeAlignment.start,
                ),
              if (shouldFadeEnd && endExtent > 0)
                _EdgeFade(
                  axis: direction,
                  extent: endExtent,
                  crossStart: startCrossOffset,
                  crossEnd: endCrossOffset,
                  colors: gradient,
                  alignment: _EdgeFadeAlignment.end,
                ),
            ],
          ),
        );
      },
    );
  }

  double _edgeExtent(double extent, double viewportSize) {
    if (extent <= 0 || viewportSize <= 0) {
      return 0;
    }
    return extent.clamp(0, viewportSize / 2).toDouble();
  }
}

enum _EdgeFadeAlignment { start, end }

class _EdgeFade extends StatelessWidget {
  const _EdgeFade({
    required this.axis,
    required this.extent,
    required this.crossStart,
    required this.crossEnd,
    required this.colors,
    required this.alignment,
  });

  final Axis axis;
  final double extent;
  final double crossStart;
  final double crossEnd;
  final List<Color> colors;
  final _EdgeFadeAlignment alignment;

  @override
  Widget build(BuildContext context) {
    final isHorizontal = axis == Axis.horizontal;
    final isStart = alignment == _EdgeFadeAlignment.start;
    return Positioned(
      top: isHorizontal ? crossStart : (isStart ? 0 : null),
      bottom: isHorizontal ? crossEnd : (isStart ? null : 0),
      left: isHorizontal ? (isStart ? 0 : null) : crossStart,
      right: isHorizontal ? (isStart ? null : 0) : crossEnd,
      width: isHorizontal ? extent : null,
      height: isHorizontal ? null : extent,
      child: IgnorePointer(
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: colors,
              begin: isHorizontal ? Alignment.centerLeft : Alignment.topCenter,
              end: isHorizontal
                  ? Alignment.centerRight
                  : Alignment.bottomCenter,
            ),
          ),
        ),
      ),
    );
  }
}
