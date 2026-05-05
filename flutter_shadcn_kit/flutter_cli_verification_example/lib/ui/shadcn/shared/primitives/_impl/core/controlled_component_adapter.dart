part of '../../form_control.dart';

/// ControlledComponentAdapter defines a reusable type for this registry module.
class ControlledComponentAdapter<T> extends StatefulWidget
    with ControlledComponent<T> {
  @override
/// Stores `initialValue` state/configuration for this implementation.
  final T? initialValue;
  @override
/// Stores `onChanged` state/configuration for this implementation.
  final ValueChanged<T>? onChanged;
  @override
/// Stores `enabled` state/configuration for this implementation.
  final bool enabled;
  @override
/// Stores `controller` state/configuration for this implementation.
  final ComponentController<T>? controller;

  /// A builder function that creates the widget UI using the provided state data.
  ///
  /// This function receives the current [BuildContext] and [ControlledComponentData]
  /// containing the current value, change callback, and enabled state. The builder
  /// should create a widget that displays the current value and calls the
  /// onChanged callback when user interaction occurs.
  final Widget Function(BuildContext context, ControlledComponentData<T> data)
      builder;

  /// Creates a [ControlledComponentAdapter].
  ///
  /// Either [controller] or [initialValue] must be provided to establish
  /// the component's initial state. The [builder] function is required
  /// and will be called to construct the UI with the current state.
  ///
  /// Parameters:
  /// - [builder] (required): Function that builds the UI using state data
  /// - [initialValue] (T?, optional): Initial value when no controller is used
  /// - [onChanged] (`ValueChanged<T>?`, optional): Callback for value changes
  /// - [controller] (`ComponentController<T>?`, optional): External controller for value management
  /// - [enabled] (bool, default: true): Whether the component accepts user input
  ///
  /// Throws [AssertionError] if neither controller nor initialValue is provided.
  ///
  /// Example:
  /// ```dart
  /// ControlledComponentAdapter<bool>(
  ///   initialValue: false,
  ///   enabled: true,
  ///   builder: (context, data) => Switch(
  ///     value: data.value,
  ///     onChanged: data.enabled ? data.onChanged : null,
  ///   ),
  /// );
  /// ```
  const ControlledComponentAdapter({
    super.key,
    required this.builder,
    this.initialValue,
    this.onChanged,
    this.controller,
    this.enabled = true,
  }) : assert(controller != null || initialValue is T,
            'Either controller or initialValue must be provided');

  @override
/// Executes `createState` behavior for this component/composite.
  State<ControlledComponentAdapter<T>> createState() =>
      _ControlledComponentAdapterState<T>();
}
