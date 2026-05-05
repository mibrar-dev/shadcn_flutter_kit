import 'package:flutter/widgets.dart';

part '_impl/core/controlled_component_adapter.dart';
part '_impl/core/controlled_component_data.dart';
part '_impl/state/__controlled_component_adapter_state.dart';
part '_impl/utils/component_value_controller.dart';

/// A mixin that defines the interface for controlling component values.
///
/// This mixin combines the capabilities of [ValueNotifier] to provide
/// a standardized way for widgets to expose their current value and
/// notify listeners of changes. Components that implement this interface
/// can be controlled programmatically and integrated with form validation
/// systems.
///
/// The generic type [T] represents the type of value this controller manages.
mixin ComponentController<T> implements ValueNotifier<T> {}

/// A concrete implementation of [ComponentController] that manages a single value.
///
/// This controller provides a simple way to programmatically control any
/// component that accepts a [ComponentController]. It extends [ValueNotifier]
/// to provide change notification capabilities.
///
/// The controller maintains the current value and notifies listeners when
/// the value changes through the inherited [ValueNotifier.value] setter.
///
/// Example:
/// ```dart
/// final controller = ComponentValueController<String>('initial value');
///
/// // Listen to changes
/// controller.addListener(() {
///   print('Value changed to: ${controller.value}');
/// });
///
/// // Update the value
/// controller.value = 'new value';
/// ```
