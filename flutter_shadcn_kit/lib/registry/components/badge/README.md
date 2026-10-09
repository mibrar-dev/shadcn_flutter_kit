# Badge

A small rounded label or status dot with four variants, optionally pressable.
shadcn's badge is a `div` (or an `asChild` link), not a button, so this
component builds its own small surface on the `Clickable` primitive and never
enters the focus tree unless it has an `onPressed`.

## When to use

- Status, category or count labels next to content.
- A read-only dot marking "online / offline".

Use `chip` for a token the user can remove, and `toggle` for an on/off button.

## Snippets

```dart
const Badge(child: Text('New'));
```

Variants are data, not classes:

```dart
Badge(variant: BadgeVariant.destructive, child: const Text('Deprecated'));
```

Pressable (a filter pill that toggles its own state):

```dart
Badge(
  onPressed: () => setState(() => selected = !selected),
  child: const Text('Mine'),
);
```

Dot:

```dart
Badge(showAsDot: true, child: const SizedBox.shrink());
```

## `Badge` API

| Parameter | Type | Default | Notes |
|---|---|---|---|
| `child` | `Widget` | required | ignored when `showAsDot` is true |
| `variant` | `BadgeVariant` | `primary` | `primary`, `secondary`, `outline`, `destructive` |
| `leading` / `trailing` | `Widget?` | null | optional icons (asserted off for a dot) |
| `onPressed` | `VoidCallback?` | null | presence makes the badge interactive |
| `onHover` / `onFocusChange` | `ValueChanged<bool>?` | null | observation only |
| `focusNode` / `autofocus` | | null / false | as in `Button` |
| `showAsDot` | `bool` | false | shadcn `showAsDot` |
| `theme` | `BadgeStyle?` | null | widget leg of the resolver |

## Theme resolution

`widget theme > ComponentTheme<BadgeTheme> in tree > app overrides
(badge_theme.dart) > badgeDefaults`, merged per field **and per state**: a leg
that only sets `hovered` keeps the default `rest` colour.

| `BadgeTheme` field | Default |
|---|---|
| `primary` | `primary` fill / `primaryForeground`, hover+press `primary@0.9` |
| `secondary` | `secondary` fill / `secondaryForeground`, hover+press `@0.8` |
| `outline` | no fill, 1px `border`, `foreground` label |
| `destructive` | `destructive` fill / `destructiveForeground`, hover+press `@0.9` |
| `textStyle` | 12px (shadcn `text-xs`) |
| `padding` | 8 x 2 (shadcn `px-2 py-0.5`) |
| `borderRadius` | ambient `radiusMd` (shadcn `rounded-md`) |

There is no `disabled` row: a static badge is not a disabled button, it is a
plain token painted at full strength.

## Differences from the old `display/badge`

- `PrimaryBadge`, `SecondaryBadge`, `OutlineBadge` and `DestructiveBadge`
  collapse into `Badge(variant: ...)` (PLAN §4 rule 1). The old module also
  declared five variant classes; `BadgeTheme`/`BadgeThemeTokens`/
  `BadgeThemeSchema`/`BadgeThemeConfig` are replaced by one `BadgeTheme`.
- The old badge was always `Button(enabled: true)` wrapped in `ExcludeFocus`,
  so even a static badge showed hover/press styling, showed a click cursor and
  swallowed a pointer click that no handler answered. Without `onPressed` this
  badge builds no `Clickable` at all.
- `BadgeStyleable` / the `Styleable<BadgeTheme>` whole-property bag is gone:
  the old theme replaced a whole `AbstractButtonStyle`, so an override that
  only restated one state lost the rest of the default row (transparent badge at
  rest). `BadgeStyle` + `StateValue.merge` merge per field and per state.
- New: `showAsDot`, a `variant` enum and a themed border radius.
