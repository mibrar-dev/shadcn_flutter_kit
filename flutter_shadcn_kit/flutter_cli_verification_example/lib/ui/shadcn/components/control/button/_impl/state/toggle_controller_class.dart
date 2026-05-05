import 'package:flutter/widgets.dart';

import '../../../../../shared/primitives/form_control.dart';
import '../../../../../shared/primitives/form_value_supplier.dart';

/// ToggleController defines a reusable type for this registry module.
class ToggleController extends ValueNotifier<bool>
    with ComponentController<bool> {
  /// Creates a [ToggleController] with an initial toggle state.
  ///
  /// Parameters:
  /// - [value] (bool, default: false): The initial toggle state.
  ///
  /// Example:
  /// ```dart
  /// // Create controller starting in off state
  /// final controller = ToggleController();
  ///
  /// // Create controller starting in on state
  /// final controller = ToggleController(true);
  /// ```
  ToggleController([super.value = false]);

  /// Toggles the current boolean state.
  ///
  /// Changes `true` to `false` and `false` to `true`, then notifies all listeners
  /// of the change. This is equivalent to setting `value = !value` but provides
  /// a more semantic API for toggle operations.
  ///
  /// Example:
  /// ```dart
  /// final controller = ToggleController(false);
  /// controller.toggle(); // value is now true
  /// controller.toggle(); // value is now false
  /// ```
  void toggle() {
    value = !value;
  }
}

/// A controlled version of [Toggle] that integrates with form state management.
///
/// [ControlledToggle] implements the [ControlledComponent] mixin to provide
/// automatic form integration, validation, and state management. It serves as
/// a bridge between external state management (via [ToggleController] or
/// [onChanged] callbacks) and the underlying [Toggle] widget.
///
/// This widget is ideal for use in forms where the toggle state needs to be
/// managed externally, validated, or persisted. It automatically handles the
/// conversion between controlled and uncontrolled modes based on the provided
/// parameters.
///
/// Example:
/// ```dart
/// final controller = ToggleController(false);
///
/// ControlledToggle(
///   controller: controller,
///   child: Row(
///     children: [
///       Icon(Icons.notifications),
///       Text('Enable notifications'),
///     ],
///   ),
/// );
/// ```
