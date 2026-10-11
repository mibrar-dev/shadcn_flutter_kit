# Dashboard 02 (`dashboard-02`)

An analytics workspace with a visitors chart, a device split and traffic sources.

Block category: **Dashboard** · viewport: **desktop**.

## Files

- `dashboard_02.dart`
- `dashboard_02_sections.dart`

The public widget (`dashboard_02.dart`) is the preview: render it exactly as
an app would.

## Install

```sh
flutter_shadcn add dashboard-02
```

```dart
import 'package:<your_app>/ui/shadcn/blocks/dashboard-02/dashboard_02.dart';

void main() => runApp(const Dashboard02());
```

## Declared dependencies

The block installs with exactly these layers on top of it:

| Layer | Units |
|---|---|
| `foundation` | `gap` |
| `theme` | `theme` |
| `components` | `button`, `card`, `divider`, `input`, `progress`, `tabs` |

## Notes

The tiles are a four-item list; `columns` comes from the `LayoutBuilder` breakpoints, so adding a fifth tile just widens the wrap. The sparkline painter takes one `fill` ratio instead of a data series.
