# Color Field

A custom-painted HSV/HSL gradient area with an optional transparency
checkerboard and a themed ring. Give it a bounded box; it fills the space.

```dart
SizedBox(
  width: 240,
  height: 160,
  child: ColorField(
    color: const Color(0xFF2563EB),
    saturationAxis: ColorFieldAxis.horizontal,
    valueAxis: ColorFieldAxis.vertical,
  ),
);
```

## API

| Member | Notes |
|---|---|
| `color` | the colour the field is built from |
| `mode` | `ColorFieldMode.hsv` (default) or `ColorFieldMode.hsl` |
| `hueAxis` / `saturationAxis` | ramp axis in both modes |
| `valueAxis` | HSV value ramp |
| `lightnessAxis` | HSL lightness ramp |
| `alphaAxis` | alpha ramp; a checkerboard shows behind translucent pixels |
| `theme` | widget-leg `ColorFieldTheme` override |

`ColorFieldAxis` is re-exported from `primitives/color_field_paint.dart`, which
owns the gradient engine (`paintHSVColorField` / `paintHSLColorField`, also
re-exported). `hsl` and `hsv` import the primitive directly; this component is
for embedding a plain field (picker surfaces, previews) without a slider.

## Theme

`ColorFieldTheme` owns the ring (`borderColor` default `border`, `borderWidth`
default 1, `borderRadius` default `radiusMd`) and the `checkerboard` flag.

## Differences from the old `form/color_field`

- The old directory was a painter-only engine (`ColorFieldAxis` +
  `paintHSVColorField` + `paintHSLColorField`); P4-B04 moved the engine into
  `primitives/color_field_paint.dart` as the single owner. This component
  consumes it and adds the missing surface widget; nothing is forked.
- The old component declared `alpha` and `theme` dependencies it never used;
  here `alpha` backs the checkerboard and the theme is real.
