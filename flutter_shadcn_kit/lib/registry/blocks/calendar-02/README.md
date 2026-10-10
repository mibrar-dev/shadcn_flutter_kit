# Calendar 02 (`calendar-02`)

A scheduling panel: a month calendar beside the selected day's slots.

Block category: **Calendar & Scheduling** · viewport: **desktop**.

## Files

- `calendar_02.dart`

The public widget (`calendar_02.dart`) is the preview: render it exactly as
an app would.

## Install

```sh
flutter_shadcn add calendar-02
```

```dart
import 'package:<your_app>/ui/shadcn/blocks/calendar-02/calendar_02.dart';

void main() => runApp(const Calendar02());
```

## Declared dependencies

The block installs with exactly these layers on top of it:

| Layer | Units |
|---|---|
| `foundation` | `gap` |
| `theme` | `theme` |
| `primitives` | `date_math` |
| `components` | `button`, `calendar`, `card`, `divider` |

## Notes

The agenda beside the calendar is plain content; the `_Calendar02Slot` list is where your availability comes from. `Calendar` needs a `CalendarView`, which the header steps update.
