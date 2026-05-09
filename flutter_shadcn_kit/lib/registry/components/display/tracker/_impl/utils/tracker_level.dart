// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../tracker.dart';

/// Abstract tracker level describing color and label.
abstract class TrackerLevel {
  /// Input parameter used by `TrackerLevel` during rendering and behavior handling.
  static const TrackerLevel fine = _SimpleTrackerLevel(Colors.green, 'Fine');
  static const TrackerLevel warning = _SimpleTrackerLevel(
    Colors.orange,
    'Warning',
  );
  static const TrackerLevel critical = _SimpleTrackerLevel(
    Colors.red,
    'Critical',
  );
  static const TrackerLevel unknown = _SimpleTrackerLevel(
    Colors.grey,
    'Unknown',
  );

  Color get color;

  String get name;
}
