// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../form_field.dart';

/// _ObjectFormFieldPopup represents a form-related type in the registry.
class _ObjectFormFieldPopup<T> extends StatefulWidget {
  /// Current value stored for `value`.
  final T? value;
  final Widget Function(BuildContext context, ObjectFormHandler<T> handler)
  editorBuilder;

  /// Field storing `popoverPadding` for this form implementation.
  final EdgeInsetsGeometry? popoverPadding;

  /// Callback invoked for `onChanged` events.
  final ValueChanged<T?>? onChanged;

  /// Field storing `prompt` for this form implementation.
  final ValueChanged<T?> prompt;

  /// Field storing `decorate` for this form implementation.
  final bool decorate;

  /// Constructs `_ObjectFormFieldPopup` with the provided parameters.
  const _ObjectFormFieldPopup({
    super.key,
    required this.value,
    required this.editorBuilder,
    required this.prompt,
    this.popoverPadding,
    this.onChanged,
    this.decorate = true,
  });

  /// Creates the `State` object for this widget.
  @override
  State<_ObjectFormFieldPopup<T>> createState() =>
      _ObjectFormFieldPopupState<T>();
}
