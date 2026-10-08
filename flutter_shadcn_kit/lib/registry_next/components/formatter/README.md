# formatter

Reusable `TextInputFormatter` factory set: uppercase/lowercase, integer and
decimal numeric (min/max clamps, fixed decimals), time padding, math
expressions, hex, and a selection-clamping helper.

```dart
TextField(
  inputFormatters: [
    TextInputFormatters.integerOnly(min: 0, max: 100),
    TextInputFormatters.hex(hashPrefix: true),
  ],
)
```

`TimeFormatter` is public — `time_picker` and duration inputs import it.
