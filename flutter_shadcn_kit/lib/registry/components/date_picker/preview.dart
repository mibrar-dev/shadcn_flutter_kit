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
                SizedBox(height: ShadcnTheme.of(context).spacing.sm),
                DatePicker(value: null, onChanged: (_) {}),
                SizedBox(height: ShadcnTheme.of(context).spacing.xl),
                const Text('Filled trigger'),
                SizedBox(height: ShadcnTheme.of(context).spacing.sm),
                DatePicker(value: DateTime(2024, 3, 14), onChanged: (_) {}),
                SizedBox(height: ShadcnTheme.of(context).spacing.xl),
                const Text('Range trigger'),
                SizedBox(height: ShadcnTheme.of(context).spacing.sm),
                DateRangePicker(value: null, onChanged: null),
                SizedBox(height: ShadcnTheme.of(context).spacing.xl),
                const Text('Inline dialog sheet'),
                SizedBox(height: ShadcnTheme.of(context).spacing.sm),
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
