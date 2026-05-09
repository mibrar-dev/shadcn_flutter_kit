// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../preview.dart';

/// _HiddenPreviewState defines a reusable type for this registry module.
class _HiddenPreviewState extends State<HiddenPreview> {
  /// Stores `_hidden` state/configuration for this implementation.
  bool _hidden = false;

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// Creates a `SwitchListTile` instance.
            SwitchListTile(
              value: _hidden,
              onChanged: (value) {
                /// Creates a `setState` instance.
                setState(() {
                  _hidden = value;
                });
              },
              title: const Text('Hidden'),
            ),

            /// Creates a `SizedBox` instance.
            const SizedBox(height: 12),

            /// Creates a `Hidden` instance.
            Hidden(
              hidden: _hidden,
              direction: Axis.vertical,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text('Toggle me'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
