// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../../calendar.dart';

/// Represents the interactive state of a date in the calendar.
///
/// Controls whether a specific date can be selected or interacted with.
enum DateState {
  /// Date cannot be selected or clicked.
  disabled,

  /// Date is fully interactive and selectable.
  enabled,
}
