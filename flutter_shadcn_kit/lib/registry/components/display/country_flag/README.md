# Country Flag (`country_flag`)

Flag display with emoji fallback and customizable artwork builder.

---

## When to use

- Use this when:
  - you need to show a country flag from a country, currency, or dial code.
  - you want emoji flags with an opt-in custom artwork builder.
- Avoid when:
  - you need a full country picker (see `phone_input`).

---

## Install

```bash
flutter_shadcn add country_flag
```

---

## Import

```dart
import 'package:<your_app>/ui/shadcn/display/country_flag/country_flag.dart';
```

---

## Minimal example

```dart
CountryFlag.fromCountryCode(
  'US',
)
```

---

## Common patterns

### Pattern: Lookup variants

```dart
Row(
  children: [
    CountryFlag.fromCountryCode('US'),
    CountryFlag.fromCurrencyCode('EUR'),
    CountryFlag.fromPhonePrefix('+81'),
  ],
)
```

---

## API

### Constructor

- `CountryFlag`
  - `country` (`Country?`, required positional)
  - `width` / `height` (`double?`)
  - `shape` (`ShapeBorder?`)
- `CountryFlag.fromCountryCode`, `CountryFlag.fromCurrencyCode`, `CountryFlag.fromPhonePrefix`
- `CountryFlag.emojiBuilder` — regional-indicator emoji fallback.
- `CountryFlagDetails` — `country`, `width`, `height`, `shape`, `countryCode`.
- `CountryFlagTheme` — `builder`, `width`, `height`, `shape`.

### Callbacks

- None — provide artwork via `CountryFlagTheme.builder`.

---

## Theming

- `CountryFlagTheme` provides default size, shape, and artwork builder.
- Set `builder` to swap emoji flags for real flag images.

---

## Accessibility

- Pair flags with a text label (country name or code) for clarity.

---

## Do / Don’t

**Do**
- ✅ Use flags alongside country names or codes.

**Don’t**
- ❌ Rely on emoji flags alone where platform rendering varies.

---

## Related components

- `phone_input`
- `avatar`
- `badge`

---

## Registry rules

- One public class per file
- Helpers under `_impl/`
