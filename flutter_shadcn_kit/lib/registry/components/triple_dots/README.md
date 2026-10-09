# TripleDots

A row or column of small round dots, typically used as an ellipsis in
pagination or breadcrumbs. Widgets-only.

Renamed from the old `MoreDots` class to match the component directory name
(clean break: no alias).

## When to use

- Truncated page numbers (`1 2 … 9`).
- Any inline "more" affordance that should not be a button.

## Snippets

```dart
const TripleDots();

const TripleDots(count: 4, direction: Axis.vertical);
```

## API

| Parameter | Default | Notes |
|---|---|---|
| `count` | 3 | number of dots, must be > 0 |
| `direction` | `Axis.horizontal` | row or column |
| `size` | `4 * scaling` | dot diameter |
| `spacing` | 2 | gap between dots |
| `color` | `mutedForeground` token | dot colour |
| `padding` | zero | padding around the run |
| `theme` | null | widget-leg `TripleDotsTheme` |

## Regression fixed

The old component read `DefaultTextStyle.of(context).style.color!` and threw
when no explicit text colour was installed. The new default is the
`mutedForeground` token, so the widget renders in any context.

## Theming

`TripleDotsTheme` follows the standard four legs: widget `theme` argument >
nearest `ComponentTheme<TripleDotsTheme>` > app `ComponentThemes` >
`tripleDotsDefaults`. Overrides are values only; see `triple_dots_theme.dart`.
