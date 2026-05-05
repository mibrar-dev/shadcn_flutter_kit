import 'package:flutter/widgets.dart';

/// Function signature for button state property delegates with default value.
///
/// [ButtonStatePropertyDelegate] extends [ButtonStateProperty] by adding a
/// `value` parameter representing the default or base value. This allows delegates
/// to modify existing values rather than always creating them from scratch.
///
/// The delegate receives:
/// - [context]: Build context for accessing theme data
/// - [states]: Current widget states
/// - [value]: The default value from the base style
///
/// Returns the final property value of type [T], which may be the default value,
/// a modified version of it, or a completely new value.
///
/// Example:
/// ```dart
/// ButtonStatePropertyDelegate<Color> customColor = (context, states, defaultColor) {
///   if (states.contains(WidgetState.disabled)) {
///     return defaultColor.withOpacity(0.5); // Modify default
///   }
///   return defaultColor; // Use default
/// };
/// ```
typedef ButtonStatePropertyDelegate<T> =
    T Function(BuildContext context, Set<WidgetState> states, T value);
