// Widgets-only preview gallery for the `date_picker` component.

import 'package:flutter/widgets.dart';

import '../../theme/theme.dart';
import '../calendar/calendar.dart';
import 'date_picker.dart';

/// Preview entry point used by the docs gallery.
class DatePickerPreview extends StatelessWidget {
  /// Creates the preview.
  const DatePickerPreview({super.key});

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
                DatePicker(value: null, onChanged: (_) {}),
                const SizedBox(height: 24),
                const Text('Filled trigger'),
                const SizedBox(height: 8),
                DatePicker(value: DateTime(2024, 3, 14), onChanged: (_) {}),
                const SizedBox(height: 24),
                const Text('Range trigger'),
                const SizedBox(height: 8),
                DateRangePicker(value: null, onChanged: null),
                const SizedBox(height: 24),
                const Text('Inline dialog sheet'),
                const SizedBox(height: 8),
                const DatePickerDialog(
                  selectionMode: CalendarSelectionMode.single,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
