// Gallery preview for the `timeline` component.
//
// Widgets-only: token entries, per-entry colours, a custom time-column width
// and a scoped `ComponentTheme<TimelineTheme>` leg.

import 'package:flutter/widgets.dart';

import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';
import 'timeline.dart';

/// Preview entry point used by the docs gallery.
class TimelinePreview extends StatelessWidget {
  /// Creates the preview.
  const TimelinePreview({super.key});

  @override
  Widget build(BuildContext context) {
    return const ShadcnTheme(
      data: ShadcnThemeData(),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: _TimelinePreviewBody(),
      ),
    );
  }
}

class _TimelinePreviewBody extends StatelessWidget {
  const _TimelinePreviewBody();

  @override
  Widget build(BuildContext context) {
    final ShadcnColors colors = ShadcnTheme.of(context).colors;
    return ColoredBox(
      color: colors.background,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Timeline(
                data: <TimelineData>[
                  TimelineData(
                    time: Text('09:00'),
                    title: Text('Kickoff'),
                    content: Text('Project kickoff meeting.'),
                  ),
                  TimelineData(
                    time: Text('11:00'),
                    title: Text('Design review'),
                    content: Text('Review the first concept batch.'),
                    color: ThemedColor.value(Color(0xFFE7000B)),
                  ),
                  TimelineData(
                    time: Text('14:30'),
                    title: Text('Delivery'),
                    content: Text('Share the final assets.'),
                  ),
                ],
              ),
              SizedBox(height: ShadcnTheme.of(context).spacing.xxl),
              ComponentTheme<TimelineTheme>(
                data: const TimelineTheme(
                  dotSize: 8,
                  connectorThickness: 1,
                  rowGap: 8,
                  color: ThemedColor.ref(ColorRef.accent),
                ),
                child: const Timeline(
                  timeConstraints: BoxConstraints(minWidth: 72, maxWidth: 72),
                  data: <TimelineData>[
                    TimelineData(time: Text('Mon'), title: Text('Compact')),
                    TimelineData(time: Text('Tue'), title: Text('scoped leg')),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
