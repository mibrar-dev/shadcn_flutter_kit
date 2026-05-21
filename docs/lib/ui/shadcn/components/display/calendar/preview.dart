// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/material.dart' hide Card;
import '../calendar/calendar.dart';
import '../../../shared/localizations/shadcn_localizations.dart';
import '../../../shared/primitives/icon_extensions.dart';
import '../../../shared/primitives/text.dart';
import '../../../shared/theme/theme.dart';
import '../../control/button/button.dart';
import '../../layout/card/card.dart' as shadcn;

part '_calendar_preview_state.dart';

/// Core class used by the calendar component.
class CalendarPreview extends StatefulWidget {
  const CalendarPreview({super.key});

  /// Creates the State object used by this calendar widget.
  @override
  State<CalendarPreview> createState() => _CalendarPreviewState();
}
