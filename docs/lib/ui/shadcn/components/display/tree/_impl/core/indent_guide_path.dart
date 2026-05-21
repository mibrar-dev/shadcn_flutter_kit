// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../tree.dart';

/// Branch line implementation with connected path lines.
///
/// Displays L-shaped or T-shaped connectors showing the hierarchical
/// structure of the tree. This is the most common branch line style.
///
/// Example:
/// ```dart
/// TreeView(
///   branchLine: BranchLine.path,
///   // or with custom color:
///   branchLine: IndentGuidePath(color: Colors.grey),
/// );
/// ```
class IndentGuidePath implements BranchLine {
  /// Custom color for the path. If null, uses the theme border color.
  final Color? color;

  /// Creates an [IndentGuidePath] with optional custom color.
  const IndentGuidePath({this.color});

  /// Builds the widget tree for tree.
  @override
  Widget build(BuildContext context, List<TreeNodeDepth> depth, int index) {
    bool top = true;

    bool right = true;

    bool bottom = true;

    bool left = false;

    if (index >= 0) {
      final current = depth[index];
      if (index != depth.length - 1) {
        right = false;
        if (current.childIndex >= current.childCount - 1) {
          top = false;
        }
      }

      if (current.childIndex >= current.childCount - 1) {
        bottom = false;
      }
    } else {
      left = true;
      top = false;
      bottom = false;
    }

    return CustomPaint(
      painter: _PathPainter(
        color: color ?? Theme.of(context).colorScheme.border,
        top: top,
        right: right,
        bottom: bottom,
        left: left,
      ),
    );
  }
}
