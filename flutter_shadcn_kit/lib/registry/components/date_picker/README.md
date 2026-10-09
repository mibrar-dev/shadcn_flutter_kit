# DatePicker

Single-date field: a trigger showing the value (or the localized
placeholder) that opens a `DatePickerDialog` calendar sheet in a dialog or
a popover, wired into the form system.

## When to use

Use for birthdays, deadlines, and filters. For a span use the range recipe
below; for time of day use `time_picker`.

## Snippets

```dart
DatePicker(
  value: selected,
  onChanged: (next) => setState(() => selected = next),
);
```

```dart
DateRangePicker(
  value: range,
  onChanged: (next) => setState(() => range = next),
);
```

## API

| Prop | Meaning |
|---|---|
| `value` / `onChanged` | Controlled date; null `onChanged` disables |
| `placeholder` | Shown while null; null resolves the localized default |
| `mode` | Dialog or popover; null resolves the theme default |
| `initialView` / `initialViewType` | Where the calendar opens |
| `stateBuilder` | Per-date enable/disable |
| `dialogTitle` | Title of the dialog prompt |

Keyboard: the sheet is one tab stop (see `calendar`); arrows move a day or
a week, Home/End the ends of the week, PageUp/PageDown a month, Enter/Space
selects.

## Theme fields

`DatePickerTheme`: `mode`, `initialView`, `initialViewType`,
`popoverAlignment`, `popoverAnchorAlignment`, `popoverPadding`. Colours come
from the `calendar` component and global tokens.

## Differences from old `date_picker`

The 500px dual-pane range layout is one grid; month/year taps drill in;
the title cycles grids; the form dep is the `form_core` primitive.
