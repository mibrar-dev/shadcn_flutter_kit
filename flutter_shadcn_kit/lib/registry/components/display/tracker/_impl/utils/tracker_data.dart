// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../tracker.dart';

/// Data for a single tracker segment.
class TrackerData {
  /// Input parameter used by `TrackerData` during rendering and behavior handling.
  final Widget tooltip;

  /// Input parameter used by `TrackerData` during rendering and behavior handling.
  final TrackerLevel level;

  const TrackerData({required this.tooltip, required this.level});
}
