// User-owned overrides for the `input_otp` component theme.
//
// Values only: CLI updates never overwrite this file and Studio rewrites it
// deterministically. Unset fields fall through to `inputOtpDefaults` and the
// global tokens, so an empty override keeps the exact token look.
//
//   const InputOtpTheme inputOtpThemeOverrides = InputOtpTheme(
//     boxSize: 48,
//     spacing: 12,
//     borderRadius: BorderRadius.all(Radius.circular(12)),
//   );

import 'input_otp_style.dart';

/// Per-component overrides applied app-wide through `ComponentThemes`.
const InputOtpTheme inputOtpThemeOverrides = InputOtpTheme();
