# dot_indicator

A row (or column) of animated dots showing the active index of a carousel,
stepper or pager.

## Getting started

```dart
DotIndicator(
  index: page,
  length: pages.length,
  onChanged: (int index) => controller.animateToPage(index),
)
```

Read-only (no tap targets at all):

```dart
const DotIndicator(index: 1, length: 5)
```

Custom dots:

```dart
DotIndicator(
  index: page,
  length: pages.length,
  dotBuilder: (context, index, isActive) => SizedBox(
    width: isActive ? 24 : 8,
    height: 8,
    child: const DecoratedBox(decoration: BoxDecoration(color: Colors.grey)),
  ),
)
```

## API

| Member | Type | Notes |
|---|---|---|
| `index` | `int` | Active index; a value outside `0..length - 1` leaves every dot inactive. |
| `length` | `int` | Required, must be > 0 (asserted). |
| `onChanged` | `ValueChanged<int>?` | Null makes the run read-only — no `Clickable`, no click cursor. |
| `spacing` | `double?` | null = `DotIndicatorTheme.spacing` then `8 * scaling`. |
| `direction` | `Axis` | `horizontal` (default) or `vertical`. |
| `padding` | `EdgeInsetsGeometry?` | Applied once around the run; null = the density base gap. |
| `dotBuilder` | `DotBuilder?` | null paints the theme rows. |
| `theme` | `DotIndicatorTheme?` | Widget-leg override. |

## Theme

`DotIndicatorTheme` holds one [`DotStyle`] row per state group and resolves
through all four legs: widget argument > nearest `ComponentTheme` >
`ComponentThemes` app entry > `dotIndicatorDefaults`.

Defaults: active `primary`, inactive `muted`, `12 * scaling` diameter, full
circle, 150 ms morph. `DotIndicatorDefaults.active` / `.inactive` expose the
same rows if you paint your own dots.

## Differences from the old `display/dot_indicator`

| Old | New |
|---|---|
| ten files, four `part`s, `implements Styleable<…>` | three flat files |
| `DotItem` (the only animated dot widget) had **zero readers**; the two dots the indicator actually built were plain `Container`s, so changing the index jumped instantly | dots animate between their rows |
| `activeColor` defaulted to the literal `0xFF171717`, `inactiveBorderColor` to `0xFFF5F5F5` — greys no preset defines | `primary` / `muted` tokens |
| the inactive dot was a transparent fill with a `secondary` ring, so it read as an outline | a filled `muted` dot |
| a `SystemMouseCursors.click` cursor and a live `Clickable` even when `onChanged` was null | a null `onChanged` builds neither |
| `resolvedPadding` was multiplied by `theme.scaling` after resolution, inflating a caller-provided `padding` | the padding is resolved once and applied once, unscaled |
| `IntrinsicHeight` + `Flex(crossAxisAlignment: stretch)` + `Flexible` for a fixed-size row | a plain `Row` / `Column` |
| only `ComponentTheme.maybeOf` was read; no defaults, no app leg | all four legs over token-derived defaults |
| `padding` mixed per-dot leading/trailing halves into the spacing maths | padding is the run's padding, spacing is the gap |
| `theme.schema.json` + `dot_indicator_theme_{config,defaults,schema,tokens}.dart` (489 lines) | `dot_indicator_style.dart` + `dot_indicator_theme.dart` |