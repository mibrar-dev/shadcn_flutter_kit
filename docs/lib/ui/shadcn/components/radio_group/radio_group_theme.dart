// User-owned overrides for the `radio_group` component theme.
//
// Values only: CLI updates never overwrite this file and Studio rewrites it
// deterministically. Unset fields fall through to `radioGroupDefaults` and the
// global tokens, so an empty override keeps the exact token look.
//
// Sparse example (uncomment and complete to restyle the checked circle):
//
//   const RadioGroupTheme radioGroupThemeOverrides = RadioGroupTheme(
//     items: SelectableRadioTheme(
//       selected: RadioIndicatorStyle(
//         dotColor: ThemedColor.ref(ColorRef.accentForeground),
//         size: 20,
//       ),
//     ),
//   );

import 'package:flutter/widgets.dart';

import 'radio_group_style.dart';

/// Radio-group overrides applied app-wide through `ComponentThemes`.
const RadioGroupTheme radioGroupThemeOverrides = RadioGroupTheme();
