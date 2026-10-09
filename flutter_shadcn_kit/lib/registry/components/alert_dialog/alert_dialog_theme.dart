// User-owned overrides for the `alert_dialog` component theme.
//
// Values only: CLI updates never overwrite this file and Studio rewrites it
// deterministically. Unset fields fall through to `alertDialogDefaults` and
// the global tokens, so an empty override keeps the exact token look.
//
// Sparse example (uncomment and complete to customise the header):
//
//   const AlertDialogTheme alertDialogThemeOverrides = AlertDialogTheme(
//     iconColor: ThemedColor.ref(ColorRef.destructive),
//     iconGap: 12,
//   );

import 'alert_dialog_style.dart';

/// Header/footer overrides applied app-wide through `ComponentThemes`.
const AlertDialogTheme alertDialogThemeOverrides = AlertDialogTheme();
