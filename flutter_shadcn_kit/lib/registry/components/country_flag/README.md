# CountryFlag

Flag tile for a country, looked up by ISO code, currency code or dial
prefix. With no theme builder, flags draw as Unicode regional-indicator
emoji (no assets, no extra dependency); provide a builder for real artwork.
Widgets-only; it imports no other component.

## When to use

- A flag next to a phone field, locale picker or address row.
- Anywhere a compact country glyph helps.

## Snippets

Minimal:

```dart
CountryFlag.fromCountryCode('US');
```

Other lookups (first table match wins on shared currencies/prefixes):

```dart
CountryFlag.fromCurrencyCode('JPY');
CountryFlag.fromPhonePrefix('+49');
```

Sized and clipped:

```dart
CountryFlag.fromCountryCode(
  'FR',
  width: 36,
  height: 27,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
);
```

Real artwork via a builder (e.g. backed by cached SVGs):

```dart
ComponentTheme<CountryFlagTheme>(
  data: CountryFlagTheme(
    builder: (context, details) => MyFlagImage(code: details.countryCode),
  ),
  child: CountryFlag.fromCountryCode('US'),
);
```

## `CountryFlag` API

| Parameter | Type | Default | Notes |
|---|---|---|---|
| `country` | `Country?` | required (default ctor) | null renders an empty box |
| `width` / `height` | `double?` | theme (24 / 18) | multiplied by the ambient scaling |
| `shape` | `ShapeBorder?` | theme (unclipped) | clip shape |
| `theme` | `CountryFlagTheme?` | null | widget-leg override |

Unknown codes render as an empty box of the requested size, keeping the
surrounding layout intact instead of throwing.

The emoji fallback exposes the resolved country name (or the raw code) as
its accessible label; the glyph itself is hidden from assistive technology.

## Differences from old `country_flag`

- The `phonecodes` package is gone: lookups run against the `countries`
  primitive table (ISO names, codes, dial codes, currencies), shared with
  the later `phone_input`.
- The emoji fallback derives from the ISO code mathematically instead of
  reading per-flag data.
- Non-ISO satellite/network entries are excluded from the table.
