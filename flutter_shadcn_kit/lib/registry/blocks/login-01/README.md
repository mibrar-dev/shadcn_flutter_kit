# Login 01 (`login-01`)

A centred sign-in card with email, password and a create-account link.

Block category: **Authentication** · viewport: **desktop**.

## Files

- `login_01.dart`

The public widget (`login_01.dart`) is the preview: render it exactly as
an app would.

## Install

```sh
flutter_shadcn add login-01
```

```dart
import 'package:<your_app>/ui/shadcn/blocks/login-01/login_01.dart';

void main() => runApp(const Login01());
```

## Declared dependencies

The block installs with exactly these layers on top of it:

| Layer | Units |
|---|---|
| `foundation` | `gap` |
| `theme` | `theme` |
| `components` | `button`, `card`, `checkbox`, `divider`, `input` |

## Notes

The card is constrained to 400px and scrolls when the host is short, so it works as a full page and as a dialog. `Input` has no built-in label, so the labels are the `Text` rows above each field.
