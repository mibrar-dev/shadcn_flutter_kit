// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/gestures.dart';

/// DesktopPointerScrollEvent defines a reusable type for this registry module.
class DesktopPointerScrollEvent extends PointerScrollEvent {
  /// Creates a `DesktopPointerScrollEvent` instance.
  const DesktopPointerScrollEvent({
    required super.position,
    required super.device,
    required super.embedderId,
    required super.kind,
    required super.timeStamp,
    required super.viewId,
    required super.scrollDelta,
  });
}
