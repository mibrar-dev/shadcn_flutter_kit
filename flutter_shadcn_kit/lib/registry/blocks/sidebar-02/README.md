# Sidebar 02 (`sidebar-02`)

An inset sidebar whose navigation is grouped by section, above a sample screen.

Block category: **Sidebar** · viewport: **desktop**.

## Files

- `sidebar_02.dart`

The public widget (`sidebar_02.dart`) is the preview: render it exactly as
an app would.

## Install

```sh
flutter_shadcn add sidebar-02
```

```dart
import 'package:<your_app>/ui/shadcn/blocks/sidebar-02/sidebar_02.dart';

void main() => runApp(const Sidebar02());
```

## Declared dependencies

The block installs with exactly these layers on top of it:

| Layer | Units |
|---|---|
| `foundation` | `gap`, `icons` |
| `theme` | `theme` |
| `components` | `avatar`, `badge`, `button`, `card`, `divider`, `input`, `progress` |

## Notes

The groups are two `_Sidebar02Group` widgets; each item is a `Text` row, so replacing it with a `Button` or a router link is a one-line change.
