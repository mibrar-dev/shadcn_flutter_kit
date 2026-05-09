// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../phone_number.dart';

/// PhoneNumber defines a reusable type for this registry module.
class PhoneNumber {
  /// Country that owns this phone number.
  final Country country;

  /// Phone number digits without the country code.
  final String number;

  /// Creates a [PhoneNumber] for [country] and [number].
  const PhoneNumber(this.country, this.number);

  /// The combined dial code and number (e.g. +15551234567).
  String get fullNumber => '${country.dialCode}$number';

  /// Returns the dial code concatenated number or null when the number is empty.
  String? get value => number.isEmpty ? null : fullNumber;

  @override
  /// Executes `toString` behavior for this component/composite.
  String toString() {
    return number.isEmpty ? '' : fullNumber;
  }

  @override
  /// Executes `operator ==` behavior for this component/composite.
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PhoneNumber &&
        other.country == country &&
        other.number == number;
  }

  @override
  int get hashCode => Object.hash(country, number);
}
