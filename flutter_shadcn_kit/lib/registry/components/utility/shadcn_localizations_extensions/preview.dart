// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/material.dart' hide TimeOfDay;

import '../../../shared/utils/util.dart';
import '../shadcn_localizations_en/shadcn_localizations_en.dart';
import '../shadcn_localizations_extensions/shadcn_localizations_extensions.dart';

/// ShadcnLocalizationsExtensionsPreview defines a reusable type for this registry module.
class ShadcnLocalizationsExtensionsPreview extends StatelessWidget {
  const ShadcnLocalizationsExtensionsPreview({super.key});

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    final localizations = ShadcnLocalizationsEn();
    final formattedTime = localizations.formatTimeOfDay(
      /// Creates a `TimeOfDay` instance.
      const TimeOfDay(hour: 18, minute: 45, second: 12),
      use24HourFormat: true,
      showSeconds: true,
    );
    final formattedDuration = localizations.formatDuration(
      /// Creates a `Duration` instance.
      const Duration(hours: 2, minutes: 30),
    );
    return Scaffold(
      body: Center(child: Text('$formattedTime • $formattedDuration')),
    );
  }
}
