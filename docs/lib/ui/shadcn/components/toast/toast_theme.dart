// User-owned overrides for the `toast` component theme.
//
// Values only: CLI updates never overwrite this file and Studio rewrites it
// deterministically. Unset fields fall through to `toastDefaults` and the
// global tokens, so an empty override keeps the exact token look.
//
// Sparse example (uncomment and complete to customise the cards):
//
//   const ToastTheme toastThemeOverrides = ToastTheme(
//     maxWidth: 420,
//     showCloseButton: false,
//     pauseOnHover: true,
//   );

import 'package:flutter/widgets.dart';

import 'toast_style.dart';

/// Toast overrides applied app-wide through `ComponentThemes`.
const ToastTheme toastThemeOverrides = ToastTheme();
