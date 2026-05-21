// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:data_widget/data_widget.dart';
import 'package:flutter/widgets.dart';

import 'widget_states_data.dart';

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
class WidgetStatesProvider extends StatelessWidget {
  /// Optional controller for programmatic state management.
  final WidgetStatesController? controller;

  /// Static set of widget states to provide.
  final Set<WidgetState>? states;

  /// The child widget that can access the provided states.
  final Widget child;

  /// Whether to inherit states from ancestor providers.
  ///
  /// When `true`, combines local states with inherited states.
  final bool inherit;

  /// Whether this provider acts as a state boundary.
  final bool boundary;

  /// Creates a widget states provider with optional controller and states.
  ///
  /// ## Parameters
  ///
  /// * [controller] - Optional controller for dynamic state management.
  /// * [child] - The descendant widget that can access states.
  /// * [states] - Static set of states to provide. Defaults to empty set.
  /// * [inherit] - Whether to inherit from ancestors. Defaults to `true`.
  const WidgetStatesProvider({
    super.key,
    this.controller,
    required this.child,
    this.states = const {},
    this.inherit = true,
  }) : boundary = false;

  /// Creates a widget states provider that acts as a state boundary.
  ///
  /// A boundary provider blocks state inheritance from ancestors, creating
  /// an isolated state context for its descendants.
  ///
  /// ## Parameters
  ///
  /// * [child] - The descendant widget.
  const WidgetStatesProvider.boundary({super.key, required this.child})
    : boundary = true,
      controller = null,
      states = null,
      inherit = false;

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    if (boundary) {
      return Data<WidgetStatesData>.boundary(child: child);
    }
    Set<WidgetState>? parentStates;
    if (inherit) {
      WidgetStatesData? parentData = Data.maybeOf<WidgetStatesData>(context);
      parentStates = parentData?.states;
    }
    return ListenableBuilder(
      listenable: Listenable.merge([if (controller != null) controller!]),
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
