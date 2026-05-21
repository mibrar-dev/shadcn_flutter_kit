// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../collapsible.dart';

/// Holder for the collapsible child content.
class CollapsibleContent extends StatelessWidget {
  /// Creates a content pane for [Collapsible].
  const CollapsibleContent({
    super.key,
    this.collapsible = true,
    required this.child,
  });

  /// Whether this pane should respect the expansion state.
  final bool collapsible;

  /// Inner widget that is shown or hidden.
  final Widget child;

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    final state = Data.of<CollapsibleStateData>(context);
    return Offstage(offstage: collapsible && !state.isExpanded, child: child);
  }
}
