// The `skeleton` component: a widgets-only loading placeholder with a
// repeating shimmer, replacing `package:skeletonizer` (banned).
//
// The old module was `ShadcnSkeletonizerConfigLayer` plus a `Widget` extension
// (`asSkeleton`, `asSkeletonSliver`, `ignoreSkeleton`, `excludeSkeleton`).
// Fixes, all verified against the old source:
//   * `package:skeletonizer/skeletonizer.dart` and `package:flutter/material.dart`
//     imports are gone; the shimmer is a gradient sweep built from
//     `RepeatedAnimationBuilder` (primitives/animation.dart).
//   * `asSkeleton(snapshot:)` silently overrode the caller's `enabled`
//     argument whenever a snapshot was passed (`enabled = !snapshot.hasData`),
//     so `enabled: false, snapshot: <loaded>` still showed a skeleton.
//   * `asSkeleton` returned `Skeleton.leaf` for `Avatar`/`Image` only when
//     neither `unite` nor `replacement` was given, so the flags silently
//     overrode each other depending on argument order.
//   * `fromColor`/`toColor` had two different defaults in two files
//     (hard-coded `0x0D171717`/`0x1A171717` versus `primary.scaleAlpha(0.05)`
//     and `0.1`); there is one token-derived row now.
//   * `enableSwitchAnimation` toggled `SkeletonizerConfigData` but no widget
//     in the component read it — it was a dead knob.

import 'package:flutter/widgets.dart';

import '../../primitives/animation.dart';
import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';
import 'skeleton_style.dart';

export 'skeleton_style.dart';

/// A shimmering placeholder shown while [content] is still loading.
///
/// The widget keeps the child's layout box, so swapping it in and out never
/// moves the surrounding page:
///
/// ```dart
/// Skeleton(
///   enabled: loading,
///   child: Text('Summary'),
/// );
/// ```
class Skeleton extends StatelessWidget {
  /// Creates a skeleton placeholder.
  const Skeleton({
    super.key,
    required this.child,
    this.enabled = true,
    this.borderRadius,
    this.theme,
  });

  /// The real content, laid out but painted only while [enabled] is false.
  final Widget child;

  /// Whether the placeholder is shown. A disabled skeleton paints [child].
  final bool enabled;

  /// Corner radius override; null uses `SkeletonTheme.borderRadius` and then
  /// the theme's `borderRadiusMd`.
  final BorderRadiusGeometry? borderRadius;

  /// Widget-leg theme override, merged on top of the other legs.
  final SkeletonTheme? theme;

  @override
  Widget build(BuildContext context) {
    final SkeletonTheme resolved =
        resolveComponentStyle<SkeletonTheme, SkeletonTheme>(
          context,
          widget: theme,
          select: (t) => t,
          defaults: skeletonDefaults,
        );
    final BorderRadius radius =
        (borderRadius ?? resolved.borderRadius ?? _defaultRadius(context))
            .resolve(Directionality.of(context));
    if (!enabled) {
      return ClipRRect(borderRadius: radius, child: child);
    }
    return _Shimmer(
      from: resolved.fromColor,
      to: resolved.toColor,
      duration: resolved.duration!,
      curve: resolved.curve!,
      borderRadius: radius,
      child: child,
    );
  }

  BorderRadius _defaultRadius(BuildContext context) {
    return ShadcnTheme.of(context).borderRadiusMd;
  }
}

/// Repaints a sweeping gradient over [child] until the skeleton is replaced.
class _Shimmer extends StatelessWidget {
  const _Shimmer({
    required this.child,
    required this.borderRadius,
    required this.from,
    required this.to,
    required this.duration,
    required this.curve,
  });

  final Widget child;
  final BorderRadius borderRadius;
  final ThemedColor? from;
  final ThemedColor? to;
  final Duration duration;
  final Curve curve;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    final Color fromColor = from?.resolve(theme.colors) ?? theme.colors.muted;
    final Color toColor = to?.resolve(theme.colors) ?? theme.colors.accent;
    return ClipRRect(
      borderRadius: borderRadius,
      child: RepeatedAnimationBuilder(
        start: 0,
        end: 1,
        duration: duration,
        curve: curve,
        builder: (context, value, child) => Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(-1 - 2 * (1 - value), -1),
              end: Alignment(1 + 2 * (1 - value), 1),
              colors: <Color>[fromColor, toColor, fromColor],
              stops: const <double>[
                kSkeletonSweepHandover - kSkeletonSweepFade,
                kSkeletonSweepHandover,
                kSkeletonSweepHandover + kSkeletonSweepFade,
              ],
            ),
          ),
          child: child,
        ),
        child: child,
      ),
    );
  }
}
