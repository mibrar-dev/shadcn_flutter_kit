part of '../../clickable.dart';


/// _BuilderStatedWidget defines a reusable type for this registry module.
class _BuilderStatedWidget extends StatedWidget {
  final Widget Function(BuildContext context, Set<WidgetState> states) builder;

/// Creates a `_BuilderStatedWidget` instance.
  const _BuilderStatedWidget({
    super.key,
    required this.builder,
  }) : super._();

  @override
/// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    WidgetStatesData? statesData = Data.maybeOf(context);
/// Stores `states` state/configuration for this implementation.
    Set<WidgetState> states = statesData?.states ?? {};
    return builder(context, states);
  }
}

/// A highly configurable clickable widget with extensive gesture and state support.
///
/// [Clickable] provides a comprehensive foundation for interactive widgets, handling
/// various input gestures (tap, double-tap, long-press, etc.), visual states, and
/// accessibility features. It manages decoration, styling, and transitions based on
/// widget states like hover, focus, and press.
///
/// ## Overview
///
/// Use [Clickable] when building custom interactive components that need:
/// - Fine-grained gesture control (primary, secondary, tertiary taps)
/// - State-aware styling (decoration, text style, mouse cursor, etc.)
/// - Focus management and keyboard shortcuts
/// - Smooth transitions between states
/// - Accessibility features like focus outlines
///
/// ## Example
///
/// ```dart
/// Clickable(
///   onPressed: () => print('Clicked!'),
///   decoration: WidgetStateProperty.resolveWith((states) {
///     if (states.contains(WidgetState.pressed)) {
///       return BoxDecoration(color: Colors.blue.shade700);
///     }
///     return BoxDecoration(color: Colors.blue);
///   }),
///   child: Padding(
///     padding: EdgeInsets.all(8),
///     child: Text('Click Me'),
///   ),
/// )
/// ```
