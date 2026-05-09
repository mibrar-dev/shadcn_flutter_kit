// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../preview.dart';

/// _ItemPickerPreviewState stores and manages mutable widget state.
class _ItemPickerPreviewState extends State<ItemPickerPreview> {
  /// Current value stored for `_value`.
  String? _value;

  /// Builds the widget tree for this component state.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ItemPicker<String>(
          items: const ItemList(['Alpha', 'Beta', 'Gamma', 'Delta']),
          value: _value,
          placeholder: const Text('Pick item'),
          builder: (context, value) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(value),
            );
          },
          onChanged: (value) {
            /// Triggers a rebuild after mutating local state.
            setState(() {
              _value = value;
            });
          },
        ),
      ),
    );
  }
}
