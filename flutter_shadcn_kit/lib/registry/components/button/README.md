# Button

Pressable action control with seven variants and five fixed sizes, built on
the `Clickable` primitive (hover, press, keyboard, focus ring, semantics).
Widgets-only: no Material, no Cupertino, no component-to-component imports.

## When to use

- A one-shot action (`Save`, `Delete`, `Next`) that fires a callback.
- An inline link-styled action or a muted text action.
- Several connected actions — wrap them in `ButtonGroup`.

On/off state belongs to the separate `Toggle` component; navigation entries
belong to the navigation components.

## Snippets

Minimal:

```dart
Button(onPressed: save, child: const Text('Save'));
```

Variant, size and icon:

```dart
Button(
  variant: ButtonVariant.outline,
  size: ButtonSize.sm,
  leading: const Icon(LucideIcons.plus, size: 16),
  onPressed: addItem,
  child: const Text('Add item'),
);
```

Connected group (first/last keep their radius, inner edges flatten):

```dart
ButtonGroup(
  children: <Widget>[
    Button(variant: ButtonVariant.outline, onPressed: prev, child: const Text('Prev')),
    Button(variant: ButtonVariant.outline, onPressed: next, child: const Text('Next')),
  ],
);
```

## `Button` API

| Parameter | Type | Default | Notes |
|---|---|---|---|
| `child` | `Widget` | required | label or icon |
| `variant` | `ButtonVariant` | `primary` | `primary, secondary, outline, ghost, link, text, destructive` |
| `size` | `ButtonSize` | `md` | `xs, sm, md, lg, icon` (icon = square 36) |
| `onPressed` | `VoidCallback?` | null | null disables unless `enabled` is set |
| `onLongPress` | `VoidCallback?` | null | ignored while disabled |
| `onHover` / `onFocusChange` | `ValueChanged<bool>?` | null | observation only |
| `leading` / `trailing` | `Widget?` | null | auto-spaced with `theme.spacing.sm` |
| `focusNode` | `FocusNode?` | null | internal `Clickable` node when null |
| `autofocus` | `bool` | false | requests focus after the first frame |
| `enabled` | `bool?` | null | null means `onPressed != null` |
| `theme` | `ButtonVariantStyle?` | null | widget leg of the resolver |

Rare gestures (`onTapDown`, secondary/tertiary clicks) go through an outer
`GestureDetector`, per the new architecture's callback policy.

## Size table

| Size | Horizontal padding | Text | Min height |
|---|---|---|---|
| `xs` | 8 | 14 / w500 | 28 |
| `sm` | 12 | 14 / w500 | 32 |
| `md` | 16 | 14 / w500 | 36 |
| `lg` | 24 | 14 / w500 | 40 |
| `icon` | 0 | — | 36 x 36 |

Heights match shadcn `h-7`/`h-8`/`h-9`/`h-10`; the height comes from
`minHeight` (vertical padding is zero so outline borders do not inflate
it). All sizes use 14 / w500 text.

Global `Density.baseContentPadding` scales the padding; `ButtonTheme` may
override `padding` and `textStyle` per variant.

## Theme resolution

`widget (theme:) > ComponentTheme<ButtonTheme> in tree > app overrides
(button_theme.dart through ComponentThemes) > buttonDefaults`, merged per
field and per state with receiver-wins `Mergeable.merge`. Disabled is not a
colour row: every `StateValue` falls back to `rest` and the whole button is
drawn at `opacity 0.5` (shadcn `disabled:opacity-50`).

| `ButtonTheme` field | Default |
|---|---|
| `primary..destructive` | one `ButtonVariantStyle` row per variant (token refs only) |
| `background` | primary: `primary`, hover/press `primary@0.9`; secondary `@0.8`; outline `input@0.3/0.5`; ghost `muted@0/0.8`; destructive `destructive@0.9`; link/text none |
| `foreground` | primary/secondary/destructive use their `*Foreground`; outline/ghost/link `foreground`; text `mutedForeground`, hover `primary` |
| `borderColor` / `borderWidth` | outline: `input` / 1.0; others none |
| `decoration` | link: underline on hover/press |
| `padding` / `textStyle` | null = size table |

## Differences from the old button (`registry/components/control/button`)

Deleted:

- The 8 named constructors (`Button.primary` … `Button.card`, `Button.fixed`)
  — one constructor plus `variant`.
- `PrimaryButton`, `SecondaryButton`, `OutlineButton`, `GhostButton`,
  `LinkButton`, `TextButton`, `DestructiveButton`, `FixedButton`,
  `CardButton`, `IconButton.*`, `TabButton`, `SelectedButton`.
- `ButtonSize` scale-factor class and `ButtonDensity` (8 densities),
  `AbstractButtonStyle` / `ButtonStyle` and the `Styleable` override
  machinery, `button_state.dart` (state now lives in `Clickable`).

Changed:

- `ButtonGroup` is part of the `button` component (`button_group.dart`), not
  an independently installable component; `ButtonGroupData` is applied by
  `Button` to its resolved radius.
- `Toggle` and `SelectedButton` moved to the separate `toggle` component;
  `SelectedButton.selectedStyle` maps to `Toggle.activeStyle`.

Fixed (not ported):

- Destructive text was hardcoded `Colors.white` — now the
  `destructiveForeground` token.
- Hover alphas follow shadcn (`/90` primary+destructive, `/80` secondary);
  destructive rest was `@0.5`, now the full token.
- Disabled colors were unreadable combinations (primary `mutedForeground`
  background); now rest colours + whole-button opacity.
- Material/Cupertino imports are gone; icons inherit the resolved foreground
  through the `Clickable` icon theme.

## Getting started

1. Install the component (`flutter_shadcn add button`) or copy the folder into
   `lib/ui/shadcn/button/`.
2. Import `button.dart` — it re-exports the style surface (`ButtonVariant`,
   `ButtonSize`, `ButtonTheme`, `ButtonVariantStyle`, `buttonDefaults`).
3. App-wide overrides go in the user-owned `button_theme.dart` and are listed
   in `ComponentThemes`; per-subtree overrides use
   `ComponentTheme<ButtonTheme>(data: ..., child: ...)`.
