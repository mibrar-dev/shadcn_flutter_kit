import 'package:flutter/widgets.dart';

/// Function signature for button state-dependent properties.
///
/// [ButtonStateProperty] is a function type that resolves a property value based
/// on the current widget states (hovered, pressed, focused, disabled, etc.) and
/// build context. This allows button styles to dynamically adapt their appearance
/// based on user interactions.
///
/// Parameters:
/// - [context]: The build context for accessing theme data
/// - [states]: Set of current widget states (e.g., `{WidgetState.hovered, WidgetState.pressed}`)
///
/// Returns the property value of type [T] appropriate for the current states.
///
/// Example:
/// ```dart
/// ButtonStateProperty<Color> backgroundColor = (context, states) {
///   if (states.contains(WidgetState.disabled)) return Colors.grey;
///   if (states.contains(WidgetState.pressed)) return Colors.blue.shade700;
///   if (states.contains(WidgetState.hovered)) return Colors.blue.shade400;
///   return Colors.blue;
/// };
/// ```
typedef ButtonStateProperty<T> =
    T Function(BuildContext context, Set<WidgetState> states);
