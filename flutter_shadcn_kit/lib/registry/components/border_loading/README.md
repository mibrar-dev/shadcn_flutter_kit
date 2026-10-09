# Border loading

Wraps a child and paints an animated border around it — sweep gradient ring,
travelling tracer dashes, determinate progress or a static outline.
Widgets-only (`CustomPaint` + a repeating controller); no Material.

## When to use

- Upload/processing states around a card, dropzone or avatar.
- Determinate progress that hugs a rounded shape instead of a bar.

## Snippets

```dart
BorderLoading(child: Text('Uploading...'));

BorderLoading(
  mode: BorderLoadingMode.tracer,
  tracer: const BorderTracerSpec(dashCount: 3),
  child: const Text('Working...'),
);

BorderLoading(
  mode: BorderLoadingMode.progress,
  progress: value,                      // or progressStream: stream
  child: const Text('62%'),
);
```

## API

| Parameter | Default | Notes |
|---|---|---|
| `strokeWidth` | `2` | outline thickness |
| `padding` | `EdgeInsets.all(strokeWidth)` | gap between border and child |
| `borderRadius` | radius `12` | used when `shapeBorder` is null |
| `shapeBorder` | null | circle/stadium/custom outline |
| `mode` | `sweepGradient` | `sweepGradient` / `tracer` / `progress` / `staticBorder` |
| `progress` | `0` | determinate value for `progress` mode |
| `progressStream` | null | stream values override `progress` |
| `tracer` | `BorderTracerSpec()` | dash length/gap/count/caps |
| `spec` | `BorderGradientSpec()` | sweep/linear/radial gradient spec |
| `duration` | `1200ms` | cycle of the looping modes |
| `curve` | `Curves.linear` | easing of normalized progress |
| `opacity` | `1` | stroke opacity |
| `theme` | null | widget-leg `BorderLoadingTheme` |

## Theming

`BorderLoadingTheme` follows the standard four legs: widget `theme` argument >
nearest `ComponentTheme<BorderLoadingTheme>` > app `ComponentThemes` >
`borderLoadingDefaults`. Overrides are values only; see
`border_loading_theme.dart`. The gradient palette is token-derived
(`primary`/`chart2`/`chart3` fading to transparent) unless the spec carries
its own `ThemedColor` list.

## Behaviour notes

- Looping modes (`sweepGradient`, `tracer`) run a repeating controller; the
  painter works modulo the perimeter so the cycle wrap is seamless.
- `progress`/`staticBorder` paint a fixed frame and never start a ticker.
- Replaces the old `_impl` painter quartet, the unbounded
  `AnimationController` + `Simulation` timeline and the hardcoded rainbow hex
  palette (now `ThemedColor` tokens, so presets follow).
