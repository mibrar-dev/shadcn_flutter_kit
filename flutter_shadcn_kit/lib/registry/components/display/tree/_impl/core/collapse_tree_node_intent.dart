// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../tree.dart';

/// Intent to collapse a tree node.
///
/// Used with Flutter's Actions/Shortcuts system to programmatically
/// collapse an expanded tree node to hide its children.
class CollapseTreeNodeIntent extends Intent {
  /// Creates a [CollapseTreeNodeIntent].
  const CollapseTreeNodeIntent();
}
