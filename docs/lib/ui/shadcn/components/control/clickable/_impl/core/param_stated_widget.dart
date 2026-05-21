// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:data_widget/data_widget.dart';
import 'package:flutter/widgets.dart';

import 'stated_widget.dart';
import '../state/widget_states_data.dart';

/// ParamStatedWidget defines a reusable type for this registry module.
class ParamStatedWidget extends StatedWidget {
  /// Stores `order` state/configuration for this implementation.
  final List<WidgetState> order;

  /// Stores `child` state/configuration for this implementation.
  final Widget? child;

  /// Stores `disabled` state/configuration for this implementation.
  final Widget? disabled;

  /// Stores `selected` state/configuration for this implementation.
  final Widget? selected;

  /// Stores `pressed` state/configuration for this implementation.
  final Widget? pressed;

  /// Stores `hovered` state/configuration for this implementation.
  final Widget? hovered;

  /// Stores `focused` state/configuration for this implementation.
  final Widget? focused;

  /// Stores `error` state/configuration for this implementation.
  final Widget? error;

  /// Creates a `ParamStatedWidget` instance.
  const ParamStatedWidget({
    super.key,
    this.order = StatedWidget.defaultStateOrder,
    this.child,
    this.disabled,
    this.selected,
    this.pressed,
    this.hovered,
    this.focused,
    this.error,
  }) : super.base();

  /// Executes `_checkByOrder` behavior for this component/composite.
  Widget? _checkByOrder(Set<WidgetState> states, int index) {
    if (index >= order.length) {
      return child;
    }

    /// Stores `state` state/configuration for this implementation.
    final state = order[index];
    if (states.contains(state)) {
      switch (state) {
        case WidgetState.disabled:
          return disabled;
        case WidgetState.pressed:
          return pressed;
        case WidgetState.hovered:
          return hovered;
        case WidgetState.focused:
          return focused;
        case WidgetState.selected:
          return selected;
        case WidgetState.error:
          return error;
        default:
          return child;
      }
    }
    return _checkByOrder(states, index + 1);
  }

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    WidgetStatesData? statesData = Data.maybeOf<WidgetStatesData>(context);

    /// Stores `states` state/configuration for this implementation.
    Set<WidgetState> states = statesData?.states ?? {};
    final child = _checkByOrder(states, 0);
    return child ?? const SizedBox();
  }
}
