// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../chat.dart';

/// Marks a chat entry as collapsible and records whether it is collapsed.
///
/// This widget builds [child] unchanged; [collapsed] is metadata read by the
/// surrounding chat layout, which decides how to group or hide consecutive
/// collapsed entries.
class ChatCollapsible extends StatelessWidget {
  /// The chat entry being marked.
  final Widget child;

  /// Whether this entry is currently collapsed.
  final bool collapsed;

  /// Marks [child] as collapsible.
  const ChatCollapsible({
    super.key,
    required this.collapsed,
    required this.child,
  });

  /// Builds the widget tree for chat collapsible.
  @override
  Widget build(BuildContext context) {
    return child;
  }
}
