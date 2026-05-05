part of '../../clickable.dart';

/// WidgetStatesProvider defines a reusable type for this registry module.
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
  const WidgetStatesProvider.boundary({
    super.key,
    required this.child,
  })  : boundary = true,
        controller = null,
        states = null,
        inherit = false;

  @override
/// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    if (boundary) {
      return Data<WidgetStatesData>.boundary(
        child: child,
      );
    }
/// Stores `parentStates` state/configuration for this implementation.
    Set<WidgetState>? parentStates;
    if (inherit) {
      WidgetStatesData? parentData = Data.maybeOf<WidgetStatesData>(context);
      parentStates = parentData?.states;
    }
    return ListenableBuilder(
      listenable: Listenable.merge([
        if (controller != null) controller!,
      ]),
      builder: (context, child) {
/// Stores `currentStates` state/configuration for this implementation.
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
