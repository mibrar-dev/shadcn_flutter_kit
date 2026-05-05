import 'package:flutter/widgets.dart';

/// A button state property delegate that always returns the same value.
///
/// [ButtonStylePropertyAll] implements a [ButtonStatePropertyDelegate] that
/// ignores the context, states, and default value parameters, always returning
/// its stored [value]. This is useful for creating static style properties that
/// don't change based on button state.
///
/// Example:
/// ```dart
/// final alwaysRedDecoration = ButtonStylePropertyAll<Decoration>(
///   BoxDecoration(color: Colors.red),
/// );
/// ```
class ButtonStylePropertyAll<T> {
  /// The constant value to return regardless of state.
  final T value;

  /// Creates a [ButtonStylePropertyAll] with the specified constant value.
  const ButtonStylePropertyAll(this.value);

  /// Returns the stored [value], ignoring all parameters.
  ///
  /// This method signature matches [ButtonStatePropertyDelegate] for compatibility,
  /// but the [context], [states], and [value] parameters are unused.
  T call(BuildContext context, Set<WidgetState> states, T value) {
    return this.value;
  }

  @override
/// Executes `operator ==` behavior for this component/composite.
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ButtonStylePropertyAll<T> && other.value == value;
  }

  @override
  int get hashCode {
    return value.hashCode;
  }

  @override
/// Executes `toString` behavior for this component/composite.
  String toString() => 'ButtonStylePropertyAll(value: $value)';
}
