# KeyboardShortcut

Renders a keyboard shortcut as a row of small key caps — from explicit keys or
straight from a `ShortcutActivator`. Widgets-only.

## When to use

- A hint row under a search field or a command trigger.
- A trailing hint inside a `menu` item or a `tooltip`.

For a live, focus-following hint use the `command` component instead: it drives
its own keyboard handling.

## Snippets

From an activator (modifiers first, in the order they are held):

```dart
KeyboardShortcut.fromActivator(
  activator: const SingleActivator(LogicalKeyboardKey.keyK, meta: true),
);
```

Explicit keys, in the order you want them shown:

```dart
KeyboardShortcut(
  keys: const <LogicalKeyboardKey>[
    LogicalKeyboardKey.control,
    LogicalKeyboardKey.shift,
    LogicalKeyboardKey.keyP,
  ],
);
```

One key on its own:

```dart
KeyboardKeyCap(keyboardKey: LogicalKeyboardKey.enter)
```

## `KeyboardShortcut` API

| Parameter | Type | Default | Notes |
|---|---|---|---|
| `keys` | `List<LogicalKeyboardKey>` | — | `.fromActivator` instead |
| `activator` | `ShortcutActivator` | — | `.fromActivator` instead |
| `spacing` | `double?` | null | null = the theme's (2) |
| `theme` | `KeyboardShortcutTheme?` | null | widget leg, applied to every cap |

`KeyboardKeyCap(keyboardKey:, padding:, background:, foreground:, borderRadius:,
shadows:, theme:)` — the per-key widget, with a field-level override for each
theme field.

## Key labels

Without any setup a cap shows the platform glyph: `Ctrl`, `Shift`, `Alt`, `⌘`,
`↵`, `Esc`, `←` `→` `↑` `↓`, and Flutter's own `keyLabel` for everything else.

To label keys your way, install one scope near the app root:

```dart
KeyboardShortcutDisplayScope(
  builder: (context, key) => Text(key.keyLabel.toUpperCase()),
  child: myApp,
);
```

The scope is **optional** — a cap outside one falls back to
`defaultKeyboardKeyLabel`. Nothing throws if you never install it.

These labels are deliberately not localized copy: a shortcut has to read the
same on every keyboard the user is on.

## Theme resolution

`widget theme > ComponentTheme<KeyboardShortcutTheme> in tree > app overrides
(keyboard_shortcut_theme.dart) > keyboardShortcutDefaults`, merged per field.

| `KeyboardShortcutTheme` field | Default |
|---|---|
| `spacing` | 2 (shadcn `gap-0.5`) |
| `keyPadding` | `EdgeInsets.symmetric(horizontal: 6, vertical: 4)` (shadcn `px-1.5 py-0.5`) |
| `keyBackground` | `background` at 70% alpha, computed at build |
| `keyForeground` | `mutedForeground` |
| `keyBorderRadius` | the ambient `radiusMd` |
| `keyTextStyle` | `TextStyle(fontSize: 12, fontWeight: w500)` (shadcn `text-xs`) |
| `keyShadows` | none (the shadcn look) |

Only `spacing` is multiplied by `theme.scaling`; a key cap's size is a fixed
readability floor, so scaling it would make a 12 px label a 24 px one.

## Differences from the old `display/keyboard_shortcut`

- `KeyboardDisplay` / `KeyboardKeyDisplay` are now `KeyboardShortcut` /
  `KeyboardKeyCap`, matching the component id — "display" described no
  behaviour.
- `KeyboardShortcutDisplayMapper` (a `StatefulWidget` whose state only cached a
  handle) is now `KeyboardShortcutDisplayScope`, a stateless `Data` provider,
  and it takes a nullable builder.
- The component's `KeyboardShortcutDisplayBuilder`,
  `KeyboardShortcutDisplayHandle` and `shortcutActivatorToKeySet` copies are
  gone; all three are already owned by `foundation/keyboard.dart`.
- `KeyboardShortcutTheme.copyWith` is gone: the four-leg resolver already
  merges per field, so a hand-rolled copy was a second, subtly different merge.

Fixed (not ported):

- `KeyboardKeyDisplay` called `Data.of<KeyboardShortcutDisplayHandle>(context)`,
  which asserts when no mapper is installed. Any app that used `KeyboardDisplay`
  without wrapping it in `KeyboardShortcutDisplayMapper` crashed on first
  render. The cap now falls back to `defaultKeyboardKeyLabel`.
- `KeyboardKeyDisplay` resolved its theme as
  `this.theme ?? ComponentTheme.maybeOf<KeyboardShortcutTheme>(context)`: the
  widget leg *replaced* the scoped leg instead of merging with it, and the app
  leg (`ComponentThemes`) was never consulted at all. The four-leg resolver
  runs now.
- `KeyboardShortcutTheme` had no `Mergeable`, so a leg that set only `spacing`
  dropped `keyPadding` and `keyShadow` on the floor.
- `KeyboardKeyDisplay` built `Card(padding:, fillColor:, filled:, boxShadow:)`,
  an API the accepted `Card` no longer has, so every cap crashed at runtime.
- `resolvedPadding * theme.scaling` scaled only the padding while the cap's own
  `borderRadius` and shadow stayed unscaled, so a scaled theme produced caps
  with the same rounding and more padding. Only `spacing` scales now.
- `keyShadow` defaulted to `null` but was still passed to `Card`, which is what
  made the old API crash even for the default theme.
