// User-owned overrides for the `history` component theme.
//
// Values only: CLI updates never overwrite this file and Studio rewrites it
// deterministically. Unset fields fall through to `historyDefaults` and the
// global tokens, so an empty override keeps the exact token look.
//
//   const HistoryTheme historyThemeOverrides = HistoryTheme(
//     selectedBorderWidth: 3,
//     spacing: 8,
//   );

import 'history_style.dart';

/// App-wide history overrides applied through `ComponentThemes`.
const HistoryTheme historyThemeOverrides = HistoryTheme();
