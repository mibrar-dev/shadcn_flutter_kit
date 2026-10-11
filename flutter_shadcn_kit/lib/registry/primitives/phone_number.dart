// Phone number + country value types shared by `form` and `phone_input`.
//
// Ported from `shared/primitives/phone_number.dart` (Country) plus the
// superset `PhoneNumber` body from
// `components/form/phone_input/_impl/core/phone_number.dart` (OWNERSHIP.md:
// the phone_input copy is the behaviour-complete one).
//
// `Country.dialCode` keeps the shared convention of including the `+`
// (e.g. `+1`); `fullCodeNumber` adds a `+` only when the dial code lacks one,
// so both old conventions produce a single-prefix result.

/// ISO country descriptor for a phone number.
class Country {
  /// International dial code, e.g. `+1`.
  final String dialCode;

  /// ISO 3166-1 alpha-2 country code, e.g. `US`.
  final String code;

  /// Creates a [Country].
  const Country({required this.dialCode, required this.code});

  @override
  bool operator ==(Object other) {
    return other is Country && other.dialCode == dialCode && other.code == code;
  }

  @override
  int get hashCode => Object.hash(dialCode, code);

  @override
  String toString() => code;
}

/// An international phone number: a country (nullable while unknown) and the
/// national number without the country code.
class PhoneNumber {
  /// The country associated with this number; null when undetected.
  final Country? country;

  /// The number without the country code.
  final String number;

  /// Creates a [PhoneNumber].
  const PhoneNumber(this.country, this.number);

  /// Returns a copy with a different [country].
  PhoneNumber withCountry(Country? country) {
    return PhoneNumber(country, number);
  }

  /// The dial code followed by the number, or just the number when the
  /// country is unknown.
  String get fullNumber =>
      country != null ? '${country!.dialCode}$number' : number;

  /// Like [fullNumber] but always prefixed with a single `+`.
  String get fullCodeNumber {
    final dialCode = country?.dialCode;
    if (dialCode == null) return number;
    return dialCode.startsWith('+') ? '$dialCode$number' : '+$dialCode$number';
  }

  /// The full number, or null when the number is empty or the country is
  /// unknown.
  String? get value => number.isEmpty || country == null ? null : fullNumber;

  @override
  String toString() {
    return number.isEmpty ? '' : fullNumber;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PhoneNumber &&
        other.country == country &&
        other.number == number;
  }

  @override
  int get hashCode => country.hashCode ^ number.hashCode;
}
