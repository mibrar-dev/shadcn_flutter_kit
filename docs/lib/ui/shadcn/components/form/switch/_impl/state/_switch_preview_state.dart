// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../preview.dart';

/// _SwitchPreviewState stores and manages mutable widget state.
class _SwitchPreviewState extends State<SwitchPreview> {
  /// Current value stored for `value`.
  bool value = false;

  /// Builds the widget tree for this component state.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 16,
          children: [
            // Interactive switch
            Switch(
              value: value,
              onChanged: (newValue) {
                /// Triggers a rebuild after mutating local state.
                setState(() {
                  value = newValue;
                });
              },
            ),
            // Disabled switches
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 16,
              children: [
                Switch(value: false, onChanged: null),
                Switch(value: true, onChanged: null),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
