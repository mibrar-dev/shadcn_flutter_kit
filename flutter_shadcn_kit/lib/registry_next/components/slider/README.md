# Slider

Single- and range-value sliders with snap strategies, four visual variants,
full keyboard support, and form participation. Built from widgets primitives
(gesture layer + `CustomPaint`); the old Material `Slider` dependency is
gone.

## When to use

Use `Slider` for continuous or stepped numeric input in forms; use
`Slider.range` for a two-thumb interval. For numeric text entry use `Input`.

```dart
Slider(value: 0.4, onChanged: (v) => setState(() => v));
Slider(
  value: 2, min: 0, max: 4,
  snap: const SliderSnap.steps(4),
  variant: SliderVariant.dots,
  onChanged: (v) => setState(() => v),
);
Slider.range(
  value: const SliderValue.ranged(0.2, 0.7),
  minRange: 0.1,
  onRangeChanged: (v) => setState(() => v),
);
```

## API

| Parameter | Default | Notes |
|---|---|---|
| `value` / `rangeValue` | required | single `double` vs `SliderValue` |
| `onChanged` / `onRangeChanged` | required | controlled callback |
| `min` / `max` | `0` / `1` | domain; `max` must exceed `min` |
| `snap` | `SliderSnap.none()` | `.steps(n)` or `.values([...])` |
| `variant` | `SliderVariant.standard` | standard / soft / dots / wave |
| `enabled` | `true` | false dims to 50% and blocks input |
| `minRange` | `0` | range-mode minimum gap |
| `allowSwap` | `false` | range thumbs may cross |
| `theme` | null | widget-leg `SliderStyle` override |
| `semanticLabel`, `focusNode`, `autofocus` | — | a11y / focus |

Keyboard: ←/→ step by `(max-min)/100`, one snap interval, or adjacent entry;
Home/End jump to the bounds. In range mode the arrow adjusts the active thumb.
Disabled sliders ignore gestures and keys and render at 50% opacity.

## Theme

`SliderTheme` holds one nullable `SliderStyle` per variant; unset fields fall
through to `sliderDefaults` (tokens only). Resolution order: widget `theme` >
nearest `ComponentTheme<SliderTheme>` > app `ComponentThemes` > defaults.
Colors come from tokens (`secondary` track, `primary` fill, `background`
circle thumb with `primary` border); alpha multiplies (`ThemedColor.ref`).
`Slider` implements `FormValueSupplier<SliderValue, Slider>`.

## Differences from the old `form/slider`

- **No Material.** Old `slider.dart` and the six `shad_slider_*` files
  imported `package:flutter/material.dart` (a stock `Slider` cannot be
  restyled per segment); the new control is gesture + `CustomPaint` only.
- `ShadRangeValue` deleted — range values use the shared
  `primitives/slider_value.dart` `SliderValue`.
- Preset strings (`'brightness'`, `'rangeSoft'`, `'stepsDots'`,
  `'waveform'`) became the `SliderVariant` enum; a `ShadSliderPreset`
  lookup is no longer needed. Mapping: standard←brightness, soft←rangeSoft,
  dots←stepsDots, wave←waveform.
- Dropped knobs: `thumbEdgeOffsetPx`, `thumbVerticalOffsetPx`, `joinGapPx`,
  `fillEdgeBiasPx`, `fillStopsAtThumbCenter`, `trackRenderer`, per-layer
  builder overrides, `dragPopover*`. The drag popover was deleted (the
  semantic `value` carries the state); re-add as a primitive later if needed.
- Upstream-compat exports deleted: `ControlledSlider`, `SliderController`,
  `IncreaseSliderValue`/`DecreaseSliderValue` intents,
  `SliderValueIndicator`. Clean break; keyboard support is built in.
- Value mapping, snapping, range-thumb math, keyboard stepping and the
  generic `SliderPainter` live in `primitives/slider/` (layer 2, shared
  with the B04 colour sliders); the component keeps only variants/theme.
  `SliderValueIndicatorBuilder`/waveform "wave slider" animated overlays
  removed; `wave` variant keeps the static bar overlay.
- Hit-testing, snapping and min-range behaviour ported from
  `shad_slider_logic.dart`; `ShadSliderLogic` is now `SliderLogic`
  (widgets-only).
