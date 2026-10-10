// Named examples for the `timeline` component (P6-F3 preview contract).
//
// One focused demo per example; the first entry is the default. Spacing comes
// from the ambient theme, so the examples follow the selected preset and the
// site light/dark toggle.

import 'package:flutter/widgets.dart';

import '../../foundation/component_preview.dart';
import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';
import 'timeline.dart';

/// Three entries with times, titles and content.
Widget _default(BuildContext context) {
  return ConstrainedBox(
    constraints: const BoxConstraints(maxWidth: 400),
    child: const Timeline(
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
        ),
        TimelineData(
          time: Text('14:30'),
          title: Text('Delivery'),
          content: Text('Share the final assets.'),
        ),
      ],
    ),
  );
}

/// Smaller dots and a narrower time column through a scoped theme.
Widget _compact(BuildContext context) {
  return ConstrainedBox(
    constraints: const BoxConstraints(maxWidth: 400),
    child: const ComponentTheme<TimelineTheme>(
      data: TimelineTheme(
        dotSize: 8,
        connectorThickness: 1,
        rowGap: 8,
        color: ThemedColor.ref(ColorRef.accent),
      ),
      child: Timeline(
        timeConstraints: BoxConstraints(minWidth: 72, maxWidth: 72),
        data: <TimelineData>[
          TimelineData(time: Text('Mon'), title: Text('Compact')),
          TimelineData(time: Text('Tue'), title: Text('scoped leg')),
        ],
      ),
    ),
  );
}

/// Named docs examples for `timeline`; the first entry is the default.
const List<ComponentPreview> timelinePreviews = <ComponentPreview>[
  ComponentPreview('Default', _default),
  ComponentPreview('Compact', _compact),
];
