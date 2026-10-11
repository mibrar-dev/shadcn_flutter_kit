# ColorPicker (`color_picker`)

Full colour picker: an HSV/HSL pad, hue/alpha bars, RGB/HSL/HSV/HEX numeric
fields, optional alpha, colour history and screen sampling.

## When to use

- You need a full picker UI with several colour-space entry modes.
- You want live `onChanging` updates (drag preview) plus committed
  `onChanged` values.

Avoid when you only need a compact swatch/hex field — use `color_input`.

## Install

```bash
flutter_shadcn add color_picker
```

## Import

```dart
import 'package:<your_app>/ui/shadcn/color_picker/color_picker.dart';
```

## Minimal example

```dart
ColorPicker(
  value: ColorDerivative.fromColor(const Color(0xFF2563EB)),
  onChanged: (value) => setState(() => _color = value),
)
```

## Common patterns

### HSV mode with alpha and history

```dart
RecentColorsScope(
  child: ColorPicker(
    value: _color,
    initialMode: ColorPickerMode.hsv,
    showAlpha: true,
    initialShowHistory: true,
    onChanging: (value) => setState(() => _color = value),
    onChanged: (value) => setState(() => _color = value),
  ),
)
```

### Screen sampling

The default eye-dropper button samples through the nearest `EyeDropperLayer`
and writes the pick into the nearest `RecentColorsScope`:

```dart
EyeDropperLayer(
  child: RecentColorsScope(
    child: ColorPicker(value: _color, onChanged: (v) => setState(() => _color = v)),
  ),
)
```

## API

- `ColorPicker(value, onChanged, onChanging, showAlpha, initialMode,
  onModeChanged, enableEyeDropper, onEyeDropperRequested, showHistoryButton,
  initialShowHistory, theme)`.
- `ColorPickerMode` — `rgb`, `hsl`, `hsv`, `hex`. `hsl` drives an HSL pad;
  the other modes drive the HSV pad.
- `ColorPickerControls` — the registry-owned controls row (buttons, mode
  select, channel fields); public for composition, normally not used directly.
  It reflows: one run at its one-line width
  (`colorPickerControlsWidth`, the picker's popover/intrinsic width) and extra
  runs below on narrower widths (narrow dialogs, phones), so it never
  overflows.
- `ColorPickerTheme` — per-component style; `colorPickerDefaults`,
  `colorPickerThemeOverrides`.

### Theme fields

| Field | Default | Effect |
|---|---|---|
| `spacing` | 12 | gap between the pad/history and the controls |
| `controlSpacing` | 8 | gap between sliders, fields and buttons |
| `orientation` | `Axis.vertical` | stack direction |
| `enableEyeDropper` | true | eye-dropper button visibility |
| `sliderSize` | 24 | hue/alpha bar thickness |

Resolution: widget `theme` > nearest `ComponentTheme<ColorPickerTheme>` >
`ComponentThemes` app overrides > `colorPickerDefaults`. The old per-widget
`orientation`/`spacing`/`controlSpacing`/`sliderSize` arguments are gone
(clean break): set them through the theme legs instead.

## Differences from the old `ColorPicker`

- The pad follows the **current** mode; the old build switch read
  `initialMode`, so switching between HSL/HSV/HEX never changed the pad.
- History UI is optional at runtime: without a `RecentColorsScope` the picker
  renders no history button/grid instead of throwing from
  `ColorHistoryStorage.of` when the button is pressed.
- Horizontal layouts honour `initialShowHistory` (the old horizontal path
  always showed the grid and ignored the flag).
- The HEX field parses `#RGB`/`#RRGGBB`/`#AARRGGBB` and keeps the current
  alpha; the old field accepted exactly 6 digits and reset alpha to opaque.
- Alpha fields are 0–100 in every mode (the old HSL/HSV fields used 0–100
  while RGB/HEX used 0–255).
- `_impl/` is gone: the pad/bars reuse `hsl`/`hsv`, the fields are `Input`s,
  the mode dropdown is a `Select`; no painter or slider type is re-declared.
