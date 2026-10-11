# EmptyState

A block that stands in for missing content: a muted icon in a rounded container,
a semibold title, a muted description clamped to a readable measure, and up to
three actions. Two scales — `compact` (inline, on a card surface) and
`fullPage` (route-level, centred). Widgets-only.

## When to use

- A list, table or search result set with nothing in it.
- A failed load, using `EmptyStateVariant.errorFallback`.

Use `command`'s empty row for a search palette, and a plain `Text` when the
absence needs no explanation.

## Snippets

```dart
EmptyState(
  variant: EmptyStateVariant.empty,
  size: EmptyStateSize.fullPage,
  primaryAction: EmptyStateAction(
    label: 'Create project',
    onPressed: _create,
  ),
  secondaryAction: EmptyStateAction(
    label: 'Import',
    variant: ButtonVariant.secondary,
    onPressed: _import,
  ),
);
```

Inline variant:

```dart
EmptyState(
  size: EmptyStateSize.compact,
  title: const Text('Nothing here yet'),
  primaryAction: const EmptyStateAction(label: 'Create'),
);
```

## `EmptyState` API

| Parameter | Type | Default | Notes |
|---|---|---|---|
| `variant` | `EmptyStateVariant` | `empty` | picks the default strings and icon |
| `size` | `EmptyStateSize` | `fullPage` | `compact` draws a card surface and smaller type |
| `icon` | `Widget?` | null | null uses `variant.icon` |
| `title` | `Widget?` | null | null uses the localized preset title |
| `description` | `Widget?` | null | null uses the localized preset description |
| `primaryAction` | `EmptyStateAction?` | null | |
| `secondaryAction` | `EmptyStateAction?` | null | shown beside the primary |
| `footerAction` | `EmptyStateAction?` | null | shown on its own row below |
| `showIconContainer` | `bool` | true | false drops the muted container |
| `theme` | `EmptyStateTheme?` | null | widget leg of the resolver |

`EmptyStateAction(label:, onPressed:, leading:, trailing:, variant:, size:)`.
`variant` defaults to `primary` for the first action and `secondary` for the
rest; `size` defaults to `sm` for `compact` and `md` for `fullPage`.

## Variants

| `EmptyStateVariant` | Icon | Title | Description |
|---|---|---|---|
| `empty` | archive | "Nothing here yet" | "Create your first item to get started." |
| `noResults` | magnifying glass | "No results found" | "Try adjusting your filters or search terms." |
| `errorFallback` | exclamation triangle | "Something went wrong" | "We couldn’t load this data. Try again in a moment." |

All six strings come from `primitives/localizations`; the other 45 locales
inherit the English until someone adds a translation.

## Theme resolution

`widget theme > ComponentTheme<EmptyStateTheme> in tree > app overrides
(empty_state_theme.dart) > emptyStateDefaults`, merged per field.

| `EmptyStateTheme` field | Default |
|---|---|
| `iconColor` | `mutedForeground` |
| `iconContainerBackground` / `iconContainerBorderColor` | `muted` / `border` |
| `iconContainerPadding` / `iconContainerBorderRadius` | from the size's metrics |
| `titleStyle` / `descriptionStyle` | from the size's metrics |
| `padding` / `maxWidth` | from the size's metrics |
| `metrics` | the built-in size table |
| `surface` | null (the ambient `card` token) |

Sizes are the built-in scale, multiplied once by `theme.scaling`:

| | `compact` | `fullPage` |
|---|---|---|
| icon | 28 | 36 |
| title | 20 / w600 | 24 / w600 |
| description | 14, height 1.35 | 14, height 1.35 |
| padding | 24 | 32 |
| icon → title | 16 | 24 |
| title → description | 8 | 12 |
| above actions | 16 | 24 |
| max width | 420 | 520 |
| description measure | 420 | 520 |

A listed `metrics` entry wins as a whole, so a restyled size is never
half-default.

## Differences from the old `display/empty_state`

- `EmptyStateActionStyle` (primary / secondary / link) is gone:
  `EmptyStateAction.variant` takes a `ButtonVariant`, so the component no
  longer keeps a parallel enum that could drift from the button's.
- `emptyStateThemeTokens` and `EmptyStateThemeSchema` (a second hand-maintained
  theme layer under `themes/config/`) are deleted. One `EmptyStateTheme` with a
  per-size metric table replaces both.
- `PrimaryButton` / `SecondaryButton` / `LinkButton` are one `Button` with a
  `variant`.

Fixed (not ported):

- `EmptyStateTheme` extended the old `ComponentThemeData` without implementing
  `Mergeable`, so an override leg could not be merged per field: a leg that set
  only `iconColor` silently dropped every other value. Merge is now
  first-non-null-wins, receiver wins.
- `EmptyStateThemeTokens.ignoreGlobalScaling` and `ignoreGlobalRadius` were
  multiplied into the metrics one flag at a time *inside the widget*, so the
  numbers a caller got depended on which flag they happened to set. Scaling now
  happens once, in the size table.
- `cardFillColor` was read with `compTheme?.cardFillColor != null ? true : null`
  into a `Card(filled:, fillColor:)` API that the accepted `Card` no longer has,
  so a themed compact variant crashed at runtime.
- The default title, description and icon were plain functions returning
  hard-coded English (`defaultEmptyStateTitle(variant)` and friends). They are
  `ShadcnLocalizations` getters now, so the component translates.
- The button used `theme.density.baseGap * scaling * gapMd` for its spacing, so
  a non-default density silently changed the *action spacing* while the rest of
  the block stayed on the size table. Every gap is on the same scale now.
