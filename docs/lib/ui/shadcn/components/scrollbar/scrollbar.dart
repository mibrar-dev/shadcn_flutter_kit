// The `scrollbar` component: a themed wrapper around Flutter's
// [RawScrollbar].
//
// The old module subclassed `RawScrollbarState` to write theme values into the
// painter (the painter API was not exposed yet); Flutter 3.47's `RawScrollbar`
// takes `thumbColor`, `thickness`, `radius`, `minThumbLength` and
// `minOverscrollLength` directly, so no state subclass, no painter mutation
// and no theme caching are needed. Values resolve at build time through the
// four-leg resolver, so a preset switch repaints immediately.

import 'package:flutter/widgets.dart';

import '../../primitives/scroll_metrics.dart';
import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';
import 'scrollbar_style.dart';

export 'scrollbar_style.dart';

/// A scrollbar for the nearest scrollable of [child].
///
/// ```dart
/// Scrollbar(
///   thumbVisibility: true,
///   child: ListView(controller: controller, children: items),
/// );
/// ```
class Scrollbar extends StatelessWidget {
  /// Creates a scrollbar.
  const Scrollbar({
    super.key,
    required this.child,
    this.controller,
    this.thumbVisibility,
    this.trackVisibility,
    this.thickness,
    this.radius,
    this.minThumbLength,
    this.minOverscrollLength,
    this.color,
    this.interactive,
    this.notificationPredicate,
    this.scrollbarOrientation,
    this.theme,
  });

  /// The scrollable widget the scrollbar is stacked on.
  final Widget child;

  /// Controller of the scrollable; defaults to the primary controller.
  final ScrollController? controller;

  /// Whether the thumb is always visible.
  final bool? thumbVisibility;

  /// Whether the track is painted behind the thumb.
  final bool? trackVisibility;

  /// Thumb thickness override.
  final double? thickness;

  /// Thumb corner radius override.
  final Radius? radius;

  /// Minimum thumb length override.
  final double? minThumbLength;

  /// Minimum thumb length while dragged past an edge.
  final double? minOverscrollLength;

  /// Thumb colour override.
  final ThemedColor? color;

  /// Whether the thumb responds to drags; defaults to true.
  final bool? interactive;

  /// Which scroll notifications the scrollbar reacts to.
  final ScrollNotificationPredicate? notificationPredicate;

  /// Side of the scrollable the bar attaches to.
  final ScrollbarOrientation? scrollbarOrientation;

  /// Widget-leg style override, merged on top of the other resolver legs.
  final ScrollbarTheme? theme;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData ambient = ShadcnTheme.of(context);
    final ScrollbarTheme resolved =
        resolveComponentStyle<ScrollbarTheme, ScrollbarTheme>(
          context,
          widget: theme,
          select: (t) => t,
          defaults: scrollbarDefaults,
        );
    final Color thumbColor =
        (color ?? resolved.color)?.resolve(ambient.colors) ??
        ambient.colors.border;
    final double effectiveThickness =
        thickness ??
        resolved.thickness ??
        scrollbarDefaultThickness * ambient.scaling;
    final Radius effectiveRadius =
        radius ?? resolved.radius ?? Radius.circular(ambient.radiusSm);
    final double effectiveMinThumbLength =
        minThumbLength ?? resolved.minThumbLength ?? kMinScrollbarThumbExtent;
    final double? effectiveMinOverscrollLength =
        minOverscrollLength ?? resolved.minOverscrollLength;

    return RawScrollbar(
      controller: controller,
      thumbVisibility: thumbVisibility,
      trackVisibility: trackVisibility,
      thickness: effectiveThickness,
      radius: effectiveRadius,
      minThumbLength: effectiveMinThumbLength,
      minOverscrollLength: effectiveMinOverscrollLength,
      thumbColor: thumbColor,
      interactive: interactive ?? resolved.interactive,
      notificationPredicate:
          notificationPredicate ?? defaultScrollNotificationPredicate,
      scrollbarOrientation: scrollbarOrientation,
      child: child,
    );
  }
}
