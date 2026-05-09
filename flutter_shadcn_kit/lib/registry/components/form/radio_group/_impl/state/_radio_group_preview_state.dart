// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../preview.dart';

/// _RadioGroupPreviewState stores and manages mutable widget state.
class _RadioGroupPreviewState extends State<RadioGroupPreview> {
  /// Current value stored for `_value`.
  String? _value = 'starter';

  /// Builds the widget tree for this component state.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: RadioGroup<String>(
          value: _value,
          onChanged: (value) => setState(() => _value = value),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              RadioItem(value: 'starter', leading: Text('Starter')),
              SizedBox(height: 8),
              RadioItem(value: 'pro', leading: Text('Pro')),
              SizedBox(height: 8),
              RadioItem(value: 'enterprise', leading: Text('Enterprise')),
            ],
          ),
        ),
      ),
    );
  }
}
