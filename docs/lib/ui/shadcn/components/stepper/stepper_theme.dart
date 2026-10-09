// User-owned overrides for the `stepper` component theme.
//
// Values only: CLI updates never overwrite this file and Studio rewrites it
// deterministically. Unset fields fall through to `stepperDefaults` and the
// global tokens, so an empty override keeps the exact token look.
//
// Sparse example (uncomment and complete to customise the indicators):
//
//   const StepperTheme stepperThemeOverrides = StepperTheme(
//     connectorColor: ThemedColor.ref(ColorRef.accent),
//     active: StepperIndicatorStyle(
//       background: ThemedColor.ref(ColorRef.accent, alpha: 0.2),
//       borderColor: ThemedColor.ref(ColorRef.accent),
//     ),
//   );

import 'stepper_style.dart';

/// Stepper overrides applied app-wide through `ComponentThemes`.
const StepperTheme stepperThemeOverrides = StepperTheme();
