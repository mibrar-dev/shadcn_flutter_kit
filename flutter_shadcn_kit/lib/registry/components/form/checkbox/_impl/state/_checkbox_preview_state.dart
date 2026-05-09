// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../preview.dart';

/// _CheckboxPreviewState stores and manages mutable widget state.
class _CheckboxPreviewState extends State<CheckboxPreview> {
  /// Field storing `uncheckedState` for this form implementation.
  CheckboxState uncheckedState = CheckboxState.unchecked;

  /// Field storing `checkedState` for this form implementation.
  CheckboxState checkedState = CheckboxState.checked;

  /// Field storing `indeterminateState` for this form implementation.
  CheckboxState indeterminateState = CheckboxState.indeterminate;

  /// Field storing `disabledState` for this form implementation.
  CheckboxState disabledState = CheckboxState.unchecked;

  /// Builds the widget tree for this component state.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 16,
              children: [
                // Unchecked
                Checkbox(
                  state: uncheckedState,
                  onChanged: (value) {
                    /// Triggers a rebuild after mutating local state.
                    setState(() => uncheckedState = value);
                  },
                  trailing: const Text('Unchecked'),
                ),
                // Checked
                Checkbox(
                  state: checkedState,
                  onChanged: (value) {
                    /// Triggers a rebuild after mutating local state.
                    setState(() => checkedState = value);
                  },
                  trailing: const Text('Checked'),
                ),
                // Indeterminate
                Checkbox(
                  state: indeterminateState,
                  onChanged: (value) {
                    /// Triggers a rebuild after mutating local state.
                    setState(() => indeterminateState = value);
                  },
                  trailing: const Text('Indeterminate'),
                ),
                // Disabled
                Checkbox(
                  state: disabledState,
                  onChanged: null,
                  trailing: const Text('Disabled'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
