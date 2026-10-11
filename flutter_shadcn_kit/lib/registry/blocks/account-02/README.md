# Account 02 (`account-02`)

A notifications preferences screen with per-channel switches.

Block category: **Settings & Account** · viewport: **desktop**.

## Files

- `account_02.dart`

The public widget (`account_02.dart`) is the preview: render it exactly as
an app would.

## Install

```sh
flutter_shadcn add account-02
```

```dart
import 'package:<your_app>/ui/shadcn/blocks/account-02/account_02.dart';

void main() => runApp(const Account02());
```

## Declared dependencies

The block installs with exactly these layers on top of it:

| Layer | Units |
|---|---|
| `foundation` | `gap` |
| `theme` | `theme` |
| `components` | `breadcrumb`, `button`, `card`, `checkbox`, `divider`, `switch` |

## Notes

Each channel row owns its own state; lift it into a controller if the app persists preferences. Quiet hours is a `Checkbox` rather than a time range widget.
