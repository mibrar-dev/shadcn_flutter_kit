# hsl

`HSLColorSlider`: interactive slider over one or two HSL channels.

```dart
HSLColorSlider(
  color: HSLColor.fromAHSL(1, 200, 0.6, 0.5),
  sliderType: HSLColorSliderType.hueSat, // 2D pad
  onChanged: (next) { /* commit */ },
  onChanging: (next) { /* live */ },
)
```

Types: `hue`, `sat`, `lum`, `alpha` (single-channel bars), `hueSat`,
`hueLum`, `hueAlpha`, `satLum`, `satAlpha`, `lumAlpha` (2D pads).
`reverse` swaps the axes. Themes through `HSLSliderTheme` /
`ComponentThemes`; cursor ring defaults to white.
