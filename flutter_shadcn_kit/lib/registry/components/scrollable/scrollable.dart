// The `scrollable` component: [FadedScrollableViewport], a notification-driven
// edge fade over any scrollable subtree.
//
// This is the part of the old `layout/scrollable` directory that did not move
// to `scrollable_client`: its edge-fade viewport. Unlike `FadeScroll` (which
// needs a `ScrollController`), this viewport reacts to `ScrollNotification`s,
// so it can wrap scrollables the caller does not control. The fade math lives
// in `primitives/scroll_metrics.dart`.

import 'package:flutter/widgets.dart';

import '../../primitives/scroll_metrics.dart';
import '../../theme/theme.dart';
import 'scrollable_style.dart';

export 'scrollable_style.dart';

/// Fades the leading and trailing edges of [child] while it is scrolled.
///
/// ```dart
/// FadedScrollableViewport(
///   child: SingleChildScrollView(child: content),
/// );
/// ```
class FadedScrollableViewport extends StatefulWidget {
  /// Creates a fade viewport.
  const FadedScrollableViewport({
    super.key,
    required this.child,
    this.fadeExtent,
    this.fadeSize,
    this.theme,
  });

  /// The scrollable subtree the fade is drawn over.
  final Widget child;

  /// Scroll distance over which the fade reaches full strength.
  final double? fadeExtent;

  /// Length of the fade gradient.
  final double? fadeSize;

  /// Widget-leg style override, merged on top of the other resolver legs.
  final ScrollableTheme? theme;

  /// Resolves the effective fade geometry for [context].
  ///
  /// Exposed so custom masks can reuse the same four-leg resolution:
  /// `widget argument > ComponentTheme in tree > app overrides > defaults`.
  static ({double fadeExtent, double fadeSize}) resolveGeometry(
    BuildContext context, {
    double? fadeExtent,
    double? fadeSize,
    ScrollableTheme? theme,
  }) {
    final ScrollableTheme resolved =
        resolveComponentStyle<ScrollableTheme, ScrollableTheme>(
          context,
          widget: theme,
          select: (t) => t,
          defaults: scrollableDefaults,
        );
    return (
      fadeExtent:
          fadeExtent ?? resolved.fadeExtent ?? scrollableDefaultFadeExtent,
      fadeSize: fadeSize ?? resolved.fadeSize ?? scrollableDefaultFadeSize,
    );
  }

  /// Colour the edge fade blends into: the ambient `background` token, so the
  /// fade follows the selected preset in light and dark.
  ///
  /// Exposed so custom masks can paint the same surface the built-in one does.
  static Color resolveFadeSurface(BuildContext context) =>
      ShadcnTheme.of(context).colors.background;

  /// Gradient stops for the fade mask over an axis of [axisExtent].
  ///
  /// Stops are clamped monotonic so short content cannot produce a crossed
  /// gradient. Exposed for custom masks.
  static List<double> gradientStops({
    required double leading,
    required double trailing,
    required double fadeSize,
    required double axisExtent,
  }) {
    final double relative = axisExtent <= 0 ? 0 : fadeSize / axisExtent;
    final double leadingStop = (leading * relative).clamp(0.0, 1.0);
    final double trailingStop = (1 - trailing * relative).clamp(
      leadingStop,
      1.0,
    );
    return <double>[0, leadingStop, trailingStop, 1];
  }

  /// Gradient begin/end alignments for a fade viewport on [axis].
  ///
  /// The old viewport always faded top-to-bottom, so a horizontal scrollable
  /// faded the wrong edges. Exposed for custom masks.
  static ({Alignment begin, Alignment end}) gradientAxis(Axis axis) {
    return axis == Axis.vertical
        ? (begin: Alignment.topCenter, end: Alignment.bottomCenter)
        : (begin: Alignment.centerLeft, end: Alignment.centerRight);
  }

  @override
  State<FadedScrollableViewport> createState() =>
      _FadedScrollableViewportState();
}

class _FadedScrollableViewportState extends State<FadedScrollableViewport> {
  ScrollMetricsSnapshot _snapshot = const ScrollMetricsSnapshot(
    pixels: 0,
    maxScrollExtent: 0,
    viewportDimension: 0,
  );

  bool _onNotification(ScrollNotification notification) {
    final ScrollMetricsSnapshot next = ScrollMetricsSnapshot.fromMetrics(
      notification.metrics,
    );
    // Rebuild only when the metrics actually changed; the old viewport
    // rebuilt on every notification, including no-op updates.
    if (next != _snapshot) {
      setState(() {
        _snapshot = next;
      });
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final ({double fadeExtent, double fadeSize}) geometry =
        FadedScrollableViewport.resolveGeometry(
          context,
          fadeExtent: widget.fadeExtent,
          fadeSize: widget.fadeSize,
          theme: widget.theme,
        );
    final double leading = _snapshot.leadingFadeFraction(geometry.fadeExtent);
    final double trailing = _snapshot.trailingFadeFraction(geometry.fadeExtent);
    final bool vertical = _snapshot.axis == Axis.vertical;
    final ({Alignment begin, Alignment end}) axis =
        FadedScrollableViewport.gradientAxis(_snapshot.axis);
    // `dstIn` reads only alpha, but naming the surface token the fade blends
    // into keeps the intent explicit (and the mask correct in dark mode).
    final Color surface = FadedScrollableViewport.resolveFadeSurface(context);

    return NotificationListener<ScrollNotification>(
      onNotification: _onNotification,
      child: ShaderMask(
        blendMode: BlendMode.dstIn,
        shaderCallback: (bounds) {
          final double axisExtent = vertical ? bounds.height : bounds.width;
          return LinearGradient(
            begin: axis.begin,
            end: axis.end,
            colors: <Color>[
              surface.withValues(alpha: 0),
              surface,
              surface,
              surface.withValues(alpha: 0),
            ],
            stops: FadedScrollableViewport.gradientStops(
              leading: leading,
              trailing: trailing,
              fadeSize: geometry.fadeSize,
              axisExtent: axisExtent,
            ),
          ).createShader(bounds);
        },
        child: widget.child,
      ),
    );
  }
}
