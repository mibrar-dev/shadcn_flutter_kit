// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../phone_input.dart';

/// Represents a phone number with country code information.
///
/// [PhoneNumber] combines a country (with dial code) and a phone number
/// string to create a complete international phone number.
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
  final Country country;

  /// The phone number without the country code.
  final String number;

  /// Creates a [PhoneNumber] with the specified country and number.
  const PhoneNumber(this.country, this.number);

  /// Gets the complete phone number including country code.
  String get fullNumber => '${country.dialCode}$number';

  /// Gets the full number or null if the number is empty.
  String? get value => number.isEmpty ? null : fullNumber;

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
