// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../tree.dart';

/// Reason for a focus change event in tree navigation.
///
/// Used to differentiate between programmatic focus changes and
/// user-initiated focus changes.
enum FocusChangeReason {
  /// Focus changed due to focus scope management.
  focusScope,

  /// Focus changed due to direct user interaction.
  userInteraction,
}
