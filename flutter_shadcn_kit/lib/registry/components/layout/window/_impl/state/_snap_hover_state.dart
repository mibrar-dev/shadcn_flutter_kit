// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../window.dart';

/// _SnapHoverState defines a reusable type for this registry module.
class _SnapHoverState extends State<_SnapHover> {
  /// Stores `_hovering` state/configuration for this implementation.
  bool _hovering = false;
  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return MouseRegion(
      onEnter: (_) {
        /// Creates a `setState` instance.
        setState(() {
          _hovering = true;
          widget.hovering(true);
        });
      },
      onHover: (_) {
        /// Creates a `setState` instance.
        setState(() {
          _hovering = true;
          widget.hovering(true);
        });
      },
      onExit: (_) {
        /// Creates a `setState` instance.
        setState(() {
          _hovering = false;
          widget.hovering(false);
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: _hovering
              ? theme.colorScheme.secondary
              : theme.colorScheme.card,
          border: Border.all(color: theme.colorScheme.border),
          borderRadius: BorderRadius.only(
            topLeft: widget.topLeft
                ? theme.radiusSmRadius
                : theme.radiusLgRadius,
            topRight: widget.topRight
                ? theme.radiusSmRadius
                : theme.radiusLgRadius,
            bottomLeft: widget.bottomLeft
                ? theme.radiusSmRadius
                : theme.radiusLgRadius,
            bottomRight: widget.bottomRight
                ? theme.radiusSmRadius
                : theme.radiusLgRadius,
          ),
        ),
      ),
    );
  }
}
