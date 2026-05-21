// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../form_field.dart';

/// _ObjectFormFieldDialog represents a form-related type in the registry.
class _ObjectFormFieldDialog<T> extends StatefulWidget {
  /// Current value stored for `value`.
  final T? value;
  final Widget Function(BuildContext context, ObjectFormHandler<T> handler)
  editorBuilder;

  /// Field storing `dialogTitle` for this form implementation.
  final Widget? dialogTitle;
  final List<Widget> Function(
    BuildContext context,
    ObjectFormHandler<T> handler,
  )?
  dialogActions;

  /// Field storing `prompt` for this form implementation.
  final ValueChanged<T?> prompt;

  /// Field storing `decorate` for this form implementation.
  final bool decorate;

  /// Callback invoked for `onChanged` events.
  final ValueChanged<T?> onChanged;

  /// Constructs `_ObjectFormFieldDialog` with the provided parameters.
  const _ObjectFormFieldDialog({
    super.key,
    required this.value,
    required this.editorBuilder,
    this.dialogTitle,
    this.dialogActions,
    required this.prompt,
    this.decorate = true,
    required this.onChanged,
  });

  /// Creates the `State` object for this widget.
  @override
  State<_ObjectFormFieldDialog<T>> createState() =>
      _ObjectFormFieldDialogState<T>();
}
