# Signup 02 (`signup-02`)

A two-column sign-up with a plan summary and a password strength meter.

Block category: **Authentication** · viewport: **desktop**.

## Files

- `signup_02.dart`

The public widget (`signup_02.dart`) is the preview: render it exactly as
an app would.

## Install

```sh
flutter_shadcn add signup-02
```

```dart
import 'package:<your_app>/ui/shadcn/blocks/signup-02/signup_02.dart';

void main() => runApp(const Signup02());
```

## Declared dependencies

The block installs with exactly these layers on top of it:

| Layer | Units |
|---|---|
| `foundation` | `gap`, `icons` |
| `theme` | `theme` |
| `components` | `button`, `card`, `checkbox`, `divider`, `input`, `progress` |

## Notes

The strength meter is four `Container`s driven by the chart tokens, so it re-themes with the preset. The aside stacks below the form under 960px.
