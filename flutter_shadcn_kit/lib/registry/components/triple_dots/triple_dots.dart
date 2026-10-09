// The `triple_dots` component: a small row (or column) of round dots.
//
// Ported from `components/display/triple_dots` (old `MoreDots`, renamed to
// the shadcn-style component name). Fixes the old default-colour crash: the
// old code read `DefaultTextStyle.style.color!` and threw when no explicit
// colour was installed; the dots now default to the `mutedForeground` token.

import 'package:flutter/widgets.dart';

import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';
import 'triple_dots_style.dart';

export 'triple_dots_style.dart';

/// A row or column of evenly spaced dots.
///
/// ```dart
/// const TripleDots();                       // horizontal, 3 dots
/// const TripleDots(count: 4, direction: Axis.vertical);
/// ```
class TripleDots extends StatelessWidget {
  /// Creates a dots widget.
  const TripleDots({
    super.key,
    this.count = 3,
    this.direction = Axis.horizontal,
    this.size,
    this.spacing,
    this.color,
    this.padding,
    this.theme,
  }) : assert(count > 0, 'TripleDots needs at least one dot');

  /// Number of dots.
  final int count;

  /// Layout direction of the dots.
  final Axis direction;

  /// Dot diameter override.
  final double? size;

  /// Gap between dots override.
  final double? spacing;

  /// Dot colour override.
  final Color? color;

  /// Padding around the whole run.
  final EdgeInsetsGeometry? padding;

  /// Widget-leg theme override, merged on top of the other legs.
  final TripleDotsTheme? theme;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData shadcnTheme = ShadcnTheme.of(context);
    final ShadcnColors colors = shadcnTheme.colors;
    final resolved = resolveComponentStyle<TripleDotsTheme, TripleDotsTheme>(
      context,
      widget: theme,
      select: (t) => t,
      defaults: tripleDotsDefaults,
    );
    final double effectiveSize =
        size ?? resolved.size ?? 4 * shadcnTheme.scaling;
    final double effectiveSpacing = spacing ?? resolved.spacing ?? 2;
    final Color effectiveColor =
        color ?? resolved.color?.resolve(colors) ?? colors.mutedForeground;

    final List<Widget> children = <Widget>[];
    for (var i = 0; i < count; i++) {
      children.add(
        DecoratedBox(
          decoration: BoxDecoration(
            color: effectiveColor,
            shape: BoxShape.circle,
          ),
          child: SizedBox.square(dimension: effectiveSize),
        ),
      );
      if (i < count - 1) {
        children.add(
          SizedBox(
            width: direction == Axis.horizontal ? effectiveSpacing : null,
            height: direction == Axis.vertical ? effectiveSpacing : null,
          ),
        );
      }
    }

    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: direction == Axis.horizontal
          ? Row(mainAxisSize: MainAxisSize.min, children: children)
          : Column(mainAxisSize: MainAxisSize.min, children: children),
    );
  }
}
