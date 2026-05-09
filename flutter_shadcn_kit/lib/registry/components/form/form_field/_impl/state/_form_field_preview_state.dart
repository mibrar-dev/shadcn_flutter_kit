// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../preview.dart';

/// _FormFieldPreviewState stores and manages mutable widget state.
class _FormFieldPreviewState extends State<FormFieldPreview> {
  /// Current value stored for `_value`.
  String? _value;

  /// Builds the widget tree for this component state.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ObjectFormField<String>(
          value: _value,
          placeholder: const Text('Select option'),
          builder: (context, value) => Text(value),
          editorBuilder: (context, handler) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Option 1'),
                onTap: () {
                  handler.value = 'Option 1';
                  handler.close();
                },
              ),
              ListTile(
                title: const Text('Option 2'),
                onTap: () {
                  handler.value = 'Option 2';
                  handler.close();
                },
              ),
              ListTile(
                title: const Text('Option 3'),
                onTap: () {
                  handler.value = 'Option 3';
                  handler.close();
                },
              ),
            ],
          ),
          onChanged: (value) {
            /// Triggers a rebuild after mutating local state.
            setState(() {
              _value = value;
            });
          },
          mode: PromptMode.dialog,
        ),
      ),
    );
  }
}
