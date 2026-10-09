// The `stage_container` component: a responsive layout helper that snaps its
// content to breakpoint widths and centres it with density-aware padding.
//
// Ported from `components/layout/stage_container`. Fixes vs old:
//   * the theme default was a hard-coded 72 px while the widget computed
//     `density.baseContainerPadding * 4.5`; the new default is the
//     density-aware `EdgeInsetsDensity.symmetric(horizontal: 4.5)`;
//   * an unbounded width (e.g. inside a horizontal scroll view) produced
//     infinite insets; it now falls back to the base padding;
//   * `StageContainerTheme` is resolved through `resolveComponentStyle`, so the
//     app leg and per-field merge work like every other component.

import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../../theme/density.dart';
import '../../theme/theme.dart';
import 'stage_container_style.dart';

export 'stage_container_style.dart';

/// Builds the stage content from the resolved outer [padding].
typedef StageContainerBuilder =
    Widget Function(BuildContext context, EdgeInsets padding);

/// A responsive container that constrains content to breakpoint widths.
///
/// The [builder] receives the outer padding to apply; [StageContainer] does
/// not wrap the child itself, so the caller controls the box.
class StageContainer extends StatelessWidget {
  /// Creates a stage container.
  const StageContainer({
    super.key,
    required this.builder,
    this.breakpoint,
    this.padding,
    this.theme,
  });

  /// Builds the content; receives the resolved outer padding.
  final StageContainerBuilder builder;

  /// Width strategy; null resolves the theme, then the default breakpoints.
  final StageBreakpoint? breakpoint;

  /// Base padding; null resolves the theme, then the density default.
  final EdgeInsetsGeometry? padding;

  /// Widget-leg theme override.
  final StageContainerTheme? theme;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData ambient = ShadcnTheme.of(context);
    // Direct widget args win over the `theme:` widget leg, which fills the
    // rest; both sit above the scoped and app legs.
    final StageContainerTheme widgetTheme = StageContainerTheme(
      breakpoint: breakpoint,
      padding: padding,
    ).merge(theme);
    final StageContainerTheme style =
        resolveComponentStyle<StageContainerTheme, StageContainerTheme>(
          context,
          widget: widgetTheme,
          select: (StageContainerTheme theme) => theme,
          defaults: stageContainerDefaults,
        );
    final StageBreakpoint resolvedBreakpoint =
        style.breakpoint ?? StageBreakpoint.defaultBreakpoints;
    final EdgeInsets resolvedPadding = resolveEdgeInsets(
      style.padding ?? EdgeInsets.zero,
      ambient.density.baseContainerPadding * ambient.scaling,
    ).resolve(Directionality.maybeOf(context));

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double size = constraints.maxWidth;
        if (!size.isFinite) {
          return builder(context, resolvedPadding);
        }
        if (size < resolvedBreakpoint.minSize) {
          return builder(context, resolvedPadding.copyWith(left: 0, right: 0));
        }
        if (size > resolvedBreakpoint.maxSize) {
          return builder(
            context,
            _centred(resolvedPadding, (size - resolvedBreakpoint.maxSize) / 2),
          );
        }
        final double minWidth = resolvedBreakpoint.getMinWidth(size);
        final double maxWidth = resolvedBreakpoint.getMaxWidth(size);
        assert(
          minWidth <= maxWidth,
          'minWidth must be <= maxWidth ($minWidth > $maxWidth)',
        );
        return builder(
          context,
          _centred(resolvedPadding, (size - minWidth) / 2),
        );
      },
    );
  }

  /// Adds [extra] to both horizontal sides, clamped at zero.
  static EdgeInsets _centred(EdgeInsets padding, double extra) {
    return EdgeInsets.only(
      top: padding.top,
      bottom: padding.bottom,
      left: math.max(0.0, padding.left + extra),
      right: math.max(0.0, padding.right + extra),
    );
  }
}
