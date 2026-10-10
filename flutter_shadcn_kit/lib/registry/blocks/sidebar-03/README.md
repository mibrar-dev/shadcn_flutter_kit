# Sidebar 03 (`sidebar-03`)

A full app shell: header with breadcrumb and search, grouped sidebar and content.

Block category: **Sidebar** · viewport: **desktop**.

## Files

- `sidebar_03.dart`

The public widget (`sidebar_03.dart`) is the preview: render it exactly as
an app would.

## Install

```sh
flutter_shadcn add sidebar-03
```

```dart
import 'package:<your_app>/ui/shadcn/blocks/sidebar-03/sidebar_03.dart';

void main() => runApp(const Sidebar03());
```

## Declared dependencies

The block installs with exactly these layers on top of it:

| Layer | Units |
|---|---|
| `foundation` | `gap`, `icons` |
| `theme` | `theme` |
| `components` | `avatar`, `badge`, `breadcrumb`, `button`, `card`, `divider`, `input`, `progress` |

## Notes

This is the shell: keep `_Sidebar03Header`, `Sidebar03Sidebar` and `Sidebar03Content` and drop your own screen in place of the content. Selection is lifted to `Sidebar03` so the header's breadcrumb follows it.
