// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../util.dart';

/// _SeparatedFlexState defines a reusable type for this registry module.
class _SeparatedFlexState extends State<SeparatedFlex> {
  /// Stores `_children` state/configuration for this implementation.
  late List<Widget> _children;

  @override
  /// Executes `initState` behavior for this component/composite.
  void initState() {
    super.initState();
    _children = join(widget.children, widget.separator).toList();
  }

  @override
  /// Executes `didUpdateWidget` behavior for this component/composite.
  void didUpdateWidget(covariant SeparatedFlex oldWidget) {
    super.didUpdateWidget(oldWidget);
    mutateSeparated(widget.children, _children, widget.separator);
  }

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    return Flex(
      key: widget.key,
      direction: widget.direction,
      mainAxisAlignment: widget.mainAxisAlignment,
      mainAxisSize: widget.mainAxisSize,
      crossAxisAlignment: widget.crossAxisAlignment,
      textDirection: widget.textDirection,
      verticalDirection: widget.verticalDirection,
      textBaseline: widget.textBaseline,
      clipBehavior: widget.clipBehavior,
      children: _children,
    );
  }
}

/// Extension helpers used by this registry module.
extension ColumnExtension on Column {
  /// Executes `gap` behavior for this component/composite.
  Widget gap(double gap) {
    return separator(SizedBox(height: gap));
  }

  /// Executes `separator` behavior for this component/composite.
  Widget separator(Widget separator) {
    return SeparatedFlex(
      key: key,
      direction: Axis.vertical,
      mainAxisAlignment: mainAxisAlignment,
      mainAxisSize: mainAxisSize,
      crossAxisAlignment: crossAxisAlignment,
      textDirection: textDirection,
      verticalDirection: verticalDirection,
      textBaseline: textBaseline,
      clipBehavior: clipBehavior,
      separator: separator,
      children: children,
    );
  }
}

/// Extension helpers used by this registry module.
extension RowExtension on Row {
  /// Executes `gap` behavior for this component/composite.
  Widget gap(double gap) {
    return separator(SizedBox(width: gap));
  }

  /// Executes `separator` behavior for this component/composite.
  Widget separator(Widget separator) {
    return SeparatedFlex(
      key: key,
      direction: Axis.horizontal,
      mainAxisAlignment: mainAxisAlignment,
      mainAxisSize: mainAxisSize,
      crossAxisAlignment: crossAxisAlignment,
      textDirection: textDirection,
      verticalDirection: verticalDirection,
      textBaseline: textBaseline,
      clipBehavior: clipBehavior,
      separator: separator,
      children: children,
    );
  }
}

/// Extension helpers used by this registry module.
extension FlexExtension on Flex {
  /// Executes `gap` behavior for this component/composite.
  Widget gap(double gap) {
    return separator(
      direction == Axis.horizontal
          ? SizedBox(width: gap)
          : SizedBox(height: gap),
    );
  }

  /// Executes `separator` behavior for this component/composite.
  Widget separator(Widget separator) {
    return SeparatedFlex(
      key: key,
      direction: direction,
      mainAxisAlignment: mainAxisAlignment,
      mainAxisSize: mainAxisSize,
      crossAxisAlignment: crossAxisAlignment,
      textDirection: textDirection,
      verticalDirection: verticalDirection,
      textBaseline: textBaseline,
      clipBehavior: clipBehavior,
      separator: separator,
      children: children,
    );
  }
}
