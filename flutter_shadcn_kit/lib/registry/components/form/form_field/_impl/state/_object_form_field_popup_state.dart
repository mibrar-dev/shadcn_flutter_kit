// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../form_field.dart';

/// _ObjectFormFieldPopupState stores and manages mutable widget state.
class _ObjectFormFieldPopupState<T> extends State<_ObjectFormFieldPopup<T>>
    implements ObjectFormHandler<T> {
  late T? _value;

  /// Initializes stateful resources for this widget.
  @override
  void initState() {
    super.initState();
    _value = widget.value;
  }

  @override
  T? get value => _value;

  /// Performs `value` logic for this form component.
  @override
  set value(T? value) {
    if (mounted) {
      /// Triggers a rebuild after mutating local state.
      setState(() {
        _value = value;
      });
    } else {
      _value = value;
    }
    widget.onChanged?.call(value);
  }

  /// Performs `prompt` logic for this form component.
  @override
  void prompt([T? value]) {
    widget.prompt.call(value);
  }

  /// Performs `close` logic for this form component.
  @override
  Future<void> close() {
    return closeOverlay(context);
  }

  /// Builds the widget tree for this component state.
  @override
  Widget build(BuildContext context) {
    if (!widget.decorate) {
      return widget.editorBuilder(context, this);
    }
    final theme = Theme.of(context);
    return Data<ObjectFormHandler<T>>.inherit(
      data: this,
      child: SurfaceCard(
        padding:
            widget.popoverPadding ??
            (EdgeInsets.symmetric(
                  vertical: theme.density.baseContentPadding,
                  horizontal: theme.density.baseContentPadding,
                ) *
                theme.scaling),
        child: widget.editorBuilder(context, this),
      ),
    );
  }
}
