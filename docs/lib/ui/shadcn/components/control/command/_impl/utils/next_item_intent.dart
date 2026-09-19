// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

// Re-exports the canonical NextItemIntent from the radio group component.
//
// Matches upstream, where `command.dart` uses the `NextItemIntent` defined
// in `radio_group.dart` (single source) instead of declaring its own copy.
// Kept as a file so existing deep imports and manifest file lists are
// unaffected.
export '../../../../form/radio_group/radio_group.dart' show NextItemIntent;
