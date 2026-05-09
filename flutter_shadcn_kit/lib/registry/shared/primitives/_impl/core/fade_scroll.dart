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
      defaultValue: const [Colors.white, Colors.transparent],
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

        /// Stores `direction` state/configuration for this implementation.
        final direction = controller.position.axis;

        /// Stores `size` state/configuration for this implementation.
        final size = controller.position.viewportDimension;

        /// Stores `shouldFadeStart` state/configuration for this implementation.
        bool shouldFadeStart = position > min;

        /// Stores `shouldFadeEnd` state/configuration for this implementation.
        bool shouldFadeEnd = position < max;
        if (!shouldFadeStart && !shouldFadeEnd) {
          return child!;
        }
        return ShaderMask(
          shaderCallback: (bounds) {
            Alignment start = direction == Axis.horizontal
                ? Alignment.centerLeft
                : Alignment.topCenter;
            Alignment end = direction == Axis.horizontal
                ? Alignment.centerRight
                : Alignment.bottomCenter;

            /// Stores `relativeStart` state/configuration for this implementation.
            double relativeStart = startOffset / size;

            /// Stores `relativeEnd` state/configuration for this implementation.
            double relativeEnd = 1 - endOffset / size;
            List<double> stops = shouldFadeStart && shouldFadeEnd
                ? [
                    for (int i = 0; i < gradient.length; i++)
                      (i / gradient.length) * relativeStart,
                    relativeStart,
                    relativeEnd,
                    for (int i = 1; i < gradient.length + 1; i++)
                      relativeEnd + (i / gradient.length) * (1 - relativeEnd),
                  ]
                : shouldFadeStart
                ? [
                    for (int i = 0; i < gradient.length; i++)
                      (i / gradient.length) * relativeStart,
                    relativeStart,
                    1,
                  ]
                : [
                    0,
                    relativeEnd,
                    for (int i = 1; i < gradient.length + 1; i++)
                      relativeEnd + (i / gradient.length) * (1 - relativeEnd),
                  ];
            return LinearGradient(
              colors: [
                if (shouldFadeStart) ...gradient,
                Colors.white,
                Colors.white,
                if (shouldFadeEnd) ...gradient.reversed,
              ],
              stops: stops,
              begin: start,
              end: end,
              transform: const _ScaleGradient(Offset(1, 1.5)),
            ).createShader(bounds);
          },
          child: child!,
        );
      },
    );
  }
}
