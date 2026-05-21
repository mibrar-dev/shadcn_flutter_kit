// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../form.dart';

/// Defines comparison operators for numeric validation.
///
/// Used by [CompareValidator] to specify the type of comparison to perform.
enum CompareType {
  /// Value must be greater than the compared value.
  greater,

  /// Value must be greater than or equal to the compared value.
  greaterOrEqual,

  /// Value must be less than the compared value.
  less,

  /// Value must be less than or equal to the compared value.
  lessOrEqual,

  /// Value must be equal to the compared value.
  equal,
}
