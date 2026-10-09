# Breadcrumb

Horizontal trail of crumbs with a separator between each pair. Widgets-only,
built on `primitives/text` for the type scale and colours.

## When to use

- Show where the current page sits in a hierarchy.
- Offer one-tap navigation back up the tree.

For paging through a list use `pagination`; for step progress use `steps`.

## Snippets

Minimal (chevron separator is the default):

```dart
const Breadcrumb(
  children: <Widget>[Text('Home'), Text('Components'), Text('Breadcrumb')],
);
```

Slash separator and custom spacing:

```dart
const Breadcrumb(
  separator: Breadcrumb.slashSeparator,
  theme: BreadcrumbTheme(spacing: 8),
  children: <Widget>[Text('src'), Text('components')],
);
```

## `Breadcrumb` API

| Parameter | Type | Default | Notes |
|---|---|---|---|
| `children` | `List<Widget>` | required | root first, current last |
| `separator` | `Widget?` | null | falls back to `BreadcrumbTheme.separator`, then the chevron |
| `padding` | `EdgeInsetsGeometry?` | null | strip padding |
| `theme` | `BreadcrumbTheme?` | null | widget leg of the resolver |

Statics: `Breadcrumb.arrowSeparator` (chevron) and
`Breadcrumb.slashSeparator` (`/`).

The last crumb uses the `foreground` colour; earlier crumbs and the separators
use `mutedForeground`. The strip scrolls horizontally when it overflows and
hides the scrollbar chrome.

## Theme resolution

`widget (theme:) > ComponentTheme<BreadcrumbTheme> in tree > app overrides
(breadcrumb_theme.dart through ComponentThemes) > breadcrumbDefaults`, merged
per field with receiver-wins `Mergeable.merge`.

| `BreadcrumbTheme` field | Default |
|---|---|
| `separator` | null → `Breadcrumb.arrowSeparator` |
| `padding` | `EdgeInsets.zero` |
| `spacing` | `6` (× ambient scaling) on each side of the separator |

## Differences from the old breadcrumb

- The old `theme.schema.json` / `_impl` split is replaced by `breadcrumb_style.dart`
  plus the user-owned `breadcrumb_theme.dart`.
- Separators come from `primitives/text` and the `foundation/icons` chevron;
  no `shared/primitives` imports remain.

## Getting started

1. Install the component (`flutter_shadcn add breadcrumb`) or copy the folder
   into `lib/ui/shadcn/breadcrumb/`.
2. Import `breadcrumb.dart`; it re-exports `BreadcrumbTheme` and
   `breadcrumbDefaults`.
3. App-wide overrides go in `breadcrumb_theme.dart`; per-subtree overrides use
   `ComponentTheme<BreadcrumbTheme>(data: ..., child: ...)`.
