# TimePicker

Clock-time and duration fields: triggers showing the value (or the
localized placeholder) that open digit-field sheets in a dialog or a
popover, wired into the form system.

## When to use

Use for alarms, opening hours, and durations. For dates use `date_picker`.

## Snippets

```dart
TimePicker(
  value: selected,
  onChanged: (next) => setState(() => selected = next),
);
```

```dart
// 12-hour clock with seconds.
TimePicker(
  value: selected,
  onChanged: (next) => setState(() => selected = next),
  use24HourFormat: false,
  showSeconds: true,
);
```

```dart
DurationPicker(
  value: length,
  onChanged: (next) => setState(() => length = next),
);
```

## API

| Prop | Meaning |
|---|---|
| `value` / `onChanged` | Controlled time/duration; null `onChanged` disables |
| `placeholder` | Shown while null; null resolves the localized default |
| `mode` | Dialog or popover; null resolves the theme default |
| `use24HourFormat` | 12/24-hour clock; null resolves theme, else ambient |
| `showSeconds` | Seconds field; null resolves the theme default |
| `dialogTitle` | Title of the dialog prompt |

Sheets report live: every digit edit clamps into range and calls
`onChanged`. In dialog mode the prompt's Save commits and Cancel discards.

## Theme fields

`TimePickerTheme`: `mode`, `use24HourFormat`, `showSeconds`,
`popoverAlignment`, `popoverAnchorAlignment`, `popoverPadding`,
`dialogTitle`. Colours come from the `input`/`button` components and global
tokens.

## Differences from old `time_picker`

Material `TimeOfDay`/`Icons`/`TextField` are gone; `_TimeFormatter` is
imported from `formatter`; zero-reader `TimeRange` deleted; AM/PM is two
buttons; controllers deleted (controlled value + `onChanged` only).
