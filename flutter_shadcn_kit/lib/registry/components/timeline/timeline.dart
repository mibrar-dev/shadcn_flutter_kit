// The `timeline` component: a vertical three-column event timeline (time,
// indicator + connector, title/content).
//
// Widgets-only: the old Material `VerticalDivider` connector is replaced by a
// plain painted `Container`, and the text styling comes from the
// `primitives/text` fluent modifiers instead of the old `display/text`
// component.

import 'package:flutter/widgets.dart';

import '../../foundation/gap.dart';
import '../../primitives/text/text_extension.dart';
import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';
import 'timeline_style.dart';

export 'timeline_style.dart';

/// One row of a [Timeline].
class TimelineData {
  /// Creates one timeline entry.
  const TimelineData({
    required this.time,
    required this.title,
    this.content,
    this.color,
  });

  /// Time/label column, right aligned above the indicator.
  final Widget time;

  /// Main heading of the entry.
  final Widget title;

  /// Optional detail under [title].
  final Widget? content;

  /// Per-entry indicator/connector colour; null uses [TimelineTheme.color].
  final ThemedColor? color;
}

/// A vertical timeline of chronological entries.
///
/// ```dart
/// Timeline(
///   data: [
///     TimelineData(
///       time: Text('09:00'),
///       title: Text('Kickoff'),
///       content: Text('Project kickoff meeting.'),
///     ),
///   ],
/// );
/// ```
class Timeline extends StatelessWidget {
  /// Creates a timeline from [data].
  const Timeline({
    super.key,
    required this.data,
    this.timeConstraints,
    this.theme,
  });

  /// Entries rendered top to bottom.
  final List<TimelineData> data;

  /// Widget-leg width of the time column; null uses [TimelineTheme.timeConstraints]
  /// or the `120 * scaling` default.
  final BoxConstraints? timeConstraints;

  /// Widget-leg theme override, merged on top of the other legs.
  final TimelineTheme? theme;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData shadcn = ShadcnTheme.of(context);
    final TimelineSurface surface = resolveTimelineSurface(
      context,
      widgetTheme: theme,
      timeConstraints: timeConstraints,
    );
    final List<Widget> rows = <Widget>[];
    for (var i = 0; i < data.length; i++) {
      if (i > 0) {
        rows.add(Gap(surface.rowGap));
      }
      rows.add(
        _TimelineRow(
          entry: data[i],
          last: i == data.length - 1,
          surface: surface,
          shadcn: shadcn,
        ),
      );
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: rows,
    );
  }
}

/// One `time | indicator | content` row.
class _TimelineRow extends StatelessWidget {
  const _TimelineRow({
    required this.entry,
    required this.last,
    required this.surface,
    required this.shadcn,
  });

  /// The entry rendered.
  final TimelineData entry;

  /// Whether this is the final row (no connector below the dot).
  final bool last;

  /// Resolved geometry/colours.
  final TimelineSurface surface;

  /// Ambient theme (dot offset + scaling).
  final ShadcnThemeData shadcn;

  @override
  Widget build(BuildContext context) {
    final Color color = surface.indicatorFor(entry.color);
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          ConstrainedBox(
            constraints: surface.timeConstraints,
            child: Align(
              // Directional (P7-Q2): hugs the spine in both directions.
              alignment: AlignmentDirectional.topEnd,
              child: entry.time.medium.small,
            ),
          ),
          Gap(surface.spacing),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _TimelineDot(
                color: color,
                size: surface.dotSize,
                rounded: shadcn.radius != 0,
                topMargin: shadcn.density.baseGap * shadcn.scaling * 0.5,
              ),
              if (!last)
                Expanded(
                  child: Center(
                    widthFactor: 1,
                    child: ColoredBox(
                      color: color,
                      child: SizedBox(
                        width: surface.connectorThickness,
                        height: double.infinity,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          Gap(surface.spacing),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  // Directional (P7-Q2): the nudge toward the spine mirrors.
                  padding: EdgeInsetsDirectional.only(
                    start: surface.contentStart,
                  ),
                  child: entry.title.semiBold.secondaryForeground.base,
                ),
                if (entry.content != null) Gap(surface.spacing),
                if (entry.content != null)
                  Padding(
                    padding: EdgeInsetsDirectional.only(
                      start: surface.contentStart,
                    ),
                    child: entry.content!.muted.small,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// The indicator: a circle (or a square when the theme radius is `0`).
class _TimelineDot extends StatelessWidget {
  const _TimelineDot({
    required this.color,
    required this.size,
    required this.rounded,
    this.topMargin = 0,
  });

  /// Fill colour.
  final Color color;

  /// Edge length.
  final double size;

  /// Whether the dot is a circle rather than a square.
  final bool rounded;

  /// Space above the dot inside its column.
  final double topMargin;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: topMargin),
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: rounded ? BoxShape.circle : BoxShape.rectangle,
        color: color,
      ),
    );
  }
}
