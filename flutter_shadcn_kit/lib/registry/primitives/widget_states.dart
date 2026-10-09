// Interaction-state plumbing shared by interactive primitives: the
// `StatedWidget` family, the `WidgetStatesData`/`WidgetStatesProvider` data
// pair and the `WidgetStateExtension` helpers.
//
// Ported from `shared/primitives/clickable.dart` (stated-widget parts).

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../foundation/data.dart';

/// Boolean state getters for a `Set<WidgetState>`.
extension WidgetStateExtension on Set<WidgetState> {
  /// Whether the widget is disabled.
  bool get disabled => contains(WidgetState.disabled);

  /// Whether the widget is in an error state.
  bool get error => contains(WidgetState.error);

  /// Whether the widget is selected.
  bool get selected => contains(WidgetState.selected);

  /// Whether the widget is pressed.
  bool get pressed => contains(WidgetState.pressed);

  /// Whether the widget is hovered.
  bool get hovered => contains(WidgetState.hovered);

  /// Whether the widget is focused.
  bool get focused => contains(WidgetState.focused);
}

/// The set of interactive states propagated through the tree.
class WidgetStatesData {
  /// The current states.
  final Set<WidgetState> states;

  /// Creates widget state data.
  const WidgetStatesData(this.states);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is WidgetStatesData && setEquals(states, other.states);
  }

  @override
  int get hashCode => states.hashCode;

  @override
  String toString() => 'WidgetStatesData(states: $states)';
}

/// Provides [WidgetStatesData] to descendants through `Data`.
///
/// Combines static [states], an optional [controller] and (unless [inherit]
/// is false) the states of an ancestor provider. [WidgetStatesProvider.
/// boundary] stops inheritance entirely.
class WidgetStatesProvider extends StatelessWidget {
  /// Optional controller whose states are merged in.
  final WidgetStatesController? controller;

  /// Static states to provide.
  final Set<WidgetState>? states;

  /// The child that can read the provided states.
  final Widget child;

  /// Whether ancestor provider states are merged in.
  final bool inherit;

  /// Whether this provider blocks ancestor states.
  final bool boundary;

  /// Creates a states provider.
  const WidgetStatesProvider({
    super.key,
    this.controller,
    required this.child,
    this.states = const {},
    this.inherit = true,
  }) : boundary = false;

  /// Creates a provider that blocks ancestor states.
  const WidgetStatesProvider.boundary({super.key, required this.child})
    : boundary = true,
      controller = null,
      states = null,
      inherit = false;

  @override
  Widget build(BuildContext context) {
    if (boundary) {
      return Data<WidgetStatesData>.boundary(child: child);
    }
    Set<WidgetState>? parentStates;
    if (inherit) {
      parentStates = Data.maybeOf<WidgetStatesData>(context)?.states;
    }
    return ListenableBuilder(
      listenable: Listenable.merge([controller]),
      builder: (context, child) {
        Set<WidgetState> currentStates = states ?? {};
        if (controller != null) {
          currentStates = currentStates.union(controller!.value);
        }
        if (parentStates != null) {
          currentStates = currentStates.union(parentStates);
        }
        return Data<WidgetStatesData>.inherit(
          data: WidgetStatesData(currentStates),
          child: child!,
        );
      },
      child: child,
    );
  }
}

/// A widget that shows one of several children depending on the ambient
/// [WidgetStatesData].
///
/// Three constructors: the default one takes explicit per-state widgets, the
/// `.map()` one takes a state-to-widget map and `.builder()` one derives the
/// widget from the states set.
abstract class StatedWidget extends StatelessWidget {
  /// State priority order used by the default constructor.
  static const List<WidgetState> defaultStateOrder = [
    WidgetState.disabled,
    WidgetState.error,
    WidgetState.selected,
    WidgetState.pressed,
    WidgetState.hovered,
    WidgetState.focused,
  ];

  const StatedWidget._({super.key});

  /// Shows an explicit widget per state, in [order] priority.
  const factory StatedWidget({
    Key? key,
    required Widget child,
    List<WidgetState> order,
    Widget? disabled,
    Widget? selected,
    Widget? pressed,
    Widget? hovered,
    Widget? focused,
    Widget? error,
  }) = _ParamStatedWidget;

  /// Shows the widget mapped to the first active state.
  const factory StatedWidget.map({
    Key? key,
    required Map<Object, Widget> states,
    Widget? child,
  }) = _MapStatedWidget;

  /// Builds the widget from the active states set.
  const factory StatedWidget.builder({
    Key? key,
    required Widget Function(BuildContext context, Set<WidgetState> states)
    builder,
  }) = _BuilderStatedWidget;
}

class _ParamStatedWidget extends StatedWidget {
  final List<WidgetState> order;
  final Widget? child;
  final Widget? disabled;
  final Widget? selected;
  final Widget? pressed;
  final Widget? hovered;
  final Widget? focused;
  final Widget? error;

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

  Widget? _checkByOrder(Set<WidgetState> states, int index) {
    if (index >= order.length) {
      return child;
    }
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
  Widget build(BuildContext context) {
    final statesData = Data.maybeOf<WidgetStatesData>(context);
    final states = statesData?.states ?? {};
    final child = _checkByOrder(states, 0);
    return child ?? const SizedBox();
  }
}

class _MapStatedWidget extends StatedWidget {
  static final Map<String, WidgetState> _mappedNames = WidgetState.values
      .asNameMap();

  final Map<Object, Widget> states;
  final Widget? child;

  const _MapStatedWidget({super.key, required this.states, this.child})
    : super._();

  @override
  Widget build(BuildContext context) {
    final statesData = Data.maybeOf<WidgetStatesData>(context);
    final widgetStates = statesData?.states ?? {};
    for (final entry in states.entries) {
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
        final state = _mappedNames[keys];
        if (state != null && widgetStates.contains(state)) {
          return entry.value;
        }
      } else {
        assert(
          false,
          'Invalid key type in states map (${keys.runtimeType}) expected '
          'WidgetState, Iterable<WidgetState>, or String',
        );
      }
    }
    return child ?? const SizedBox();
  }
}

class _BuilderStatedWidget extends StatedWidget {
  final Widget Function(BuildContext context, Set<WidgetState> states) builder;

  const _BuilderStatedWidget({super.key, required this.builder}) : super._();

  @override
  Widget build(BuildContext context) {
    final statesData = Data.maybeOf<WidgetStatesData>(context);
    final states = statesData?.states ?? {};
    return builder(context, states);
  }
}
