// `FadeScroll`: fades the leading/trailing edges of a scrollable when there
// is more content in that direction.
//
// The fade is an alpha-only `ShaderMask` (`BlendMode.dstIn`, opaque white to
// transparent white), so it dissolves into whatever surface sits behind the
// scrollable and stays correct in light and dark mode. Colour-gradient masks
// (`BlendMode.modulate`, the default) multiply colour but never alpha, so a
// colour-to-transparent gradient either fades nothing (transparent white) or
// paints a tinted block (a surface colour in dark mode reads as black).
//
// Ported from `shared/primitives/fade_scroll.dart` + `_impl/**`.

import 'package:flutter/widgets.dart';

import '../foundation/style_value.dart';
import '../theme/color_tokens.dart';
import '../theme/theme.dart';

/// Offset defaults for [FadeScroll].
class FadeScrollTheme extends ComponentThemeData
    implements Mergeable<FadeScrollTheme> {
  /// Fade length from the start edge in logical pixels.
  final double? startOffset;

  /// Fade length from the end edge in logical pixels.
  final double? endOffset;

  /// Creates a [FadeScrollTheme].
  const FadeScrollTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.startOffset,
    this.endOffset,
  });

  /// Returns a copy with the given fields replaced.
  FadeScrollTheme copyWith({
    ValueGetter<double?>? startOffset,
    ValueGetter<double?>? endOffset,
  }) {
    return FadeScrollTheme(
      startOffset: startOffset == null ? this.startOffset : startOffset(),
      endOffset: endOffset == null ? this.endOffset : endOffset(),
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
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FadeScrollTheme &&
        other.startOffset == startOffset &&
        other.endOffset == endOffset;
  }

  @override
  int get hashCode => Object.hash(startOffset, endOffset);
}

/// Fades the edges of [child] while [controller] reports hidden content.
class FadeScroll extends StatefulWidget {
  /// Fade length from the start edge. Defaults to 0 (no start fade).
  final double? startOffset;

  /// Fade length from the end edge. Defaults to 0 (no end fade).
  final double? endOffset;

  /// The scrollable child.
  final Widget child;

  /// Controller monitored for the scroll position.
  final ScrollController controller;

  /// Creates a fade scroll widget.
  const FadeScroll({
    super.key,
    this.startOffset,
    this.endOffset,
    required this.child,
    required this.controller,
  });

  @override
  State<FadeScroll> createState() => _FadeScrollState();
}

class _FadeScrollState extends State<FadeScroll> {
  @override
  void initState() {
    super.initState();
    // The controller gains its client during the first layout, after the
    // first build already chose the identity shader. Refresh once so an
    // initially overflowing scrollable fades without waiting for a scroll.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final componentTheme =
        resolveComponentStyle<FadeScrollTheme, FadeScrollTheme>(
          context,
          select: (t) => t,
          defaults: const FadeScrollTheme(),
        );
    final startOffset = styleValue(
      widgetValue: widget.startOffset,
      themeValue: componentTheme.startOffset,
      defaultValue: 0.0,
    );
    final endOffset = styleValue(
      widgetValue: widget.endOffset,
      themeValue: componentTheme.endOffset,
      defaultValue: 0.0,
    );
    return ListenableBuilder(
      listenable: widget.controller,
      child: widget.child,
      builder: (context, child) {
        final mask = _fadeMask(widget.controller, startOffset, endOffset);
        if (mask == null) {
          return ShaderMask(
            blendMode: BlendMode.dstIn,
            shaderCallback: _identityShader,
            child: child!,
          );
        }
        return ShaderMask(
          blendMode: BlendMode.dstIn,
          shaderCallback: (bounds) => LinearGradient(
            begin: mask.begin,
            end: mask.end,
            colors: mask.colors,
            stops: mask.stops,
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
      colors: [Color(0xFFFFFFFF), Color(0xFFFFFFFF)],
    ).createShader(bounds);
  }
}

/// An alpha-only edge mask, or null when no edge needs a fade.
_CutMask? _fadeMask(
  ScrollController controller,
  double startOffset,
  double endOffset,
) {
  if (!controller.hasClients) return null;
  final position = controller.position;
  final pixels = position.pixels;
  final max = position.maxScrollExtent;
  final min = position.minScrollExtent;
  final size = position.viewportDimension;
  if (size <= 0) return null;
  final bool wantStart = pixels > min && startOffset > 0;
  final bool wantEnd = pixels < max && endOffset > 0;
  if (!wantStart && !wantEnd) return null;
  double r0 = (startOffset / size).clamp(0.0, 1.0).toDouble();
  double r1 = (endOffset / size).clamp(0.0, 1.0).toDouble();
  if (wantStart && wantEnd && r0 + r1 > 1) {
    final total = r0 + r1;
    r0 /= total;
    r1 /= total;
  }
  final bool horizontal = position.axis == Axis.horizontal;
  final Alignment begin = horizontal
      ? Alignment.centerLeft
      : Alignment.topCenter;
  final Alignment end = horizontal
      ? Alignment.centerRight
      : Alignment.bottomCenter;
  const Color opaque = Color(0xFFFFFFFF);
  const Color clear = Color(0x00FFFFFF);
  if (wantStart && wantEnd) {
    return _CutMask(
      begin: begin,
      end: end,
      colors: const [clear, opaque, opaque, clear],
      stops: [0, r0, 1 - r1, 1],
    );
  }
  if (wantStart) {
    return _CutMask(
      begin: begin,
      end: end,
      colors: const [clear, opaque, opaque],
      stops: [0, r0, 1],
    );
  }
  return _CutMask(
    begin: begin,
    end: end,
    colors: const [opaque, opaque, clear],
    stops: [0, 1 - r1, 1],
  );
}

/// Gradient geometry of one [FadeScroll] edge mask.
class _CutMask {
  /// Creates mask geometry.
  const _CutMask({
    required this.begin,
    required this.end,
    required this.colors,
    required this.stops,
  });

  /// Gradient begin alignment.
  final Alignment begin;

  /// Gradient end alignment.
  final Alignment end;

  /// Alpha-only stops (RGB is ignored by `dstIn`).
  final List<Color> colors;

  /// Stop positions.
  final List<double> stops;
}
