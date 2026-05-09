// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../collapsible.dart';

/// Shared state used by [CollapsibleTrigger] and [CollapsibleContent].
class CollapsibleStateData {
  /// Creates shared state data.
  const CollapsibleStateData({
    required this.isExpanded,
    required this.handleTap,
  });

  /// Current expansion state.
  final bool isExpanded;

  /// Callback invoked when the trigger is tapped.
  final VoidCallback handleTap;
}
