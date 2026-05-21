// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../tracker.dart';

/// Internal helper class used by the tracker component implementation.
class _SimpleTrackerLevel implements TrackerLevel {
  /// Color value used by tracker painting or state styling.
  @override
  final Color color;

  /// Display name used for this tracker level in labels and legends.
  @override
  final String name;

  const _SimpleTrackerLevel(this.color, this.name);
}
