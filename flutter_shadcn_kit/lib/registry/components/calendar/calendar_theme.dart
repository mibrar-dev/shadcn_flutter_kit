// User-owned overrides for the `calendar` component theme.
//
// Values only: CLI updates never overwrite this file and Studio rewrites it
// deterministically. Unset fields fall through to `calendarDefaults` and the
// global tokens, so an empty override keeps the exact token look.
//
//   const CalendarTheme calendarThemeOverrides = CalendarTheme(
//     cellHeight: 40,
//     gap: 8,
//     cellBorderRadius: BorderRadius.all(Radius.circular(20)),
//   );

import 'calendar_style.dart';

/// Per-component overrides applied app-wide through `ComponentThemes`.
const CalendarTheme calendarThemeOverrides = CalendarTheme();
