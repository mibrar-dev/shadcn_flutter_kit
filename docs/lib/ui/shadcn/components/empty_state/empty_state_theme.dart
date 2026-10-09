// User-owned overrides for the `empty_state` component theme.
//
// Values only: CLI updates never overwrite this file and Studio rewrites it
// deterministically. Unset fields fall through to `emptyStateDefaults` and the
// global tokens, so an empty override keeps the exact token look.
//
// Sparse example (uncomment and complete to restyle the full-page scale):
//
//   const EmptyStateTheme emptyStateThemeOverrides = EmptyStateTheme(
//     iconContainerBackground: ThemedColor.ref(ColorRef.accent),
//     metrics: <EmptyStateSize, EmptyStateMetrics>{
//       EmptyStateSize.fullPage: EmptyStateMetrics(
//         iconSize: 48,
//         titleStyle: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
//         descriptionStyle: TextStyle(fontSize: 16, height: 1.4),
//         padding: EdgeInsets.all(40),
//         contentGap: 32,
//         titleGap: 12,
//         actionGap: 32,
//         actionSpacing: 12,
//         maxWidth: 640,
//         descriptionMaxWidth: 640,
//       ),
//     },
//   );

import 'package:flutter/widgets.dart';

import 'empty_state_style.dart';

/// Empty-state overrides applied app-wide through `ComponentThemes`.
const EmptyStateTheme emptyStateThemeOverrides = EmptyStateTheme();
