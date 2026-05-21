// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../text.dart';

/// Data class for tracking unordered list nesting depth.
///
/// Used internally by the list item modifier to handle bullet points
/// and indentation for nested lists.
class UnorderedListData {
  /// The nesting depth of the list (0 = top level).
  final int depth;

  /// Creates an [UnorderedListData].
  ///
  /// Parameters:
  /// - [depth] (`int`, default: 0): Nesting depth.
  const UnorderedListData({this.depth = 0});
}
