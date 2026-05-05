part of '../../clickable.dart';


/// _MapStatedWidget defines a reusable type for this registry module.
class _MapStatedWidget extends StatedWidget {
  static final Map<String, WidgetState> _mappedNames =
      WidgetState.values.asNameMap();
/// Stores `states` state/configuration for this implementation.
  final Map<Object, Widget> states;
/// Stores `child` state/configuration for this implementation.
  final Widget? child;

/// Creates a `_MapStatedWidget` instance.
  const _MapStatedWidget({
    super.key,
    required this.states,
    this.child,
  }) : super._();

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
        assert(false,
            'Invalid key type in states map (${keys.runtimeType}) expected WidgetState, Iterable<WidgetState>, or String');
      }
    }
    return child ?? const SizedBox();
  }
}
