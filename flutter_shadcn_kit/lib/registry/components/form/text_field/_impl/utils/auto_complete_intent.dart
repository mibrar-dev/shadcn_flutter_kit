// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../text_field.dart';

/// An intent representing an autocomplete suggestion selection.
///
/// Used by the autocomplete system to handle suggestion selections
/// with different modes of completion.
class AutoCompleteIntent extends Intent {
  /// The suggestion text to be completed.
  final String suggestion;

  /// The mode determining how the completion should be applied.
  final AutoCompleteMode mode;

  /// Creates an autocomplete intent with the specified suggestion and mode.
  const AutoCompleteIntent(this.suggestion, this.mode);
}
