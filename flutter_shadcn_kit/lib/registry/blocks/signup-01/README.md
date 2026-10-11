# Signup 01 (`signup-01`)

A create-account card with name, email, password and a terms checkbox.

Block category: **Authentication** · viewport: **desktop**.

## Files

- `signup_01.dart`

The public widget (`signup_01.dart`) is the preview: render it exactly as
an app would.

## Install

```sh
flutter_shadcn add signup-01
```

```dart
import 'package:<your_app>/ui/shadcn/blocks/signup-01/signup_01.dart';

void main() => runApp(const Signup01());
```

## Declared dependencies

The block installs with exactly these layers on top of it:

| Layer | Units |
|---|---|
| `foundation` | `gap` |
| `theme` | `theme` |
| `components` | `button`, `card`, `checkbox`, `input` |

## Notes

A single-card sign-up. The terms row uses `Checkbox` plus an `Expanded` text so the copy wraps instead of overflowing on a phone.
