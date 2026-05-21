// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:data_widget/data_widget.dart';
import 'package:flutter/widgets.dart';

import 'stated_widget.dart';
import '../state/widget_states_data.dart';

/// MapStatedWidget defines a reusable type for this registry module.
class MapStatedWidget extends StatedWidget {
  static final Map<String, WidgetState> _mappedNames = WidgetState.values
      .asNameMap();

  /// Stores `states` state/configuration for this implementation.
  final Map<Object, Widget> states;

  /// Stores `child` state/configuration for this implementation.
  final Widget? child;

  /// Creates a `MapStatedWidget` instance.
  const MapStatedWidget({super.key, required this.states, this.child})
    : super.base();

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    WidgetStatesData? statesData = Data.maybeOf<WidgetStatesData>(context);

    /// Stores `widgetStates` state/configuration for this implementation.
    Set<WidgetState> widgetStates = statesData?.states ?? {};
    for (var entry in states.entries) {
      /// Stores `keys` state/configuration for this implementation.
      final keys = entry.key;
      if (keys is Iterable<WidgetState>) {
        if (widgetStates.containsAll(keys)) {
          return entry.value;
        }
      } else if (keys is WidgetState) {
        if (widgetStates.contains(keys)) {
          return entry.value;
        }
      } else if (keys is String) {
        /// Stores `state` state/configuration for this implementation.
        final state = _mappedNames[keys];
        if (state != null && widgetStates.contains(state)) {
          return entry.value;
        }
      } else {
        /// Creates a `assert` instance.
        assert(
          false,
          'Invalid key type in states map (${keys.runtimeType}) expected WidgetState, Iterable<WidgetState>, or String',
        );
      }
    }
    return child ?? const SizedBox();
  }
}
