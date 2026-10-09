# Progress

Linear progress bar with determinate and indeterminate modes, painted with
`CustomPaint` on `package:flutter/widgets.dart` only.

This component replaces both old components `progress` (the min/max wrapper)
and `linear_progress_indicator` (the raw bar with indeterminate mode and
sparks). There was no visual delta between them: both drew the same
horizontal bar. `progress` keeps the shadcn name and absorbs the
indeterminate sweep and the optional sparks.

## When to use

- A determinate task indicator: `Progress(value: 0.4)`.
- An indeterminate one when no value is known: `const Progress()`.
- A thin inline bar (file uploads, dashboard rows): `height: 4`.

For a circular indeterminate indicator use `Spinner`.

## Snippets

```dart
const Progress(value: 0.4);

const Progress();

const Progress(
  value: 0.85,
  showSparks: true,
  semanticsLabel: 'Uploading',
  semanticsValue: '85%',
);
```

## API

| Parameter | Default | Notes |
|---|---|---|
| `value` | null | `0..1` fraction; null renders the indeterminate sweep |
| `height` | `8 * scaling` | |
| `borderRadius` | pill (`height / 2`) | |
| `color` | `primary` token | fill |
| `backgroundColor` | fill at 20% alpha | track |
| `showSparks` | false | radial glow at the leading edge |
| `disableAnimation` | false | value changes jump instead of animating |
| `semanticsLabel` / `semanticsValue` | null | accessible progress reporting |
| `theme` | null | widget-leg `ProgressTheme` |

Values outside `0..1` are clamped. RTL mirrors the fill direction.

## Theming

`ProgressTheme` follows the standard four legs: widget `theme` argument >
nearest `ComponentTheme<ProgressTheme>` > app `ComponentThemes` >
`progressDefaults`. Overrides are values only; see `progress_theme.dart`.
`borderRadius` resolves at build so the default pill follows `height`.
