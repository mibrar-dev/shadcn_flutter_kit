# Verify Email 01 (`otp-01`)

A one-time-code verification card with a resend countdown.

Block category: **Authentication** · viewport: **desktop**.

## Files

- `otp_01.dart`

The public widget (`otp_01.dart`) is the preview: render it exactly as
an app would.

## Install

```sh
flutter_shadcn add otp-01
```

```dart
import 'package:<your_app>/ui/shadcn/blocks/otp-01/otp_01.dart';

void main() => runApp(const Otp01());
```

## Declared dependencies

The block installs with exactly these layers on top of it:

| Layer | Units |
|---|---|
| `foundation` | `gap` |
| `theme` | `theme` |
| `components` | `button`, `card`, `divider`, `input_otp` |

## Notes

`InputOtp` owns the slots and the controller; the block only adds the shell and a local `_secondsLeft` counter for the resend row. Wire `onCompleted` on the `InputOtp` to verify the code.
