// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/material.dart';
import '../../display/calendar/calendar.dart';
import '../form_field/form_field.dart';
import '../date_picker/date_picker.dart';

part '_impl/state/_date_picker_preview_state.dart';

/// DatePickerPreview represents a form-related type in the registry.
class DatePickerPreview extends StatefulWidget {
  const DatePickerPreview({super.key});

  /// Creates the `State` object for this widget.
  @override
  State<DatePickerPreview> createState() => _DatePickerPreviewState();
}
