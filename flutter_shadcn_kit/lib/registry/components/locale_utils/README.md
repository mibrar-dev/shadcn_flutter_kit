# Locale Utils

Byte-size formatting against a configurable unit table. This is the locale
layer of file-size display: the file components format with the registry's
fixed ladder, while this component lets callers pick the base, the unit labels
and the digit separator (for example a binary byte table or a decimal one).

## When to use

- Showing a human-readable size for a byte count with locale-specific units.
- Tests that pin an exact unit ladder or separator.

## Snippets

```dart
SizeUnitLocale.fileBytes.format(1536); // '1.5 KB'
SizeUnitLocale.binaryBytes.format(1024); // '1 KiB'
```

Custom table:

```dart
const SizeUnitLocale decimal = SizeUnitLocale(
  1000,
  <String>['B', 'kB', 'MB'],
  separator: ' ',
);
decimal.format(1234567); // '1.2 MB'
```

Values past the last unit stay in that unit instead of overflowing the table.

## API

| Member | Type | Notes |
|---|---|---|
| `SizeUnitLocale(base, units, {separator})` | const ctor | `base` is the step between units |
| `fileBytes` | `SizeUnitLocale` | `B`, `KB`, `MB`, … (base 1024) |
| `binaryBytes` | `SizeUnitLocale` | `B`, `KiB`, `MiB`, … (base 1024) |
| `format(bytes)` | `String` | `0 <unit>` for zero/negative counts |

## Differences from the old `locale_utils`

- `DatePart` / `TimePart` / `DurationPart` and the range helpers live in
  `primitives/localizations/locale_parts.dart` now.
- The top-level `formatFileSize` was not re-declared: `primitives/file_value`
  owns that name. Use `SizeUnitLocale.format`.
- `fileBits` was renamed `binaryBytes`; it always contained binary *bytes*
  (`KiB`, `MiB`, …) and its first label is now a plain `B`.
- Fixed: values past the largest unit no longer throw `RangeError`; the table
  index is clamped and the value stays in the last unit.
- Fixed: `separator` is applied (the old field was never read).
- Dropped: `getUnit`, which returned a unit label from a value but was never
  read in the old tree.
