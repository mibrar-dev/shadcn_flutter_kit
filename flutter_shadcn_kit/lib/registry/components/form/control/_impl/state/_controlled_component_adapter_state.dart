// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../control.dart';

/// _ControlledComponentAdapterState stores and manages mutable widget state.
class _ControlledComponentAdapterState<T>
    extends State<ControlledComponentAdapter<T>> {
  late T _value;

  /// Initializes stateful resources for this widget.
  @override
  void initState() {
    super.initState();
    T? value = widget.controller?.value ?? widget.initialValue;
    assert(
      widget.controller != null || widget.initialValue is T,
      'Either controller or initialValue must be provided',
    );
    _value = value as T;
    widget.controller?.addListener(_onControllerChanged);
  }

  /// Performs `_onControllerChanged` logic for this form component.
  void _onControllerChanged() {
    /// Triggers a rebuild after mutating local state.
    setState(() {
      _value = widget.controller!.value;
    });
  }

  /// Reacts to widget configuration updates from the parent.
  @override
  void didUpdateWidget(covariant ControlledComponentAdapter<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?.removeListener(_onControllerChanged);
      widget.controller?.addListener(_onControllerChanged);
    }
  }

  /// Performs `_onChanged` logic for this form component.
  void _onChanged(T value) {
    widget.onChanged?.call(value);
    final controller = widget.controller;
    if (controller != null) {
      controller.value = value;
    } else {
      /// Triggers a rebuild after mutating local state.
      setState(() {
        _value = value;
      });
    }
  }

  /// Builds the widget tree for this component state.
  @override
  Widget build(BuildContext context) {
    return widget.builder(
      context,
      ControlledComponentData(
        value: _value,
        onChanged: _onChanged,
        enabled: widget.enabled,
      ),
    );
  }
}
