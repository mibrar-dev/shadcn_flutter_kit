// User-owned overrides for the `timeline` component theme.
//
// Values only: CLI updates never overwrite this file and Studio rewrites it
// deterministically. Unset fields fall through to `timelineDefaults` and the
// global tokens, so an empty override keeps the exact token look.
//
// Sparse example (uncomment and complete to customise the timeline):
//
//   const TimelineTheme timelineThemeOverrides = TimelineTheme(
//     color: ThemedColor.ref(ColorRef.accent),
//     dotSize: 16,
//     rowGap: 24,
//   );

import 'timeline_style.dart';

/// Overrides applied app-wide through `ComponentThemes`.
const TimelineTheme timelineThemeOverrides = TimelineTheme();
