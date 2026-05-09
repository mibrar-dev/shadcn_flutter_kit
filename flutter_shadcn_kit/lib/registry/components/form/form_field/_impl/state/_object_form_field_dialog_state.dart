// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../form_field.dart';

/// _ObjectFormFieldDialogState stores and manages mutable widget state.
class _ObjectFormFieldDialogState<T> extends State<_ObjectFormFieldDialog<T>>
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
    widget.onChanged(value);
  }

  /// Performs `prompt` logic for this form component.
  @override
  void prompt([T? value]) {
    widget.prompt.call(value);
  }

  /// Performs `close` logic for this form component.
  @override
  Future<void> close() {
    final modalRoute = ModalRoute.of(context);
    Navigator.of(context).pop();
    return modalRoute?.completed ?? Future.value();
  }

  /// Builds the widget tree for this component state.
  @override
  Widget build(BuildContext context) {
    if (!widget.decorate) {
      return widget.editorBuilder(context, this);
    }
    final localizations = ShadcnLocalizations.of(context);
    final theme = Theme.of(context);
    return Data<ObjectFormHandler<T>>.inherit(
      data: this,
      child: AlertDialog(
        title: widget.dialogTitle,
        content: Padding(
          padding: EdgeInsets.only(top: theme.density.baseGap * theme.scaling),
          child: widget.editorBuilder(context, this),
        ),
        actions: [
          if (widget.dialogActions != null)
            ...widget.dialogActions!(context, this),
          ObjectInputCancelButton(
            child: Text(localizations.buttonCancel),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          ObjectInputSaveButton(
            child: Text(localizations.buttonSave),
            onPressed: () {
              Navigator.of(context).pop(ObjectFormFieldDialogResult(_value));
            },
          ),
        ],
      ),
    );
  }
}
