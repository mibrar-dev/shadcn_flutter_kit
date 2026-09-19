// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/material.dart';
import '../country_flag/country_flag.dart';

/// Core class used by the country flag component.
class CountryFlagPreview extends StatelessWidget {
  const CountryFlagPreview({super.key});

  /// Builds the widget tree for country flag.
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            spacing: 16,
            children: [
              // Country code lookups
              Wrap(
                spacing: 8,
                children: [
                  CountryFlag.fromCountryCode('US'),
                  CountryFlag.fromCountryCode('DE'),
                  CountryFlag.fromCountryCode('JP'),
                ],
              ),
              // Currency and dial code lookups
              Wrap(
                spacing: 8,
                children: [
                  CountryFlag.fromCurrencyCode('EUR'),
                  CountryFlag.fromPhonePrefix('+81'),
                ],
              ),
              // Shaped flag
              Wrap(
                spacing: 8,
                children: [
                  CountryFlag.fromCountryCode(
                    'CA',
                    width: 32,
                    height: 24,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
