# Pricing 01 (`pricing-01`)

A pricing section with three plans and a highlighted middle tier.

Block category: **Marketing** · viewport: **desktop**.

## Files

- `pricing_01.dart`

The public widget (`pricing_01.dart`) is the preview: render it exactly as
an app would.

## Install

```sh
flutter_shadcn add pricing-01
```

```dart
import 'package:<your_app>/ui/shadcn/blocks/pricing-01/pricing_01.dart';

void main() => runApp(const Pricing01());
```

## Declared dependencies

The block installs with exactly these layers on top of it:

| Layer | Units |
|---|---|
| `foundation` | `gap`, `icons` |
| `theme` | `theme` |
| `components` | `badge`, `button`, `card`, `divider`, `input_otp` |

## Notes

The highlighted tier draws its border from the `primary` token and its fill from the `Card` default, so both survive a preset switch. Plans stack below 1080px.
