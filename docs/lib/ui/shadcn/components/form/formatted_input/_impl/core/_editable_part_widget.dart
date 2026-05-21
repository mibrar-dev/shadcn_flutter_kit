// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../formatted_input.dart';

/// _EditablePartWidget renders form UI and wires input behavior.
class _EditablePartWidget extends StatefulWidget {
  /// Field storing `data` for this form implementation.
  final FormattedInputData data;

  /// Field storing `length` for this form implementation.
  final int length;

  /// Field storing `obscureText` for this form implementation.
  final bool obscureText;

  /// Field storing `inputFormatters` for this form implementation.
  final List<TextInputFormatter> inputFormatters;

  /// Field storing `width` for this form implementation.
  final double width;

  /// Field storing `placeholder` for this form implementation.
  final Widget? placeholder;

  /// Constructs `_EditablePartWidget` with the provided parameters.
  const _EditablePartWidget({
    required this.length,
    required this.data,
    this.obscureText = false,
    this.inputFormatters = const [],
    this.placeholder,
    required this.width,
  });

  /// Creates the `State` object for this widget.
  @override
  State<_EditablePartWidget> createState() => _EditablePartWidgetState();
}
