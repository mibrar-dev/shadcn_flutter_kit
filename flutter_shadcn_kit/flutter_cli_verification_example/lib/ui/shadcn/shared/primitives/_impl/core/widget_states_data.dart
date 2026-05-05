part of '../../clickable.dart';

/// WidgetStatesData defines a reusable type for this registry module.
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
