# Pagination

Previous/next controls plus a window of page buttons, with skip-to-edge
buttons and an ellipsis. Built on the `button` component and `triple_dots`;
labels come from `primitives/localizations`.

## When to use

- Split a long list into pages and let the user move between them.

For a location trail use `breadcrumb`; for step progress use `steps`.

## Snippets

Minimal:

```dart
Pagination(
  page: current,
  totalPages: 20,
  onPageChanged: (page) => setState(() => current = page),
);
```

Icon-only with a wider window:

```dart
const Pagination(
  page: 5,
  totalPages: 40,
  maxPages: 5,
  showLabel: false,
  onPageChanged: _noop,
);
```

## `Pagination` API

| Parameter | Type | Default | Notes |
|---|---|---|---|
| `page` | `int` | required | 1-based; clamped for display |
| `totalPages` | `int` | required | `<= 0` renders only prev/next |
| `onPageChanged` | `ValueChanged<int>` | required | requested page |
| `maxPages` | `int` | `3` | window size when the total exceeds it |
| `showSkipToFirstPage` | `bool` | `true` | first-page button before the window |
| `showSkipToLastPage` | `bool` | `true` | last-page button after the window |
| `hidePreviousOnFirstPage` | `bool` | `false` | hide prev on page 1 |
| `hideNextOnLastPage` | `bool` | `false` | hide next on the last page |
| `showLabel` | `bool?` | null | text label on prev/next |
| `gap` | `double?` | null | gap between controls |
| `theme` | `PaginationTheme?` | null | widget leg of the resolver |

The active page uses the `outline` button variant; every other control uses
`ghost`. The ellipsis is a `TripleDots` inside a ghost button.

## Theme resolution

`widget (theme:) > ComponentTheme<PaginationTheme> in tree > app overrides
(pagination_theme.dart through ComponentThemes) > paginationDefaults`, merged
per field with receiver-wins `Mergeable.merge`.

| `PaginationTheme` field | Default |
|---|---|
| `gap` | `4` (× ambient scaling) |
| `showLabel` | `true` |

## Differences from the old pagination (`registry/components/navigation/pagination`)

- `GhostButton` / `OutlineButton` / `MoreDots` are replaced by `Button` and
  `TripleDots`.
- The page window is clamped: an out-of-range `page` used to compute a
  negative `List.generate` length and throw; `totalPages <= 0` is handled.
- Icon-only prev/next carry a localized semantics label
  (`buttonPrevious` / `buttonNext`).

## Getting started

1. Install the component (`flutter_shadcn add pagination`) or copy the folder
   into `lib/ui/shadcn/pagination/`.
2. Import `pagination.dart`; it re-exports `PaginationTheme` and
   `paginationDefaults`.
3. App-wide overrides go in `pagination_theme.dart`; per-subtree overrides use
   `ComponentTheme<PaginationTheme>(data: ..., child: ...)`.
