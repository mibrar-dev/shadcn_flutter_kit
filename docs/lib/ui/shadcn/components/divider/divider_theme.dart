// User-owned overrides for the `divider` component theme.
//
// Values only: CLI updates never overwrite this file and Studio rewrites it
// deterministically. Unset fields fall through to `dividerDefaults` and the
// global tokens, so an empty override keeps the exact token look.
//
// Sparse example (uncomment and complete to customise the rule):
//
//   const DividerTheme dividerThemeOverrides = DividerTheme(
//     color: ThemedColor.ref(ColorRef.input),
//     thickness: 2,
//   );

import 'divider_style.dart';

/// Rule overrides applied app-wide through `ComponentThemes`.
const DividerTheme dividerThemeOverrides = DividerTheme();
