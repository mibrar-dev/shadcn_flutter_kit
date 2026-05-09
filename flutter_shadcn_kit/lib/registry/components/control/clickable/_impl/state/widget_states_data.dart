// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// Data class wrapping a set of widget states.
///
/// [WidgetStatesData] is a simple container for a `Set<WidgetState>` that can
/// be passed through the widget tree using the [Data] inherited widget system.
/// It's used by components like [Clickable] to propagate state information
/// (hovered, pressed, focused, etc.) to descendant widgets.
///
/// Example:
/// ```dart
/// const statesData = WidgetStatesData({WidgetState.hovered, WidgetState.focused});
/// ```
class WidgetStatesData {
  /// The set of current widget states.
  ///
  /// Common states include [WidgetState.hovered], [WidgetState.pressed],
  /// [WidgetState.focused], [WidgetState.disabled], and [WidgetState.selected].
  final Set<WidgetState> states;

  /// Creates widget states data with the specified states.
  const WidgetStatesData(this.states);

  @override
  /// Executes `operator ==` behavior for this component/composite.
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is WidgetStatesData && setEquals(states, other.states);
  }

  @override
  /// Stores `hashCode` state/configuration for this implementation.
  int get hashCode => states.hashCode;

  @override
  /// Executes `toString` behavior for this component/composite.
  String toString() => 'WidgetStatesData(states: $states)';
}
