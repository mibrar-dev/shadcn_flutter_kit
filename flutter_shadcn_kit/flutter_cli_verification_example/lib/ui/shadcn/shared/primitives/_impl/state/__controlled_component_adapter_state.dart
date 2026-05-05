part of '../../form_control.dart';

/// _ControlledComponentAdapterState defines a reusable type for this registry module.
class _ControlledComponentAdapterState<T>
    extends State<ControlledComponentAdapter<T>> {
  /// Stores `_value` state/configuration for this implementation.
  late T _value;

  @override
  /// Executes `initState` behavior for this component/composite.
  void initState() {
    super.initState();

    /// Stores `value` state/configuration for this implementation.
    T? value = widget.controller?.value ?? widget.initialValue;
    assert(
      widget.controller != null || widget.initialValue is T,
      'Either controller or initialValue must be provided',
    );
    _value = value as T;
    widget.controller?.addListener(_onControllerChanged);
  }

  /// Executes `_onControllerChanged` behavior for this component/composite.
  void _onControllerChanged() {
    /// Creates a `setState` instance.
    setState(() {
      _value = widget.controller!.value;
    });
  }

  @override
  /// Executes `didUpdateWidget` behavior for this component/composite.
  void didUpdateWidget(covariant ControlledComponentAdapter<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?.removeListener(_onControllerChanged);
      widget.controller?.addListener(_onControllerChanged);
    }
  }

  /// Executes `_onChanged` behavior for this component/composite.
  void _onChanged(T value) {
    widget.onChanged?.call(value);

    /// Stores `controller` state/configuration for this implementation.
    final controller = widget.controller;
    if (controller != null) {
      controller.value = value;
    } else {
      /// Creates a `setState` instance.
      setState(() {
        _value = value;
      });
    }
  }

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    return widget.builder(
      context,

      /// Creates a `ControlledComponentData` instance.
      ControlledComponentData(
        value: _value,
        onChanged: _onChanged,
        enabled: widget.enabled,
      ),
    );
  }
}
