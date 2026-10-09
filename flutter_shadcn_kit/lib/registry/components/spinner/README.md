# Spinner

Indeterminate circular indicator drawn with `CustomPaint` on
`package:flutter/widgets.dart` only. No Material, no Cupertino.

This component replaces the old `spinner` (a Material
`CircularProgressIndicator` wrapper) and absorbs the old
`circular_progress_indicator`'s indeterminate mode. The determinate circular
mode had no real call sites and is intentionally not ported; use `Progress`
for value-bearing indicators.

## When to use

- Loading states without a known percentage.
- Inline inside buttons, list rows or empty states.

## Snippets

```dart
const Spinner();

const Spinner(size: 16, strokeWidth: 2);

const Spinner(semanticsLabel: 'Loading');
```

## API

| Parameter | Default | Notes |
|---|---|---|
| `size` | `24 * scaling` | diameter |
| `strokeWidth` | `size / 12` | arc thickness |
| `color` | `primary` token | arc colour |
| `semanticsLabel` | null | accessible label |
| `theme` | null | widget-leg `SpinnerTheme` |

The arc covers three quarters of the circle and rotates once every 900 ms.

## Theming

`SpinnerTheme` follows the standard four legs: widget `theme` argument >
nearest `ComponentTheme<SpinnerTheme>` > app `ComponentThemes` >
`spinnerDefaults`. Overrides are values only; see `spinner_theme.dart`.
`strokeWidth` resolves at build so the default follows `size`.
