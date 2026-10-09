// User-owned overrides for the `checkbox` component theme.
//
// Values only: CLI updates never overwrite this file and Studio rewrites it
// deterministically. Unset fields fall through to `checkboxDefaults` and the
// global tokens, so an empty override keeps the exact token look.
//
// Sparse example (uncomment and complete to customise a value):
//
//   const CheckboxTheme checkboxThemeOverrides = CheckboxTheme(
//     unchecked: CheckboxStyle(
//       background: StateValue(rest: ThemedColor.ref(ColorRef.muted, alpha: 0.4)),
//       borderColor: StateValue(rest: ThemedColor.ref(ColorRef.ring)),
//     ),
//   );

import 'checkbox_style.dart';

/// Per-value overrides applied app-wide through `ComponentThemes`.
const CheckboxTheme checkboxThemeOverrides = CheckboxTheme();
