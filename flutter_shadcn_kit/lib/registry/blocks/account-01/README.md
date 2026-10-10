# Account 01 (`account-01`)

An account settings screen with a tab strip and a profile form.

Block category: **Settings & Account** · viewport: **desktop**.

## Files

- `account_01.dart`

The public widget (`account_01.dart`) is the preview: render it exactly as
an app would.

## Install

```sh
flutter_shadcn add account-01
```

```dart
import 'package:<your_app>/ui/shadcn/blocks/account-01/account_01.dart';

void main() => runApp(const Account01());
```

## Declared dependencies

The block installs with exactly these layers on top of it:

| Layer | Units |
|---|---|
| `foundation` | `gap` |
| `theme` | `theme` |
| `components` | `alert`, `avatar`, `button`, `card`, `divider`, `input`, `tabs`, `text_area` |

## Notes

The tab strip is static; give `Tabs` an `onChanged` and a state index to make it interactive. The form fields are `Input`s paired with a `Text` label.
