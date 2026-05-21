// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../item_picker.dart';

/// _ItemPickerDialogState stores and manages mutable widget state.
class _ItemPickerDialogState<T> extends State<ItemPickerDialog<T>> {
  /// Performs `_onChanged` logic for this form component.
  void _onChanged(Object? value) {
    widget.onChanged?.call(value as T);
  }

  /// Performs `_buildItem` logic for this form component.
  Widget _buildItem(BuildContext context, Object? item) {
    assert(item is T, 'Item type must be $T');
    return widget.builder(context, item as T);
  }

  /// Builds the widget tree for this component state.
  @override
  Widget build(BuildContext context) {
    return Data.inherit(
      data: ItemPickerData(
        value: widget.value,
        onChanged: _onChanged,
        layout: widget.layout,
      ),
      child: widget.layout.build(context, widget.items, _buildItem),
    );
  }
}
