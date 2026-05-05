import 'package:flutter/widgets.dart';

import '../../../../../shared/primitives/form_control.dart';
import '../../../../../shared/primitives/form_value_supplier.dart';
import '../styles/button_style_class.dart';
import '../state/toggle_controller_class.dart';
import 'toggle_widget.dart';

/// ControlledToggle defines a reusable type for this registry module.
class ControlledToggle extends StatelessWidget with ControlledComponent<bool> {
  /// The initial toggle state when no controller is provided.
  ///
  /// Used only in uncontrolled mode. If both [controller] and [initialValue]
  /// are provided, [controller] takes precedence.
  @override
  final bool? initialValue;

  /// Callback invoked when the toggle state changes.
  ///
  /// Called with the new boolean value whenever the user toggles the button.
  /// If null, the toggle becomes read-only (though it can still be controlled
  /// via [controller] if provided).
  @override
  final ValueChanged<bool>? onChanged;

  /// Whether the toggle is interactive.
  ///
  /// When false, the toggle appears disabled and doesn't respond to user input.
  /// The toggle can still be changed programmatically via [controller].
  @override
  final bool enabled;

  /// Controller for managing toggle state externally.
  ///
  /// When provided, the toggle operates in controlled mode and its state is
  /// managed entirely by this controller. Changes are reflected immediately
  /// and [onChanged] is called when the user interacts with the toggle.
  @override
  final ToggleController? controller;

  /// The child widget to display inside the toggle button.
  ///
  /// Typically contains text, icons, or a combination of both. The child
  /// receives the visual styling and interaction behavior of the toggle button.
  final Widget child;

  /// Visual styling for the toggle button.
  ///
  /// Defines the appearance, colors, padding, and other visual characteristics
  /// of the toggle. Defaults to ghost button style with subtle appearance changes
  /// between toggled and untoggled states.
  final ButtonStyle style;

  /// Creates a [ControlledToggle] widget.
  ///
  /// Parameters:
  /// - [controller] (ToggleController?, optional): External state controller.
  /// - [initialValue] (bool?, optional): Initial state for uncontrolled mode.
  /// - [onChanged] (`ValueChanged<bool>?`, optional): State change callback.
  /// - [enabled] (bool, default: true): Whether the toggle is interactive.
  /// - [child] (Widget, required): Content to display in the toggle button.
  /// - [style] (ButtonStyle, default: ButtonStyle.ghost()): Visual styling.
  ///
  /// Example:
  /// ```dart
  /// ControlledToggle(
  ///   initialValue: false,
  ///   onChanged: (value) => print('Toggled: $value'),
  ///   enabled: true,
  ///   style: ButtonStyle.secondary(),
  ///   child: Text('Toggle Me'),
  /// );
  /// ```
  const ControlledToggle({
    super.key,
    this.controller,
    this.initialValue,
    this.onChanged,
    this.enabled = true,
    required this.child,
    this.style = const ButtonStyle.ghost(),
  });

  @override
/// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    return ControlledComponentAdapter(
      controller: controller,
      initialValue: initialValue,
      onChanged: onChanged,
      enabled: enabled,
      builder: (context, data) {
        return Toggle(
          value: data.value,
          onChanged: data.onChanged,
          enabled: data.enabled,
          style: style,
          child: child,
        );
      },
    );
  }
}
