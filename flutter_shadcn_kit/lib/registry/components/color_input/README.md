# ColorInput (`color_input`)

Compact colour field: a colour well plus an editable hex text input. Tapping
the well opens the full `color_picker` — in a popover on desktop widths, in a
dialog below 768 px.

## When to use

- You need a form-sized colour control (well + hex) that opens a full picker.
- You want recent colours and screen sampling without embedding the whole
  picker in the page.

Avoid when you need the picker always visible — use `color_picker` directly.

## Install

```bash
flutter_shadcn add color_input
```

## Import

```dart
import 'package:<your_app>/ui/shadcn/color_input/color_input.dart';
```

## Minimal example

```dart
ColorInput(
  value: ColorDerivative.fromColor(const Color(0xFF2563EB)),
  onChanged: (value) => setState(() => _color = value),
)
```

## Common patterns

### Alpha, history and a dialog prompt

```dart
ColorInput(
  value: _color,
  showAlpha: true,
  showHistory: true,
  mode: PromptMode.dialog,
  dialogTitle: const Text('Select a colour'),
  onChanging: (value) => setState(() => _color = value),
  onChanged: (value) => setState(() => _color = value),
)
```

### Screen sampling

Wrap the tree with an `EyeDropperLayer`; the picker's pipette closes the
prompt, samples the screen and reopens the prompt with the picked colour.
Recent colours come from a `RecentColorsScope` (both optional).

## API

- `ColorInput(value, onChanged, onChanging, showAlpha, initialMode,
  enableEyeDropper, showHistory, mode, popoverAlignment,
  popoverAnchorAlignment, popoverPadding, dialogTitle, enabled, theme)`.
- `ColorInputTheme` — per-component style; `colorInputDefaults`,
  `colorInputThemeOverrides`.
- `colorInputTrigger(context, value:, style:, enabled:, onPressed:,
  onHexChanged:)` — the trigger row; public because the flat component folder
  has one widget file (the `colorPickerFields()` precedent), normally not used
  directly.
- Controlled only: `value` is the source of truth; `null` `onChanged` (and no
  `enabled`) disables the field.

### Theme fields

| Field | Default | Effect |
|---|---|---|
| `mode` | responsive | `popover` at 768px+, `dialog` below |
| `pickerMode` | `rgb` | channel mode the picker opens in |
| `showAlpha` | true | picker alpha editing |
| `enableEyeDropper` | true | picker screen sampling |
| `showHistory` | true | picker history toggle |
| `popoverAlignment` / `popoverAnchorAlignment` | top-start / bottom-start | directional popover placement |
| `popoverPadding` | 16 | popover inner padding |
| `gap` | 8 | gap between well and hex field |
| `swatchSize` | 36 | well edge (shadcn h-9) |
| `swatchBorderRadius` | ambient `radiusMd` | well corner radius |
| `swatchBorderColor` | `border` token | well border |

Resolution: widget `theme` > nearest `ComponentTheme<ColorInputTheme>` >
`ComponentThemes` app overrides > `colorInputDefaults`.

## Differences from the old `ColorInput`

- The trigger is a colour well plus an editable hex `Input`; the old
  `showLabel` flag (swatch-only vs swatch+text) is gone, as is the dead
  `placeholder` argument (`value` is required non-null).
- History is optional at runtime: without a `RecentColorsScope` commits do not
  throw (the old `ColorHistoryStorage.of` did).
- One screen-sampling path for both presentations: the pipette closes the
  prompt, samples from the trigger context and reopens with the pick. The old
  dialog action used the throwing history lookup.
- The hex field parses `#RGB` / `#RRGGBB` / `#AARRGGBB`; 3/6 digits keep the
  current alpha, 8 digits carry their own (the old picker field reset alpha).
- `ControlledColorInput` / `ColorInputController` are dropped (clean break):
  the widget is controlled with `value` + `onChanged` and participates in
  forms as a `ColorDerivative` field.
- The prompt mode defaults to popover on desktop widths and dialog below
  (the old widget always defaulted to popover). Narrow dialogs need no scaling:
  the picker's controls row reflows (see `color_picker`).

## Related components

- `color_picker` — the full picker this field opens.
- `history` — recent colours (`RecentColorsScope`).
- `eye_dropper` — screen sampling (`EyeDropperLayer`).
