// User-owned overrides for the `stage_container` component theme.
//
// Values only: CLI updates never overwrite this file and Studio rewrites it
// deterministically. Unset fields fall through to `stageContainerDefaults`
// and the global tokens, so an empty override keeps the exact default look.
//
// Sparse example (uncomment and complete to customise the stage):
//
//   const StageContainerTheme stageContainerThemeOverrides =
//       StageContainerTheme(
//         breakpoint: ConstantBreakpoint(120),
//         padding: EdgeInsets.symmetric(horizontal: 32),
//       );

import 'stage_container_style.dart';

/// Stage overrides applied app-wide through `ComponentThemes`.
const StageContainerTheme stageContainerThemeOverrides = StageContainerTheme();
