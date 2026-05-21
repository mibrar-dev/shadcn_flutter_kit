// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../accordion.dart';

/// AccordionState defines a reusable type for this registry module.
class AccordionState extends State<Accordion> {
  final ValueNotifier<_AccordionItemState?> _expanded = ValueNotifier(null);

  @override
  /// Executes `dispose` behavior for this component/composite.
  void dispose() {
    _expanded.dispose();
    super.dispose();
  }

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    /// Stores `scaling` state/configuration for this implementation.
    final scaling = theme.scaling;
    final accTheme = ComponentTheme.maybeOf<AccordionTheme>(context);

    /// Stores `dividerColor` state/configuration for this implementation.
    final dividerColor = accTheme?.dividerColor ?? theme.colorScheme.muted;

    /// Stores `dividerHeight` state/configuration for this implementation.
    final dividerHeight = accTheme?.dividerHeight ?? 1 * scaling;

    /// Stores `children` state/configuration for this implementation.
    final children = <Widget>[];
    for (var i = 0; i < widget.items.length; i++) {
      children.add(widget.items[i]);
      if (i < widget.items.length - 1) {
        children.add(Container(color: dividerColor, height: dividerHeight));
      }
    }
    children.add(const Divider());

    return Data.inherit(
      data: this,
      child: IntrinsicWidth(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: children,
        ),
      ),
    );
  }
}
