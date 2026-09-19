// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../phone_input.dart';

/// Represents a phone number with country code information.
///
/// [PhoneNumber] combines a country (with dial code) and a phone number
/// string to create a complete international phone number.
///
/// The [country] is nullable: a `null` country means no country could be
/// detected (yet) from the input, and [value] is `null` in that case.
///
/// Example:
/// ```
/// final phone = PhoneNumber(
///   Country(dialCode: '+1', code: 'US'),
///   '5551234567',
/// );
/// print(phone.fullNumber); // +15551234567
/// ```
class PhoneNumber {
  /// The country associated with this phone number.
  ///
  /// May be `null` when no country has been detected from the input.
  final Country? country;

  /// The phone number without the country code.
  final String number; // without country code

  /// Creates a [PhoneNumber] with the specified country and number.
  const PhoneNumber(this.country, this.number);

  /// Creates a copy with a new country.
  PhoneNumber withCountry(Country? country) {
    return PhoneNumber(country, number);
  }

  /// Gets the complete phone number including country code.
  String get fullNumber =>
      country != null ? '${country!.dialCode}$number' : number;

  /// Gets the complete phone number with a plus sign prefix.
  String get fullCodeNumber =>
      country != null ? '+${country!.dialCode}$number' : number;

  /// Gets the full number or null if the number is empty.
  String? get value => number.isEmpty || country == null ? null : fullNumber;

  /// Returns a debug-friendly string representation.
  @override
  String toString() {
    return number.isEmpty ? '' : fullNumber;
  }

  /// Compares this object with another for value equality.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PhoneNumber &&
        other.country == country &&
        other.number == number;
  }

  @override
  int get hashCode {
    return country.hashCode ^ number.hashCode;
  }
}
