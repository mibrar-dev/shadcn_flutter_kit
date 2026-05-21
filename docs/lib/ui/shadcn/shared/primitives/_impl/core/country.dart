// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../phone_number.dart';

/// Country defines a reusable type for this registry module.
class Country {
  /// The international dial code (e.g. "+1").
  final String dialCode;

  /// The ISO 2-letter country code.
  final String code;

  /// Creates a [Country] descriptor.
  const Country({required this.dialCode, required this.code});
}

/// Represents an international phone number with an associated country.
