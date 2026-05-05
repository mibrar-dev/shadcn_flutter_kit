part of '../../form_control.dart';

/// ControlledComponentData defines a reusable type for this registry module.
class ControlledComponentData<T> {
  /// The current value of the component.
  ///
  /// This represents the component's current state and should be
  /// used by the UI to display the correct value to the user.
  final T value;

  /// Callback to invoke when the value should change.
  ///
  /// This callback should be called whenever the user interaction
  /// or programmatic action requires the value to be updated.
  /// The new value should be passed as the parameter.
  final ValueChanged<T> onChanged;

  /// Whether the component should accept user input.
  ///
  /// When false, the component should display in a disabled state
  /// and ignore user interactions.
  final bool enabled;

  /// Creates a [ControlledComponentData] with the specified state.
  ///
  /// All parameters are required as they represent the essential
  /// state needed for any controlled component to function properly.
  ///
  /// Parameters:
  /// - [value] (T, required): The current value to display
  /// - [onChanged] (`ValueChanged<T>`, required): Callback for value changes
  /// - [enabled] (bool, required): Whether the component accepts input
  const ControlledComponentData({
    required this.value,
    required this.onChanged,
    required this.enabled,
  });
}

/// A widget adapter that bridges controlled component logic with custom UI implementations.
///
/// This adapter provides a standardized way to implement controlled components
/// by handling the common logic for value management, controller integration,
/// and state synchronization. It implements the [ControlledComponent] mixin
/// and manages the lifecycle of value updates between controllers and UI.
///
/// The adapter supports both controlled mode (with a [controller]) and
/// uncontrolled mode (with an [initialValue]). When a controller is provided,
/// it becomes the source of truth for the component's value. When no controller
/// is provided, the component maintains its own internal state.
///
/// The generic type [T] represents the type of value this adapter manages.
///
/// Example:
/// ```dart
/// ControlledComponentAdapter<String>(
///   initialValue: 'Hello',
///   onChanged: (value) => print('Value changed: $value'),
///   builder: (context, data) {
///     return GestureDetector(
///       onTap: () => data.onChanged('${data.value}!'),
///       child: Text(data.value),
///     );
///   },
/// );
/// ```
