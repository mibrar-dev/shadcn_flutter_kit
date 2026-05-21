// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../preview.dart';

/// _MultipleChoicePreviewState stores and manages mutable widget state.
class _MultipleChoicePreviewState extends State<MultipleChoicePreview> {
  /// Current value stored for `_singleValue`.
  String? _singleValue;

  /// Current value stored for `_multiValue`.
  Iterable<String>? _multiValue = const [];

  /// Performs `_buildChoice` logic for this form component.
  Widget _buildChoice(String value) {
    return Builder(
      builder: (context) {
        final selected =
            Choice.getValue<String>(context)?.contains(value) ?? false;
        return GestureDetector(
          onTap: () => Choice.choose<String>(context, value),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: selected ? Colors.blue.shade100 : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: selected ? Colors.blue : Colors.grey.shade400,
              ),
            ),
            child: Text(value),
          ),
        );
      },
    );
  }

  /// Builds the widget tree for this component state.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            MultipleChoice<String>(
              value: _singleValue,
              onChanged: (value) {
                /// Triggers a rebuild after mutating local state.
                setState(() {
                  _singleValue = value;
                });
              },
              child: Wrap(
                spacing: 8,
                children: [
                  _buildChoice('Option A'),
                  _buildChoice('Option B'),
                  _buildChoice('Option C'),
                ],
              ),
            ),
            const SizedBox(height: 24),
            MultipleAnswer<String>(
              value: _multiValue,
              onChanged: (value) {
                /// Triggers a rebuild after mutating local state.
                setState(() {
                  _multiValue = value;
                });
              },
              child: Wrap(
                spacing: 8,
                children: [
                  _buildChoice('Apple'),
                  _buildChoice('Banana'),
                  _buildChoice('Orange'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
