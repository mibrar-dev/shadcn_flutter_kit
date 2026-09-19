// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../fade_scroll.dart';

/// A widget that applies fade effects at the edges of scrollable content.
///
/// Adds gradient fade overlays to the start and end of scrollable content,
/// creating a visual cue that there's more content to scroll.
class FadeScroll extends StatelessWidget implements Styleable<FadeScrollTheme> {
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

  /// Styling for this widget alone, overriding the ancestor theme.
  @override
  final FadeScrollTheme? theme;


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
    this.theme,
  });

  /// Builds the widget tree for fade scroll.
  @override
  Widget build(BuildContext context) {
    final compTheme = this.theme ?? ComponentTheme.maybeOf<FadeScrollTheme>(context);
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
        final position = controller.position.pixels;
        final max = controller.position.maxScrollExtent;
        final min = controller.position.minScrollExtent;
        final direction = controller.position.axis;
        final size = controller.position.viewportDimension;
        bool shouldFadeStart = position > min;
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
            double relativeStart = startOffset / size;
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

/// Scales the fade gradient around the center of the shader bounds.
class _ScaleGradient extends GradientTransform {
  /// Scale applied to the gradient transform.
  final Offset scale;

  /// Creates a [_ScaleGradient] with the given [scale].
  const _ScaleGradient(this.scale);

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    final center = bounds.center;
    final dx = center.dx * (1 - scale.dx);
    final dy = center.dy * (1 - scale.dy);
    return Matrix4.identity()
      ..translateByDouble(dx, dy, 0, 1)
      ..scaleByDouble(scale.dx, scale.dy, 1, 1)
      ..translateByDouble(-dx, -dy, 0, 1);
  }
}
