part of '../../clickable.dart';


/// _ParamStatedWidget defines a reusable type for this registry module.
class _ParamStatedWidget extends StatedWidget {
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

/// Creates a `_ParamStatedWidget` instance.
  const _ParamStatedWidget({
    super.key,
    this.order = StatedWidget.defaultStateOrder,
    this.child,
    this.disabled,
    this.selected,
    this.pressed,
    this.hovered,
    this.focused,
    this.error,
  }) : super._();

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

/// A widget that provides widget state information to descendants via `Data`.
///
/// [WidgetStatesProvider] manages and propagates widget states (like hovered,
/// pressed, disabled) down the widget tree using the Data inheritance mechanism.
/// It supports both static state sets and dynamic controller-based states.
///
/// ## Overview
///
/// Use [WidgetStatesProvider] to:
/// - Share widget states with descendant widgets
/// - Control states programmatically via [WidgetStatesController]
/// - Inherit states from ancestor providers
/// - Create state boundaries to isolate state contexts
///
/// ## Example
///
/// ```dart
/// WidgetStatesProvider(
///   states: {WidgetState.hovered},
///   child: StatedWidget(
///     child: Text('Normal'),
///     hovered: Text('Hovered'),
///   ),
/// )
/// ```
