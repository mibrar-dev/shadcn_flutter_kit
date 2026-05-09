// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../radio_group.dart';

/// State class for [RadioGroup] with form integration.
///
/// Manages selection state and integrates with the form validation system.
class RadioGroupState<T> extends State<RadioGroup<T>>
    with FormValueSupplier<T, RadioGroup<T>> {
  /// Whether the radio group is currently enabled.
  bool get enabled => widget.enabled ?? widget.onChanged != null;

  /// Performs `_setSelected` logic for this form component.
  void _setSelected(T value) {
    if (!enabled) return;
    if (widget.value != value) {
      widget.onChanged?.call(value);
    }
  }

  /// Initializes stateful resources for this widget.
  @override
  void initState() {
    super.initState();
    formValue = widget.value;
  }

  /// Reacts to widget configuration updates from the parent.
  @override
  void didUpdateWidget(covariant RadioGroup<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      formValue = widget.value;
    }
  }

  /// Performs `didReplaceFormValue` logic for this form component.
  @override
  void didReplaceFormValue(T value) {
    widget.onChanged?.call(value);
  }

  /// Builds the widget tree for this component state.
  @override
  Widget build(BuildContext context) {
    return FocusableActionDetector(
      child: Data.inherit(
        data: this,
        child: Data.inherit(
          data: RadioGroupData<T>(widget.value, enabled),
          child: FocusTraversalGroup(child: widget.child),
        ),
      ),
    );
  }
}
