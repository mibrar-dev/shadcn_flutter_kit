# Calendar 01 (`calendar-01`)

A date-range picker card with a two-month calendar and footer actions.

Block category: **Calendar & Scheduling** · viewport: **desktop**.

## Files

- `calendar_01.dart`

The public widget (`calendar_01.dart`) is the preview: render it exactly as
an app would.

## Install

```sh
flutter_shadcn add calendar-01
```

```dart
import 'package:<your_app>/ui/shadcn/blocks/calendar-01/calendar_01.dart';

void main() => runApp(const Calendar01());
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

`Calendar` owns no navigation, so the header steps drive the `CalendarView`. Pass `selectionMode: CalendarSelectionMode.range` (already set) and lift `_value` to store the chosen range.
