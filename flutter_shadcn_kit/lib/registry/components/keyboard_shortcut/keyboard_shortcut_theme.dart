// User-owned overrides for the `keyboard_shortcut` component theme.
//
// Values only: CLI updates never overwrite this file and Studio rewrites it
// deterministically. Unset fields fall through to `keyboardShortcutDefaults`
// and the global tokens, so an empty override keeps the exact token look.
//
// Sparse example (uncomment and complete to restyle the caps):
//
//   const KeyboardShortcutTheme keyboardShortcutThemeOverrides =
//       KeyboardShortcutTheme(
//         keyBackground: ThemedColor.ref(ColorRef.accent),
//         keyBorderRadius: BorderRadius.all(Radius.circular(4)),
//       );

import 'keyboard_shortcut_style.dart';

/// Keyboard-shortcut overrides applied app-wide through `ComponentThemes`.
const KeyboardShortcutTheme keyboardShortcutThemeOverrides =
    KeyboardShortcutTheme();
