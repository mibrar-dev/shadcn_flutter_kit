// User-owned overrides for the `command` component theme.
//
// Values only: CLI updates never overwrite this file and Studio rewrites it
// deterministically. Unset fields fall through to `commandDefaults` and the
// global tokens, so an empty override keeps the exact token look.

import 'package:flutter/widgets.dart';

import 'command_style.dart';

/// Command palette overrides applied app-wide through `ComponentThemes`.
const CommandTheme commandThemeOverrides = CommandTheme();
