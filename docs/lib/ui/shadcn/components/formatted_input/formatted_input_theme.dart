// User-owned overrides for the `formatted_input` component theme.
//
// Values only: CLI updates never overwrite this file and Studio rewrites it
// deterministically. Unset fields fall through to `formattedInputDefaults`
// and the global tokens, so an empty override keeps the exact token look.
//
// Sparse example (uncomment and complete to customise the field):
//
//   const FormattedInputTheme formattedInputThemeOverrides =
//       FormattedInputTheme(
//     background: ThemedColor.ref(ColorRef.accent, alpha: 0.2),
//     height: 40,
//     textStyle: TextStyle(letterSpacing: 1.2),
//   );

import 'formatted_input_style.dart';

/// Formatted input overrides applied app-wide through `ComponentThemes`.
const FormattedInputTheme formattedInputThemeOverrides = FormattedInputTheme();
