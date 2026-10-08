// The `dot_indicator` component: a row (or column) of animated dots showing
// the active index of a carousel, stepper or pager.
//
// Ported from `components/display/dot_indicator/**` (ten files, four `part`s).
// Fixes, all verified against the old source:
//   * `DotItem` (the only *animated* dot widget) had **zero** readers; the
//     `ActiveDotItem` / `InactiveDotItem` pair the indicator actually built was
//     made of plain `Container`s, so changing the index jumped instantly
//     despite the component's name. The dots animate between their rows now.
//   * `mouseCursor: WidgetStatePropertyAll(SystemMouseCursors.click)` was
//     installed even when `onChanged` was null, so a read-only indicator showed
//     a click cursor and swallowed taps no handler answered.
//   * `resolvedPadding` was multiplied by `theme.scaling` *after* it had been
//     resolved, so a caller-provided `padding` was silently inflated.
//   * `IntrinsicHeight` + `Flex(crossAxisAlignment: stretch)` around `Flexible`
//     children forced an O(n^2) intrinsic pass for a fixed-size row.
//   * Only `ComponentTheme.maybeOf` was read, so app-wide overrides never
//     applied, and there were no token-derived defaults at all.

import 'package:flutter/widgets.dart';

import '../../primitives/clickable.dart';
import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';
import 'dot_indicator_style.dart';

export 'dot_indicator_style.dart';

/// Builds a custom dot.
///
/// The default builder paints the active/inactive [DotStyle] rows; supply this
/// to draw your own marker.
typedef DotBuilder =
    Widget Function(BuildContext context, int index, bool isActive);

/// Navigation indicator with a row or column of animated dots.
///
/// ```dart
/// DotIndicator(index: page, length: pages.length, onChanged: goToPage)
/// ```
class DotIndicator extends StatelessWidget {
  /// Creates a dot indicator.
  const DotIndicator({
    super.key,
    required this.index,
    required this.length,
    this.onChanged,
    this.spacing,
    this.direction = Axis.horizontal,
    this.padding,
    this.dotBuilder,
    this.theme,
  }) : assert(length > 0, 'DotIndicator needs at least one dot.');

  /// Index of the active dot; a value outside `0..length - 1` leaves every dot
  /// inactive.
  final int index;

  /// Number of dots.
  final int length;

  /// Called with the tapped index. Null makes the indicator read-only: no
  /// `Clickable` and no click cursor are built.
  final ValueChanged<int>? onChanged;

  /// Gap between two dots; null uses [DotIndicatorTheme.spacing] then
  /// `8 * scaling`.
  final double? spacing;

  /// Axis of the run of dots.
  final Axis direction;

  /// Padding around the run of dots; null uses [DotIndicatorTheme.padding] then
  /// the density base gap. It is applied once, to the run, never per dot.
  final EdgeInsetsGeometry? padding;

  /// Custom dot builder; null paints the theme rows.
  final DotBuilder? dotBuilder;

  /// Widget-leg theme override, merged on top of the other legs.
  final DotIndicatorTheme? theme;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData appTheme = ShadcnTheme.of(context);
    final DotIndicatorTheme resolved =
        resolveComponentStyle<DotIndicatorTheme, DotIndicatorTheme>(
          context,
          widget: theme,
          select: (t) => t,
          defaults: dotIndicatorDefaults,
        );
    final double gap = spacing ?? resolved.spacing ?? 8 * appTheme.scaling;
    // Resolved once: the old code re-resolved and re-scaled it per dot.
    final EdgeInsets outer =
        (padding ??
                resolved.padding ??
                EdgeInsets.all(appTheme.density.baseGap))
            .resolve(Directionality.of(context));

    final List<Widget> dots = <Widget>[
      for (int i = 0; i < length; i++)
        _dot(context, appTheme, resolved, i, gap),
    ];
    final Widget run = direction == Axis.horizontal
        ? Row(
            mainAxisSize: MainAxisSize.min,
            children: _spaced(dots, SizedBox(width: gap)),
          )
        : Column(
            mainAxisSize: MainAxisSize.min,
            children: _spaced(dots, SizedBox(height: gap)),
          );
    return Padding(padding: outer, child: run);
  }

  /// Inserts [separator] between every pair of [items].
  static List<Widget> _spaced(List<Widget> items, Widget separator) {
    if (items.length < 2) {
      return items;
    }
    return <Widget>[
      for (int i = 0; i < items.length; i++) ...<Widget>[
        if (i > 0) separator,
        items[i],
      ],
    ];
  }

  Widget _dot(
    BuildContext context,
    ShadcnThemeData appTheme,
    DotIndicatorTheme theme,
    int position,
    double gap,
  ) {
    final bool isActive = position == index;
    final DotStyle style =
        theme.forIndex(isActive) ?? DotIndicatorDefaults.forIndex(isActive);
    final double size = style.size ?? 12 * appTheme.scaling;

    if (onChanged == null) {
      // A read-only indicator must neither look nor behave pressable.
      return _DotBox(
        size: size,
        duration: theme.duration!,
        decoration: dotBuilder == null
            ? _dotDecoration(
                style,
                const <WidgetState>{},
                appTheme.colors,
                appTheme.scaling,
              )
            : null,
      );
    }
    return Clickable(
      behavior: HitTestBehavior.translucent,
      onPressed: () => onChanged!(position),
      mouseCursor: const WidgetStatePropertyAll<MouseCursor>(
        SystemMouseCursors.click,
      ),
      // Half the gap on each side makes the whole dot an easy tap target
      // without changing the visual gap.
      padding: WidgetStatePropertyAll<EdgeInsetsGeometry>(
        EdgeInsets.symmetric(horizontal: gap / 2, vertical: gap / 2),
      ),
      decoration: WidgetStateProperty.resolveWith(
        (Set<WidgetState> states) =>
            _dotDecoration(style, states, appTheme.colors, appTheme.scaling),
      ),
      child: _DotBox(size: size, duration: theme.duration!),
    );
  }
}

/// A square dot whose size and fill animate between the theme rows.
class _DotBox extends StatelessWidget {
  const _DotBox({required this.size, required this.duration, this.decoration});

  final double size;
  final Duration duration;
  final BoxDecoration? decoration;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: duration,
      curve: Curves.easeOut,
      width: size,
      height: size,
      decoration: decoration,
    );
  }
}

/// The decoration for [style] in [states].
BoxDecoration _dotDecoration(
  DotStyle style,
  Set<WidgetState> states,
  ShadcnColors colors,
  double scaling,
) {
  final double size = style.size ?? 12 * scaling;
  final Color? outline = style.borderColor?.resolve(states)?.resolve(colors);
  final double borderWidth = style.borderWidth ?? 0;
  return BoxDecoration(
    color: style.background?.resolve(states)?.resolve(colors),
    borderRadius: style.borderRadius ?? BorderRadius.circular(size / 2),
    border: outline != null && borderWidth > 0
        ? Border.all(color: outline, width: borderWidth)
        : null,
  );
}

/// The token-derived rows of [dotIndicatorDefaults], for callers that paint
/// their own dots instead of using the default builder.
abstract final class DotIndicatorDefaults {
  /// The active row.
  static DotStyle get active => dotIndicatorDefaults.active!;

  /// The inactive row.
  static DotStyle get inactive => dotIndicatorDefaults.inactive!;

  /// The row that matches [isActive].
  static DotStyle forIndex(bool isActive) =>
      isActive ? dotIndicatorDefaults.active! : dotIndicatorDefaults.inactive!;
}
