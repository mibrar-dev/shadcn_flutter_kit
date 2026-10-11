// Named examples for the `tracker` component (P6-F3 preview contract).
//
// One focused demo per example; the first entry is the default. Spacing comes
// from the ambient theme, so the examples follow the selected preset and the
// site light/dark toggle.

import 'package:flutter/widgets.dart';

import '../../foundation/component_preview.dart';
import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';
import 'tracker.dart';

/// All four levels.
Widget _default(BuildContext context) {
  return const SizedBox(
    width: 320,
    child: Tracker(
      data: <TrackerData>[
        TrackerData(tooltip: Text('Healthy'), level: TrackerLevel.fine),
        TrackerData(tooltip: Text('Degraded'), level: TrackerLevel.warning),
        TrackerData(tooltip: Text('Down'), level: TrackerLevel.critical),
        TrackerData(tooltip: Text('No data'), level: TrackerLevel.unknown),
        TrackerData(tooltip: Text('Healthy'), level: TrackerLevel.fine),
        TrackerData(tooltip: Text('Healthy'), level: TrackerLevel.fine),
      ],
    ),
  );
}

/// Taller segments with a wider gap through the widget leg.
Widget _customSize(BuildContext context) {
  return const SizedBox(
    width: 320,
    child: Tracker(
      theme: TrackerTheme(itemHeight: 24, gap: 4, radius: 4),
      data: <TrackerData>[
        TrackerData(tooltip: Text('One'), level: TrackerLevel.fine),
        TrackerData(tooltip: Text('Two'), level: TrackerLevel.critical),
        TrackerData(tooltip: Text('Three'), level: TrackerLevel.warning),
      ],
    ),
  );
}

/// Fine segments tinted with the primary token through a scoped theme.
Widget _themed(BuildContext context) {
  return const SizedBox(
    width: 320,
    child: ComponentTheme<TrackerTheme>(
      data: TrackerTheme(
        fine: ThemedColor.ref(ColorRef.primary),
        itemHeight: 16,
      ),
      child: Tracker(
        data: <TrackerData>[
          TrackerData(tooltip: Text('One'), level: TrackerLevel.fine),
          TrackerData(tooltip: Text('Two'), level: TrackerLevel.fine),
          TrackerData(tooltip: Text('Three'), level: TrackerLevel.fine),
        ],
      ),
    ),
  );
}

/// Named docs examples for `tracker`; the first entry is the default.
const List<ComponentPreview> trackerPreviews = <ComponentPreview>[
  ComponentPreview('Default', _default),
  ComponentPreview('Custom size', _customSize),
  ComponentPreview('Themed', _themed),
];
