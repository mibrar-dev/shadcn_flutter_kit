// The `steps` component: a vertical sequence of numbered steps joined by a
// connector line.
//
// Ported from `components/layout/steps`. The old tree imported
// `package:flutter/material.dart` only for `VerticalDivider`; the connector is
// now a plain sized box. The trailing connector under the last step is no
// longer drawn (old bug).

import 'package:flutter/widgets.dart';

import '../../primitives/text/text_extension.dart';
import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';
import 'steps_style.dart';

export 'steps_style.dart';

/// A vertical step list with numbered indicators and connectors.
///
/// Each child is one step; the number is derived from its position.
///
/// ```dart
/// Steps(
///   children: <Widget>[
///     StepItem(title: const Text('Account'), content: const [Text('Email')]),
///     StepItem(title: const Text('Profile'), content: const [Text('Name')]),
///   ],
/// );
/// ```
class Steps extends StatelessWidget {
  /// Creates a steps list.
  const Steps({super.key, required this.children, this.theme});

  /// One widget per step, top to bottom.
  final List<Widget> children;

  /// Widget-leg theme override, merged on top of the other legs.
  final StepsTheme? theme;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData ambient = ShadcnTheme.of(context);
    final StepsTheme style = resolveComponentStyle<StepsTheme, StepsTheme>(
      context,
      widget: theme,
      select: (t) => t,
      defaults: stepsDefaults,
    );
    final double scaling = ambient.scaling;
    final double indicatorSize = (style.indicatorSize ?? 28) * scaling;
    final double spacing = (style.spacing ?? 18) * scaling;
    final double thickness = (style.connectorThickness ?? 1) * scaling;
    final double bottomPadding =
        ambient.density.baseContainerPadding * scaling * 2;

    final List<Widget> rows = <Widget>[];
    for (var i = 0; i < children.length; i++) {
      rows.add(
        _StepRow(
          index: i,
          isLast: i == children.length - 1,
          indicatorSize: indicatorSize,
          spacing: spacing,
          thickness: thickness,
          bottomPadding: bottomPadding,
          indicatorColor: style.indicatorColor,
          indicatorForeground: style.indicatorForeground,
          connectorColor: style.connectorColor,
          child: children[i],
        ),
      );
    }

    return IntrinsicWidth(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: rows,
      ),
    );
  }
}

/// One numbered step: the indicator column plus the step content.
class _StepRow extends StatelessWidget {
  const _StepRow({
    required this.index,
    required this.isLast,
    required this.indicatorSize,
    required this.spacing,
    required this.thickness,
    required this.bottomPadding,
    required this.indicatorColor,
    required this.indicatorForeground,
    required this.connectorColor,
    required this.child,
  });

  final int index;
  final bool isLast;
  final double indicatorSize;
  final double spacing;
  final double thickness;
  final double bottomPadding;
  final ThemedColor? indicatorColor;
  final ThemedColor? indicatorForeground;
  final ThemedColor? connectorColor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData ambient = ShadcnTheme.of(context);
    final ShadcnColors colors = ambient.colors;
    final Color fill = indicatorColor?.resolve(colors) ?? colors.muted;
    final Color numberColor =
        indicatorForeground?.resolve(colors) ?? colors.foreground;
    final Color connector = connectorColor?.resolve(colors) ?? colors.muted;
    final double halfGap = 4 * ambient.scaling;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Column(
            children: <Widget>[
              DecoratedBox(
                decoration: BoxDecoration(color: fill, shape: BoxShape.circle),
                child: SizedBox.square(
                  dimension: indicatorSize,
                  child: Center(
                    child: Text(
                      '${index + 1}',
                    ).mono.bold.call(color: numberColor),
                  ),
                ),
              ),
              if (!isLast) ...<Widget>[
                SizedBox(height: halfGap),
                Expanded(
                  child: SizedBox(
                    width: thickness,
                    child: ColoredBox(color: connector),
                  ),
                ),
                SizedBox(height: halfGap),
              ],
            ],
          ),
          SizedBox(width: spacing),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : bottomPadding),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}

/// A step's title plus its content rows.
class StepItem extends StatelessWidget {
  /// Creates a step item.
  const StepItem({super.key, required this.title, required this.content});

  /// The step title, rendered as a level-4 heading.
  final Widget title;

  /// Content rows shown under the title.
  final List<Widget> content;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[title.h4(), ...content],
    );
  }
}
