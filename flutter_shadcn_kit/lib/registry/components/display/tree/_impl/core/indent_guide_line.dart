// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../tree.dart';

/// Branch line implementation with simple vertical lines.
///
/// Displays vertical lines alongside tree nodes to indicate hierarchy levels.
/// Does not draw horizontal connections.
///
/// Example:
/// ```dart
/// TreeView(
///   branchLine: BranchLine.line,
///   // or with custom color:
///   branchLine: IndentGuideLine(color: Colors.blue),
/// );
/// ```
class IndentGuideLine implements BranchLine {
  /// Custom color for the line. If null, uses the theme border color.
  final Color? color;

  /// Creates an [IndentGuideLine] with optional custom color.
  const IndentGuideLine({this.color});

  /// Builds the widget tree for tree.
  @override
  Widget build(BuildContext context, List<TreeNodeDepth> depth, int index) {
    if (index <= 0) {
      return const SizedBox();
    }
    return CustomPaint(
      painter: _PathPainter(
        color: color ?? Theme.of(context).colorScheme.border,
        top: true,
        bottom: true,
      ),
    );
  }
}
