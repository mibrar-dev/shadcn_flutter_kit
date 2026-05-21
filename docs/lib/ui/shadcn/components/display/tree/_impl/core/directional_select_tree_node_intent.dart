// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../tree.dart';

/// Intent to navigate and select tree nodes directionally.
///
/// Used with Flutter's Actions/Shortcuts system to move focus
/// up or down the tree and optionally select nodes.
class DirectionalSelectTreeNodeIntent extends Intent {
  /// Whether to move forward (true) or backward (false) in the tree.
  final bool forward;

  /// Creates a [DirectionalSelectTreeNodeIntent].
  const DirectionalSelectTreeNodeIntent(this.forward);
}
