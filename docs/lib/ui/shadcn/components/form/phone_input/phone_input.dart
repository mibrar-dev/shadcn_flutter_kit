// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart' hide Theme, TextField;
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:phonecodes/phonecodes.dart';

import '../../../shared/primitives/form_value_supplier.dart';
import '../../../shared/primitives/overlay.dart';
import '../../../shared/primitives/text.dart';
import '../../../shared/theme/theme.dart';
import '../../../shared/utils/style_value.dart';
import '../select/select.dart';
import '../text_field/text_field.dart';

part '_impl/core/phone_number.dart';

part '_impl/state/_phone_input_state.dart';
part '_impl/themes/base/phone_input_theme.dart';

/// A specialized input widget for entering international phone numbers.
///
/// This widget provides a comprehensive phone number input interface with
/// country selection, automatic formatting, and validation. It displays a
/// country flag, country code, and a text field for the phone number,
/// handling the complexities of international phone number formats.
///
/// The component automatically filters input to ensure only valid phone
/// number characters are entered, and provides a searchable country
/// selector popup for easy country selection. It integrates with the form
/// system to provide phone number validation and data collection.
///
/// Example:
/// ```
/// PhoneInput(
///   initialCountry: Country.unitedStates,
///   onChanged: (phoneNumber) {
///     print('Phone: ${phoneNumber.fullNumber}');
///     print('Country: ${phoneNumber.country.name}');
///   },
///   searchPlaceholder: Text('Search countries...'),
/// )
/// ```
class PhoneInput extends StatefulWidget {
  /// The default country to display when no initial value is provided.
  ///
  /// If both [initialCountry] and [initialValue] are null, defaults to
  /// United States. When [initialValue] is provided, its country takes
  /// precedence over this setting.
  final Country? initialCountry;

  /// The initial phone number value including country and number.
  ///
  /// When provided, both the country selector and number field are
  /// initialized with the values from this phone number. Takes precedence
  /// over [initialCountry] for country selection.
  final PhoneNumber? initialValue;

  /// Callback invoked when the phone number changes.
  ///
  /// Called whenever the user changes either the country selection or
  /// the phone number text. The callback receives a [PhoneNumber] object
  /// containing both the selected country and entered number.
  final ValueChanged<PhoneNumber>? onChanged;

  /// Optional text editing controller for the number input field.
  ///
  /// When provided, this controller manages the text content of the phone
  /// number input field. If null, an internal controller is created and managed.
  final TextEditingController? controller;

  /// Whether to filter out plus (+) symbols from input.
  ///
  /// When true, plus symbols are automatically removed from user input
  /// since the country code already provides the international prefix.
  final bool filterPlusCode;

  /// Whether to filter out leading zeros from input.
  ///
  /// When true, leading zeros are automatically removed from the phone number
  /// to normalize the input format according to international standards.
  final bool filterZeroCode;

  /// Whether to filter out country codes from input.
  ///
  /// When true, prevents users from entering the country code digits manually
  /// since the country selector provides this information automatically.
  final bool filterCountryCode;

  /// Whether to allow only numeric characters in the input.
  ///
  /// When true, restricts input to numeric characters only, removing
  /// any letters, symbols, or formatting characters that users might enter.
  final bool onlyNumber;

  /// Optional list of countries to display in the country selector.
  ///
  /// When provided, only these countries will be available for selection
  /// in the country picker popup. If null, all supported countries are available.
  final List<Country>? countries;

  /// Widget displayed as placeholder in the country search field.
  ///
  /// Appears in the search input at the top of the country selector popup
  /// to guide users on how to search for countries.
  final Widget? searchPlaceholder;

  /// Creates a [PhoneInput] widget.
  ///
  /// The widget can be initialized with a specific country or complete phone
  /// number. Various filtering options control how user input is processed
  /// to ensure valid phone number format.
  ///
  /// Parameters:
  /// - [initialCountry] (Country?, optional): Default country when no initial value provided
  /// - [initialValue] (PhoneNumber?, optional): Complete initial phone number with country
  /// - [onChanged] (`ValueChanged<PhoneNumber>?`, optional): Callback for phone number changes
  /// - [controller] (TextEditingController?, optional): Controller for the number input field
  /// - [filterPlusCode] (bool, default: true): Whether to filter out plus symbols
  /// - [filterZeroCode] (bool, default: true): Whether to filter out leading zeros
  /// - [filterCountryCode] (bool, default: true): Whether to filter out country codes
  /// - [onlyNumber] (bool, default: true): Whether to allow only numeric input
  /// - [countries] (`List<Country>?`, optional): Specific countries to show in selector
  /// - [searchPlaceholder] (Widget?, optional): Placeholder for country search field
  ///
  /// Example:
  /// ```
  /// PhoneInput(
  ///   initialCountry: Country.canada,
  ///   filterPlusCode: true,
  ///   onChanged: (phone) => _validatePhoneNumber(phone),
  /// );
  /// ```
  const PhoneInput({
    super.key,
    this.initialCountry,
    this.initialValue,
    this.onChanged,
    this.controller,
    this.filterPlusCode = true,
    this.filterZeroCode = true,
    this.filterCountryCode = true,
    this.onlyNumber = true,
    this.countries,
    this.searchPlaceholder,
  });

  /// Creates the `State` object for this widget.
  @override
  State<PhoneInput> createState() => _PhoneInputState();
}

/// Extension helpers for form-related types.
extension _WidgetAsPopupBuilder on Widget {
  SelectPopupBuilder get asBuilder =>
      (_) => this;
}
