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
                SizedBox(height: ShadcnTheme.of(context).spacing.sm),
                TimePicker(value: null, onChanged: (_) {}),
                SizedBox(height: ShadcnTheme.of(context).spacing.xl),
                const Text('Filled trigger (24h)'),
                SizedBox(height: ShadcnTheme.of(context).spacing.sm),
                TimePicker(
                  value: const TimeOfDay(hour: 14, minute: 30),
                  onChanged: (_) {},
                  use24HourFormat: true,
                ),
                SizedBox(height: ShadcnTheme.of(context).spacing.xl),
                const Text('Duration trigger'),
                SizedBox(height: ShadcnTheme.of(context).spacing.sm),
                DurationPicker(
                  value: const Duration(hours: 1, minutes: 30),
                  onChanged: (_) {},
                ),
                SizedBox(height: ShadcnTheme.of(context).spacing.xl),
                const Text('Inline sheets'),
                SizedBox(height: ShadcnTheme.of(context).spacing.sm),
                const TimePickerDialog(use24HourFormat: true),
                SizedBox(height: ShadcnTheme.of(context).spacing.lg),
                const DurationPickerDialog(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
