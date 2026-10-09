import 'package:flutter/widgets.dart';

/// The value interface a component exposes so it can be driven from outside.
///
/// Adds nothing to [ValueNotifier]; it names the role so a form or a screen
/// can hold a controller for any controlled component without knowing its type.
mixin ComponentController<T> implements ValueNotifier<T> {}

/// A plain [ComponentController] holding one value.
class ComponentValueController<T> extends ValueNotifier<T>
    implements ComponentController<T> {
  /// Creates a controller seeded with [value].
  ComponentValueController(super.value);
}

/// The contract every controlled component satisfies.
///
/// A component is driven either by a [controller] (controlled mode: the
/// controller owns the value) or by [initialValue] plus internal state
/// (uncontrolled mode).
mixin ControlledComponent<T> on Widget {
  /// External owner of this component's value, when there is one.
  ///
  /// Takes precedence over [initialValue].
  ComponentController<T>? get controller;

  /// Starting value used only while [controller] is null.
  T? get initialValue;

  /// Called with the new value whenever it changes.
  ValueChanged<T>? get onChanged;

  /// Whether the component accepts user input.
  bool get enabled;
}

/// The state [ControlledComponentAdapter.builder] receives each build.
///
/// [value] is the value to render, [onChanged] is the only way to request a
/// change, and [enabled] says whether to wire up interaction at all.
class ControlledComponentData<T> {
  /// Creates the data handed to a builder.
  const ControlledComponentData({
    required this.value,
    required this.onChanged,
    required this.enabled,
  });

  /// The value to display.
  final T value;

  /// Requests a new value.
  final ValueChanged<T> onChanged;

  /// Whether the component accepts input.
  final bool enabled;
}

/// Wires the [ControlledComponent] contract to a hand-written [builder].
///
/// Handles both modes: with a [controller] the controller is the source of
/// truth and pushes changes into the widget; without one the adapter keeps the
/// value itself. [onChanged] fires either way.
///
/// ```dart
/// ControlledComponentAdapter<bool>(
///   initialValue: false,
///   builder: (context, data) => GestureDetector(
///     onTap: data.enabled ? () => data.onChanged(!data.value) : null,
///     child: Text('${data.value}'),
///   ),
/// );
/// ```
class ControlledComponentAdapter<T> extends StatefulWidget
    with ControlledComponent<T> {
  /// Creates an adapter over [builder].
  ///
  /// Either [controller] or [initialValue] must be supplied.
  const ControlledComponentAdapter({
    super.key,
    required this.builder,
    this.initialValue,
    this.onChanged,
    this.controller,
    this.enabled = true,
  }) : assert(
         controller != null || initialValue is T,
         'Either controller or initialValue must be provided',
       );

  @override
  final T? initialValue;

  @override
  final ValueChanged<T>? onChanged;

  @override
  final bool enabled;

  @override
  final ComponentController<T>? controller;

  /// Builds the UI from the current state.
  final Widget Function(BuildContext context, ControlledComponentData<T> data)
  builder;

  @override
  State<ControlledComponentAdapter<T>> createState() =>
      _ControlledComponentAdapterState<T>();
}

class _ControlledComponentAdapterState<T>
    extends State<ControlledComponentAdapter<T>> {
  late T _value;

  @override
  void initState() {
    super.initState();
    final controller = widget.controller;
    final initialValue = widget.initialValue;
    assert(
      controller != null || initialValue is T,
      'Either controller or initialValue must be provided',
    );
    _value = (controller?.value ?? initialValue) as T;
    controller?.addListener(_onControllerChanged);
  }

  /// Moves the controller subscription over and re-reads when a controller
  /// arrives.
  ///
  /// Dropping the controller keeps the value currently on screen, so the
  /// component continues in uncontrolled mode from where the controlled one
  /// left off instead of snapping back to [ControlledComponentAdapter.initialValue].
  @override
  void didUpdateWidget(covariant ControlledComponentAdapter<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    final controller = widget.controller;
    if (oldWidget.controller == controller) {
      return;
    }
    oldWidget.controller?.removeListener(_onControllerChanged);
    if (controller == null) {
      return;
    }
    controller.addListener(_onControllerChanged);
    // Re-read: the new controller may already hold a different value. No
    // setState: the framework calls build right after this.
    _value = controller.value;
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_onControllerChanged);
    super.dispose();
  }

  void _onControllerChanged() {
    setState(() => _value = widget.controller!.value);
  }

  void _onChanged(T value) {
    widget.onChanged?.call(value);
    final controller = widget.controller;
    if (controller != null) {
      controller.value = value;
    } else {
      setState(() => _value = value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(
      context,
      ControlledComponentData<T>(
        value: _value,
        onChanged: _onChanged,
        enabled: widget.enabled,
      ),
    );
  }
}
