# hsv

`HSVColorSlider`: interactive slider over one or two HSV channels.

```dart
HSVColorSlider(
  color: HSVColor.fromAHSV(1, 200, 0.6, 0.5),
  sliderType: HSVColorSliderType.hueSat, // 2D pad
  onChanged: (next) { /* commit */ },
  onChanging: (next) { /* live */ },
)
```

Types: `hue`, `sat`, `val`, `alpha` (single-channel bars), `hueSat`,
`hueVal`, `hueAlpha`, `satVal`, `satAlpha`, `valAlpha` (2D pads).
`reverse` swaps the axes. Themes through `HSVSliderTheme` /
`ComponentThemes`; cursor ring defaults to white.
