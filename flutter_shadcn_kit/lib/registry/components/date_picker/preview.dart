// Named examples for the `date_picker` component (P6-F3 preview contract).
//
// One focused demo per example; the first entry is the default. Spacing comes
// from the ambient theme, so the examples follow the selected preset and the
// site light/dark toggle.

import 'package:flutter/widgets.dart';

import '../../foundation/component_preview.dart';
import '../../foundation/gap.dart';
import '../../primitives/form_core/object_form_field.dart';
import '../../theme/theme.dart';
import '../calendar/calendar.dart';
import 'date_picker.dart';

/// A label above a trigger.
class _DatePickerLabel extends StatelessWidget {
  const _DatePickerLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    return Text(
      text,
      style: TextStyle(fontSize: 12, color: theme.colors.mutedForeground),
    );
  }
}

/// The moment the examples show.
final DateTime _datePickerToday = DateTime(2024, 3, 14);

/// The single-date picker, empty and pre-filled.
Widget _datePickerSingle(BuildContext context) {
  final spacing = ShadcnTheme.of(context).spacing;
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      const _DatePickerLabel('Empty trigger'),
      Gap(spacing.sm),
      DatePicker(value: null, onChanged: (DateTime? value) {}),
      Gap(spacing.lg),
      const _DatePickerLabel('Filled trigger'),
      Gap(spacing.sm),
      DatePicker(value: _datePickerToday, onChanged: (DateTime? value) {}),
    ],
  );
}

/// The range picker, empty and pre-filled.
Widget _datePickerRange(BuildContext context) {
  final spacing = ShadcnTheme.of(context).spacing;
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      const _DatePickerLabel('Empty range trigger'),
      Gap(spacing.sm),
      DateRangePicker(value: null, onChanged: (DateTimeRange? value) {}),
      Gap(spacing.lg),
      const _DatePickerLabel('Filled range trigger'),
      Gap(spacing.sm),
      DateRangePicker(
        value: DateTimeRange(
          _datePickerToday,
          _datePickerToday.add(const Duration(days: 6)),
        ),
        onChanged: (DateTimeRange? value) {},
      ),
    ],
  );
}

/// The dialog prompt with a title.
Widget _datePickerDialog(BuildContext context) {
  return const DatePicker(
    value: null,
    mode: PromptMode.dialog,
    dialogTitle: Text('Pick a date'),
    onChanged: null,
  );
}

/// The disabled trigger.
Widget _datePickerDisabled(BuildContext context) {
  return const DatePicker(value: null, enabled: false, onChanged: null);
}

/// The inline calendar sheet, without a popover.
Widget _datePickerInline(BuildContext context) {
  return const SizedBox(
    width: 280,
    child: DatePickerDialog(selectionMode: CalendarSelectionMode.single),
  );
}

/// Named docs examples for `date_picker`; the first entry is the default.
const List<ComponentPreview> datePickerPreviews = <ComponentPreview>[
  ComponentPreview('Single', _datePickerSingle),
  ComponentPreview('Range', _datePickerRange),
  ComponentPreview('Dialog', _datePickerDialog),
  ComponentPreview('Disabled', _datePickerDisabled),
  ComponentPreview('Inline', _datePickerInline),
];
