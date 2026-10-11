# Dashboard 01 (`dashboard-01`)

A dashboard with stat tiles, a bar chart and a recent transactions table.

Block category: **Dashboard** · viewport: **desktop**.

## Files

- `dashboard_01.dart`
- `dashboard_01_table.dart`

The public widget (`dashboard_01.dart`) is the preview: render it exactly as
an app would.

## Install

```sh
flutter_shadcn add dashboard-01
```

```dart
import 'package:<your_app>/ui/shadcn/blocks/dashboard-01/dashboard_01.dart';

void main() => runApp(const Dashboard01());
```

## Declared dependencies

The block installs with exactly these layers on top of it:

| Layer | Units |
|---|---|
| `foundation` | `gap` |
| `theme` | `theme` |
| `components` | `avatar`, `button`, `card`, `divider`, `input`, `table` |

## Notes

Replace the four `_Dashboard01` tuples with your own metrics, and the `series` list in the chart card with real numbers. The table is a plain `ShadcnTable`, so it takes any `ShadcnTableRow` list.
