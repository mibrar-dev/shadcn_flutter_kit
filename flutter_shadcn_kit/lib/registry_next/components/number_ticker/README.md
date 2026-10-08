# NumberTicker

Animated number that counts between values, either as formatted text or
through a custom builder, plus flip-clock rollers (`TextFlipper`) for
character-level animation. Widgets-only; formatting is user-supplied, so
there is no package dependency (pair with `intl` formatters in your app).

## When to use

- Animated counters, balances, scores, compact stats (`1.2K`).
- Flip-clock or slot-machine character animation.

## Snippets

Plain with decimals:

```dart
NumberTicker(
  number: balance,
  formatter: (value) => value.toStringAsFixed(2),
);
```

Compact with `intl` (already an app dependency):

```dart
import 'package:intl/intl.dart' as intl;

NumberTicker(
  number: followers,
  formatter: (value) => intl.NumberFormat.compact().format(value),
);
```

Custom builder:

```dart
NumberTicker.builder(
  number: score,
  builder: (context, value, _) => Text('${value.toInt()} pts'),
);
```

Flip clock:

```dart
TextFlipper(charset: FlipperCharset.numbers, text: code);
```

## `NumberTicker` API

| Parameter | Type | Default | Notes |
|---|---|---|---|
| `number` | `num` | required | target value |
| `initialNumber` | `num?` | null | first animation runs from here; null starts at `number` |
| `formatter` | `NumberTickerFormatted` | required (text ctor) | `(double) => String` |
| `builder` / `child` | `NumberTickerBuilder?` / `Widget?` | (builder ctor) | custom content |
| `duration` | `Duration?` | theme (500ms) | animation duration |
| `curve` | `Curve?` | theme (`easeInOut`) | animation curve |
| `style` | `TextStyle?` | theme (ambient) | text style |
| `theme` | `NumberTickerTheme?` | null | widget-leg override |

`FlipperCharset` has `numbers`, `uppercase`, `lowercase`, `letters`,
`alphanumeric`, `symbols` and `all` pools (combinable with `+`).

## Differences from old `number_ticker`

- The app-wide theme leg now applies (old code read only the widget and
  scoped legs, so app overrides were silently ignored).
- The flipper gradient mask uses const white stops instead of importing
  `material.dart` for `Colors.white`.
- `intl` stays out of the component: only the preview/README format with
  `NumberFormat` (per the orchestrator `intl` ruling, it remains available
  to apps as a direct dependency).
