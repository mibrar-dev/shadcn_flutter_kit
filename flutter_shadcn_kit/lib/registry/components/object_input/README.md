# Object Input

Typed date, time and duration fields. Each field is locale-ordered numeric
segments (year/month/day, hour/minute/second) on a `FormattedInput`, with a
calendar prompt behind the date field's trailing button: a centered dialog
or an anchored popover. Widgets-only.

## When to use

- Date entry with typing plus calendar picking (`DateInput`).
- Time or duration entry without a picker (`TimeInput`, `DurationInput`).
- Anything needing a typed `DateTime`/`TimeOfDay`/`Duration` value in a form.

For a trigger-style picker with a popover use `date_picker`/`time_picker`;
for free text use `input`.

## Snippets

```dart
DateInput(
  value: date,
  onChanged: (next) => setState(() => date = next),
);
```

```dart
// Force one presentation (default: popover on desktop widths, dialog below).
DateInput(
  value: date,
  onChanged: (next) => setState(() => date = next),
  mode: PromptMode.dialog,
);
```

```dart
TimeInput(
  value: time,
  showSeconds: true,
  onChanged: (next) => setState(() => time = next),
);
```

```dart
DurationInput(
  initialValue: const Duration(minutes: 90),
  onChanged: (next) => submit(next),
);
```

## API

- `DateInput(value, initialValue, onChanged, enabled, datePartsOrder,
  separator, placeholders, validator, mode, initialView, initialViewType,
  stateBuilder, dialogTitle, theme)` — incomplete or impossible dates
  (month 13, February 30) report null; the time part is dropped.
- `mode` is `PromptMode.dialog`/`popover` (from
  `primitives/form_core/object_form_field.dart`); null resolves popover on
  desktop widths (≥ 768 logical pixels) and dialog below. Popover
  presentation needs an `OverlayManager` ancestor (the app root provides
  it) and reports selections live without closing; dialog closes on pick.
- `TimeInput(value, initialValue, onChanged, enabled, showSeconds,
  separator, placeholders, validator, theme)` — hour 0-23, minute/second
  0-59; null while incomplete/invalid.
- `DurationInput(...)` — same segments as time; hours unbounded.
- Controlled with `value` + `onChanged`; uncontrolled with `initialValue`.
  Null `onChanged` disables. Validation shows below the field (from
  `FormattedInput`); form integration via its `FormValueSupplier`.
- `theme` forwards a `FormattedInputTheme` widget-leg override.
- Segment shapes live in `primitives/object_segments.dart` and rebuild only
  when the content key changes — hoist custom `placeholders` maps instead of
  passing inline literals, or typing loses focus on every parent rebuild.

## Differences from old object_input

- `NullableDate`/`NullableTimeOfDay` middle layers are gone; segments parse
  straight to `DateTime`/`TimeOfDay`/`Duration`.
- Material `TimeOfDay` and `showDatePicker` are replaced by
  `foundation/time_of_day.dart` and a calendar prompt: a `showShadcnDialog`
  route in dialog mode, an anchored `PopoverController` popover in popover
  mode (resolved by width unless `mode` is set).
- Old `Card` chrome, `form_field` wrapper and `locale_utils` import are
  folded into `FormattedInput` (validation + form value supply) and the
  `localizations` primitive; no `card`/`form`/`locale_utils` component deps.
- Old `part` files and the state-part split are one flat file; the reusable
  segment math is the `object_segments` primitive, not per-field copies.
