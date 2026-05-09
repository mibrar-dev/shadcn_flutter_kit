// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../formatted_input.dart';

/// _StaticPartWidget renders form UI and wires input behavior.
class _StaticPartWidget extends StatefulWidget {
  /// Field storing `text` for this form implementation.
  final String text;
  const _StaticPartWidget({required this.text});

  /// Creates the `State` object for this widget.
  @override
  State<_StaticPartWidget> createState() => _StaticPartWidgetState();
}
