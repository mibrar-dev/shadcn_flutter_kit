# PhoneInput (`phone_input`)

A searchable country selector (flag + dial code) beside a national-number
field, with form integration and the built-in `PhoneNumberValidator`.

## When to use

- You need an international phone field with a country picker.
- You want the phone value in forms as a `PhoneNumber` (country + number).

Avoid when a plain text field is enough — use `input`.

## Install

```bash
flutter_shadcn add phone_input
```

## Import

```dart
import 'package:<your_app>/ui/shadcn/phone_input/phone_input.dart';
```

## Minimal example

```dart
PhoneInput(
  initialCountry: const Country(dialCode: '+1', code: 'US'),
  onChanged: (value) => setState(() => _phone = value),
)
```

## Common patterns

### Initial value

```dart
PhoneInput(
  initialValue: const PhoneNumber(
    Country(dialCode: '+62', code: 'ID'),
    '812345678',
  ),
  onChanged: (value) => setState(() => _phone = value),
)
```

### Form field with validation

```dart
ShadcnFormField<PhoneNumber>(
  key: const FormKey<PhoneNumber>('phone'),
  label: const Text('Phone'),
  validator: const PhoneNumberValidator(),
  child: PhoneInput(onChanged: (value) => setState(() => _phone = value)),
)
```

### Restricting the country list

```dart
PhoneInput(
  countries: const <CountryInfo>[
    CountryInfo('GB', '+44', 'GBP', 'United Kingdom'),
    CountryInfo('IE', '+353', 'EUR', 'Ireland'),
  ],
  onChanged: (value) => setState(() => _phone = value),
)
```

## API

- `PhoneInput(initialCountry, initialValue, onChanged, controller, onlyNumber,
  countries, searchPlaceholder, theme)`.
- `PhoneNumberValidator(invalidMessage, emptyMessage)` — fails on null and on
  a country-less or empty number (no format/length rule is invented).
- `PhoneInputTheme` — per-component metrics; `phoneInputDefaults`,
  `phoneInputThemeOverrides`.
- Re-exported value types: `Country`, `PhoneNumber` (from
  `primitives/phone_number.dart`), `CountryInfo` (from
  `primitives/countries.dart`).

### Theme fields

| Field | Default | Effect |
|---|---|---|
| `inputPadding` | 12/8 | number field padding |
| `maxWidth` | 200 | number field width |
| `selectWidth` | 180 | country selector width (popup is trigger-wide) |
| `popupConstraints` | 250x300 | popup max size |
| `flagWidth` / `flagHeight` | 24/18 | flag size |
| `flagGap` | 8 | flag-to-code/name gap |
| `fieldGap` | 8 | selector-to-field gap |
| `countryGap` | 16 | name-to-dial-code gap in rows |

Resolution: widget `theme` > nearest `ComponentTheme<PhoneInputTheme>` >
`ComponentThemes` app overrides > `phoneInputDefaults`.

## Typed prefixes

Typing a `+` dial code selects the matching country: the longest dial-code
match wins, and among equal-length matches the current selection wins, then
the row marked `primary` (`+1` → US, `+7` → RU, `+44` → GB, `+590` → GP, ...),
otherwise the first row of the supplied list. The prefix stays in the field;
`PhoneNumber.number` is the national number.

```dart
// typing "+44555" selects the first +44 row of the list and reports
// PhoneNumber(Country(dialCode: '+44', code: 'GB'), '555')
PhoneInput(countries: const <CountryInfo>[
  CountryInfo('GB', '+44', 'GBP', 'United Kingdom'),
], onChanged: (value) => setState(() => _phone = value))
```

## Differences from the old `PhoneInput`

- The field carries an optional dial-code prefix plus the national number.
  Typed-prefix detection is restored (longest match; shared codes prefer the
  current selection, then the `primary` row). Switching the selector rewrites
  the prefix **with clamped selection offsets** — the old `_updateCountry`
  subtracted the code length unchecked and could assert or corrupt the caret.
- `onChanged` reports null while the national number is empty (the old widget
  never reported null and could disagree with its form value).
- The internally created controller is disposed; swapping `controller`
  re-attaches cleanly (the old code leaked the old controller).
- `searchPlaceholder` is wired to the select search field (it was dead).
- Country search is case-insensitive and matches name, ISO code or dial code.
- The deprecated `filterPlusCode` / `filterZeroCode` / `filterCountryCode`
  no-ops and the four dead theme config files are deleted; the number
  formatter keeps digits plus one leading `+` (no forced prefix).
- `countries` is a `List<CountryInfo>` (names live in the table primitive)
  and bounds both the selector and detection.
