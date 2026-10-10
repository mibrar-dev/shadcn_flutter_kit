# Login 03 (`login-03`)

A sign-in card with social provider buttons and an email form.

Block category: **Authentication** · viewport: **desktop**.

## Files

- `login_03.dart`

The public widget (`login_03.dart`) is the preview: render it exactly as
an app would.

## Install

```sh
flutter_shadcn add login-03
```

```dart
import 'package:<your_app>/ui/shadcn/blocks/login-03/login_03.dart';

void main() => runApp(const Login03());
```

## Declared dependencies

The block installs with exactly these layers on top of it:

| Layer | Units |
|---|---|
| `foundation` | `gap`, `icons` |
| `theme` | `theme` |
| `components` | `button`, `card`, `divider`, `input` |

## Notes

The provider row is two `Expanded` outline buttons; the icons come from `LucideIcons`. Add a third provider by widening the constraint.
