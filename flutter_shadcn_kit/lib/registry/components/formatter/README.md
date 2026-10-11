# formatter

`TextInputFormatters` is the public surface: a factory set over the
`TextInputFormatter` implementations — uppercase/lowercase, integer and decimal
numeric (min/max clamps, fixed decimals), time padding, math expressions, hex,
and a selection-clamping helper.

Reach the implementations through the factory set, not through their
constructors. The classes stay public only so `time_picker` and the duration
inputs can import `TimeFormatter`; they are not the documented entry point.

```dart
TextField(
  inputFormatters: <TextInputFormatter>[
    TextInputFormatters.integerOnly(min: 0, max: 100),
    TextInputFormatters.hex(hashPrefix: true),
  ],
)
```

Every factory returns a `TextInputFormatter`, so the set composes freely and
nothing has to be constructed by hand:

```dart
TextInputFormatters.toUpperCase        // 'ABC'
TextInputFormatters.toLowerCase       // 'abc'
TextInputFormatters.time(length: 2)   // '09'
TextInputFormatters.integerOnly(min: 0, max: 100)
TextInputFormatters.digitsOnly(min: 0, max: 1, decimalDigits: 2)
TextInputFormatters.mathExpression()  // '2+2' -> '4'
TextInputFormatters.hex()             // '#ff8800'
```

## API

| Member | Type | Notes |
|---|---|---|
| `toUpperCase` | `TextInputFormatter` | uppercases every edit |
| `toLowerCase` | `TextInputFormatter` | lowercases every edit |
| `time({required length})` | `TextInputFormatter` | pads/trims to `length` with leading zeros (`HH` = 2, `HHmm` = 4) |
| `integerOnly({min, max})` | `TextInputFormatter` | integer text with optional int clamps |
| `digitsOnly({min, max, decimalDigits})` | `TextInputFormatter` | decimal text with optional double clamps / fixed places |
| `mathExpression({context})` | `TextInputFormatter` | evaluates the expression each edit; empty when unparsable |
| `hex({hashPrefix})` | `TextInputFormatter` | `0-9a-fA-F` only, optional leading `#` |
| `constraintToNewText(value, text)` | `TextSelection` | clips a selection into `text`; shared by the numeric formatters |

Implementation classes — public, but reachable through the factories above:

| Class | Constructor |
|---|---|
| `TimeFormatter({required length})` | `TextInputFormatters.time(length: …)` |
| `IntegerTextFormatter({min, max})` | `TextInputFormatters.integerOnly(…)` |
| `NumberTextFormatter({min, max, decimalDigits})` | `TextInputFormatters.digitsOnly(…)` |
| `HexTextFormatter({hashPrefix})` | `TextInputFormatters.hex(…)` |
| `MathExpressionFormatter({context})` | `TextInputFormatters.mathExpression(…)` |
| `ToUpperCaseTextFormatter()` | `TextInputFormatters.toUpperCase` |
| `ToLowerCaseTextFormatter()` | `TextInputFormatters.toLowerCase` |

`TimeFormatter` is public because `time_picker` and the duration inputs import
it; the old `_TimeFormatter` was private and its `time_picker` copy had drifted
(hard-coded length 2). The numeric formatters clamp the *signed* value, so
`-5` with `min: 0` clamps to `0` instead of staying negative.
