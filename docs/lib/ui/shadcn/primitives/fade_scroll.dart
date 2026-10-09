// `FadeScroll`: fades the leading/trailing edges of a scrollable when there
// is more content in that direction.
//
// Ported from `shared/primitives/fade_scroll.dart` + `_impl/**`.

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../foundation/style_value.dart';
import '../theme/color_utils.dart';
import '../theme/color_tokens.dart';
import '../theme/theme.dart';

/// Offset and gradient defaults for [FadeScroll].
class FadeScrollTheme extends ComponentThemeData
    implements Mergeable<FadeScrollTheme> {
  /// Distance from the start where the fade begins.
  final double? startOffset;

  /// Distance from the end where the fade begins.
  final double? endOffset;

  /// Gradient colours used for the fade. Defaults to white -> transparent.
  final List<Color>? gradient;

  /// Creates a [FadeScrollTheme].
  const FadeScrollTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.startOffset,
    this.endOffset,
    this.gradient,
  });

  /// Returns a copy with the given fields replaced.
  FadeScrollTheme copyWith({
    ValueGetter<double?>? startOffset,
    ValueGetter<double?>? endOffset,
    ValueGetter<List<Color>?>? gradient,
  }) {
    return FadeScrollTheme(
      startOffset: startOffset == null ? this.startOffset : startOffset(),
      endOffset: endOffset == null ? this.endOffset : endOffset(),
      gradient: gradient == null ? this.gradient : gradient(),
    );
  }

  /// First-non-null-wins merge; the receiver (higher-priority leg) wins.
  @override
  FadeScrollTheme merge(FadeScrollTheme? fallback) {
    if (fallback == null) return this;
    return FadeScrollTheme(
      themeDensity: themeDensity ?? fallback.themeDensity,
      themeSpacing: themeSpacing ?? fallback.themeSpacing,
      themeShadows: themeShadows ?? fallback.themeShadows,
      startOffset: startOffset ?? fallback.startOffset,
      endOffset: endOffset ?? fallback.endOffset,
      gradient: gradient ?? fallback.gradient,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FadeScrollTheme &&
        other.startOffset == startOffset &&
        other.endOffset == endOffset &&
        listEquals(other.gradient, gradient);
  }

  @override
  int get hashCode => Object.hash(startOffset, endOffset, gradient);
}

/// Fades the edges of [child] while [controller] reports hidden content.
class FadeScroll extends StatelessWidget {
  /// Distance from the start where the fade begins. Defaults to 0.
  final double? startOffset;

  /// Distance from the end where the fade begins. Defaults to 0.
  final double? endOffset;

  /// Cross-axis offset of the start fade.
  final double startCrossOffset;

  /// Cross-axis offset of the end fade.
  final double endCrossOffset;

  /// The scrollable child.
  final Widget child;

  /// Controller monitored for the scroll position.
  final ScrollController controller;

  /// Gradient colours for the fade. Defaults to white -> transparent.
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
  Widget build(BuildContext context) {
    final componentTheme =
        resolveComponentStyle<FadeScrollTheme, FadeScrollTheme>(
          context,
          select: (t) => t,
          defaults: const FadeScrollTheme(),
        );
    final startOffset = styleValue(
      widgetValue: this.startOffset,
      themeValue: componentTheme.startOffset,
      defaultValue: 0.0,
    );
    final endOffset = styleValue(
      widgetValue: this.endOffset,
      themeValue: componentTheme.endOffset,
      defaultValue: 0.0,
    );
    final gradient = styleValue(
      widgetValue: this.gradient,
      themeValue: componentTheme.gradient,
      defaultValue: const [Colors.white, Colors.transparent],
    );
    return ListenableBuilder(
      listenable: controller,
      child: child,
      builder: (context, child) {
        if (!controller.hasClients) {
          return ShaderMask(shaderCallback: _identityShader, child: child!);
        }
        final position = controller.position;
        final pixels = position.pixels;
        final max = position.maxScrollExtent;
        final min = position.minScrollExtent;
        final shouldFadeStart = pixels > min;
        final shouldFadeEnd = pixels < max;
        if (!shouldFadeStart && !shouldFadeEnd) {
          return ShaderMask(shaderCallback: _identityShader, child: child!);
        }
        final direction = position.axis;
        final size = position.viewportDimension;
        final Alignment start = direction == Axis.horizontal
            ? Alignment.centerLeft
            : Alignment.topCenter;
        final Alignment end = direction == Axis.horizontal
            ? Alignment.centerRight
            : Alignment.bottomCenter;
        final double relativeStart = startOffset / size;
        final double relativeEnd = 1 - endOffset / size;
        final List<double> stops = shouldFadeStart && shouldFadeEnd
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
        return ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
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
          ).createShader(bounds),
          child: child!,
        );
      },
    );
  }

  /// Fully opaque shader used while no edge needs a fade.
  ///
  /// The [ShaderMask] node stays in the tree either way, so the scrollable
  /// child is never remounted when the fade state changes.
  static Shader _identityShader(Rect bounds) {
    return const LinearGradient(
      colors: [Colors.white, Colors.white],
    ).createShader(bounds);
  }
}

class _ScaleGradient extends GradientTransform {
  final Offset scale;

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
