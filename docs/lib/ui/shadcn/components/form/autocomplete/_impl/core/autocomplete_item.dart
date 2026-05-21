// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../autocomplete.dart';

/// _AutoCompleteItem represents a form-related type in the registry.
class _AutoCompleteItem extends StatefulWidget {
  /// Field storing `suggestion` for this form implementation.
  final String suggestion;

  /// Field storing `selected` for this form implementation.
  final bool selected;

  /// Callback invoked for `onSelected` events.
  final VoidCallback onSelected;

  /// Constructs `_AutoCompleteItem` with the provided parameters.
  const _AutoCompleteItem({
    required this.suggestion,
    required this.selected,
    required this.onSelected,
  });

  /// Creates the `State` object for this widget.
  @override
  State<_AutoCompleteItem> createState() => _AutoCompleteItemState();
}
