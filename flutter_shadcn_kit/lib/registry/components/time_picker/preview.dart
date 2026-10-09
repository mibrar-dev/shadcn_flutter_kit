// Widgets-only preview gallery for the `time_picker` component.

import 'package:flutter/widgets.dart';

import '../../foundation/time_of_day.dart';
import '../../theme/theme.dart';
import 'time_picker.dart';

/// Preview entry point used by the docs gallery.
class TimePickerPreview extends StatelessWidget {
  /// Creates the preview.
  const TimePickerPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return ShadcnTheme(
      data: const ShadcnThemeData(),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: ColoredBox(
          color: const ShadcnThemeData().colors.background,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text('Empty trigger'),
                const SizedBox(height: 8),
                TimePicker(value: null, onChanged: (_) {}),
                const SizedBox(height: 24),
                const Text('Filled trigger (24h)'),
                const SizedBox(height: 8),
                TimePicker(
                  value: const TimeOfDay(hour: 14, minute: 30),
                  onChanged: (_) {},
                  use24HourFormat: true,
                ),
                const SizedBox(height: 24),
                const Text('Duration trigger'),
                const SizedBox(height: 8),
                DurationPicker(
                  value: const Duration(hours: 1, minutes: 30),
                  onChanged: (_) {},
                ),
                const SizedBox(height: 24),
                const Text('Inline sheets'),
                const SizedBox(height: 8),
                const TimePickerDialog(use24HourFormat: true),
                const SizedBox(height: 16),
                const DurationPickerDialog(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
