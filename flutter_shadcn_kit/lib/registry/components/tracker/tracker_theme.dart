// User-owned overrides for the `tracker` component theme.
//
// Values only: CLI updates never overwrite this file and Studio rewrites it
// deterministically. Unset fields fall through to `trackerDefaults` and the
// global tokens, so an empty override keeps the exact token look.
//
// Sparse example (uncomment and complete to customise the segments):
//
//   const TrackerTheme trackerThemeOverrides = TrackerTheme(
//     fine: ThemedColor.ref(ColorRef.chart2),
//     itemHeight: 24,
//   );

import 'tracker_style.dart';

/// Tracker overrides applied app-wide through `ComponentThemes`.
const TrackerTheme trackerThemeOverrides = TrackerTheme();
