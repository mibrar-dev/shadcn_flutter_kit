# Sidebar 01 (`sidebar-01`)

A navigation rail that collapses to icons beside a sample mailbox screen.

Block category: **Sidebar** · viewport: **desktop**.

## Files

- `sidebar_01.dart`

The public widget (`sidebar_01.dart`) is the preview: render it exactly as
an app would.

## Install

```sh
flutter_shadcn add sidebar-01
```

```dart
import 'package:<your_app>/ui/shadcn/blocks/sidebar-01/sidebar_01.dart';

void main() => runApp(const Sidebar01());
```

## Declared dependencies

The block installs with exactly these layers on top of it:

| Layer | Units |
|---|---|
| `foundation` | `gap`, `icons` |
| `theme` | `theme` |
| `components` | `button`, `card`, `divider` |

## Notes

The rail is a list of `_Sidebar01Item(label, icon)`; pass `onSelected` (the block already does) to drive the selection, and swap the icon for yours.
