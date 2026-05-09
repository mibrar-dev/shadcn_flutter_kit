// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/widgets.dart';

import '../../../../../display/calendar/calendar.dart';
import '../../../../form_field/form_field.dart';

// ═══════════════════════════════════════════════════════════
// COMPONENT THEME TOKENS
// User customization layer (replace this file from website output)
// ═══════════════════════════════════════════════════════════

class DatePickerThemeTokens {
  const DatePickerThemeTokens({
    this.mode = PromptMode.dialog,
    this.initialView,
    this.initialViewType = CalendarViewType.date,
    this.popoverAlignment = Alignment.topLeft,
    this.popoverAnchorAlignment = Alignment.bottomLeft,
    this.popoverPadding,
    this.ignoreGlobalScaling = false,
    this.ignoreGlobalRadius = false,
  });

  final PromptMode mode;
  final CalendarView? initialView;
  final CalendarViewType initialViewType;
  final AlignmentGeometry popoverAlignment;
  final AlignmentGeometry popoverAnchorAlignment;
  final EdgeInsetsGeometry? popoverPadding;
  final bool ignoreGlobalScaling;
  final bool ignoreGlobalRadius;
}

const datePickerThemeTokens = DatePickerThemeTokens();
