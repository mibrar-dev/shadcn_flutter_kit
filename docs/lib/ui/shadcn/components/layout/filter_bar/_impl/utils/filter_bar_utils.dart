// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../filter_bar.dart';

/// _Debouncer defines a reusable type for this registry module.
class _Debouncer {
  _Debouncer(this.duration);

  /// Stores `duration` state/configuration for this implementation.
  Duration duration;

  /// Stores `_timer` state/configuration for this implementation.
  Timer? _timer;

  /// Executes `schedule` behavior for this component/composite.
  void schedule(VoidCallback callback) {
    _timer?.cancel();
    _timer = Timer(duration, callback);
  }

  /// Executes `dispose` behavior for this component/composite.
  void dispose() {
    _timer?.cancel();
  }
}

/// Executes `_formatResultsCount` behavior for this component/composite.
String _formatResultsCount(int count) {
  return '$count result${count == 1 ? '' : 's'}';
}

/// Executes `_formatActiveFilterCount` behavior for this component/composite.
String _formatActiveFilterCount(int count) {
  return '$count active filter${count == 1 ? '' : 's'}';
}

String _formatCompactDateLabel(
  ShadcnLocalizations localizations,
  DateTime date,
) {
  final month = localizations.getAbbreviatedMonth(date.month);
  return '$month ${date.day}';
}

String _formatCompactDateRangeLabel(
  ShadcnLocalizations localizations,
  DateTimeRange range,
) {
  final start = _formatCompactDateLabel(localizations, range.start);
  final end = _formatCompactDateLabel(localizations, range.end);
  if (range.start.year == range.end.year) {
    return '$start - $end, ${range.end.year}';
  }
  return '$start, ${range.start.year} - $end, ${range.end.year}';
}
