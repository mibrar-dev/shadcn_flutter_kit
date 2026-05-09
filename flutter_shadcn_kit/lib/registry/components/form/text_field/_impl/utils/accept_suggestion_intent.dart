// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../text_field.dart';

/// Intent for accepting the currently selected autocomplete suggestion.
///
/// Used internally by [AutoComplete] to handle suggestion acceptance via
/// keyboard shortcuts (typically Tab or Enter). Triggers the completion
/// logic to apply the selected suggestion to the text field.
class AcceptSuggestionIntent extends Intent {
  /// Creates an accept suggestion intent.
  const AcceptSuggestionIntent();
}
