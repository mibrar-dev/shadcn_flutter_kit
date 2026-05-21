// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/widgets.dart';

/// Minimal menu group metadata shared across components.
///
/// This lightweight shape is enough for menu-aware components (like buttons)
/// to adapt padding based on menu layout direction.
class MenuGroupData {
  /// Layout direction (horizontal or vertical).
  final Axis direction;

  const MenuGroupData({required this.direction});
}
