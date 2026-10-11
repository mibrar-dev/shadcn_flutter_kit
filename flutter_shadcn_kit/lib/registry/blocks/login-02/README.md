# Login 02 (`login-02`)

A split sign-in page: the form beside a full-bleed image panel.

Block category: **Authentication** · viewport: **desktop**.

## Files

- `login_02.dart`

The public widget (`login_02.dart`) is the preview: render it exactly as
an app would.

## Install

```sh
flutter_shadcn add login-02
```

```dart
import 'package:<your_app>/ui/shadcn/blocks/login-02/login_02.dart';

void main() => runApp(const Login02());
```

## Declared dependencies

The block installs with exactly these layers on top of it:

| Layer | Units |
|---|---|
| `foundation` | `gap` |
| `theme` | `theme` |
| `components` | `button`, `image`, `input` |

## Notes

The image is a 48x48 PNG decoded from memory, so the block renders offline and in tests. Replace `_login02Photo` with your own `ImageProvider`; the split flips at 900px.
