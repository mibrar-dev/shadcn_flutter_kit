// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../formatted_input.dart';

/// _StaticPartWidgetState stores and manages mutable widget state.
class _StaticPartWidgetState extends State<_StaticPartWidget> {
  /// Builds the widget tree for this component state.
  @override
  Widget build(BuildContext context) {
    return Center(child: Text(widget.text).muted().base());
  }
}
