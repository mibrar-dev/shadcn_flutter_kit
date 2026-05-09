// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../preview.dart';

/// _SelectPreviewState stores and manages mutable widget state.
class _SelectPreviewState extends State<SelectPreview> {
  /// Current value stored for `selectedValue`.
  String? selectedValue;

  /// Builds the widget tree for this component state.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: 300,
              child: Select<String>(
                itemBuilder: (context, item) {
                  return Text(item);
                },
                popupConstraints: const BoxConstraints(
                  maxHeight: 300,
                  maxWidth: 300,
                ),
                onChanged: (value) {
                  /// Triggers a rebuild after mutating local state.
                  setState(() {
                    selectedValue = value;
                  });
                },
                value: selectedValue,
                placeholder: const Text('Select a fruit'),
                popup: const SelectPopup(
                  items: SelectItemList(
                    children: [
                      SelectItemButton(value: 'Apple', child: Text('Apple')),
                      SelectItemButton(value: 'Banana', child: Text('Banana')),
                      SelectItemButton(value: 'Cherry', child: Text('Cherry')),
                      SelectItemButton(value: 'Date', child: Text('Date')),
                      SelectItemButton(value: 'Grape', child: Text('Grape')),
                    ],
                  ),
                ).call,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
