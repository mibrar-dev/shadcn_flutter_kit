// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../collapsible.dart';

/// CollapsibleState defines a reusable type for this registry module.
class CollapsibleState extends State<Collapsible> {
  /// Stores `_isExpanded` state/configuration for this implementation.
  late bool _isExpanded;

  @override
  /// Executes `initState` behavior for this component/composite.
  void initState() {
    super.initState();
    _isExpanded = widget.isExpanded ?? false;
  }

  @override
  /// Executes `didUpdateWidget` behavior for this component/composite.
  void didUpdateWidget(covariant Collapsible oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isExpanded != null) {
      _isExpanded = widget.isExpanded!;
    }
  }

  /// Executes `_handleTap` behavior for this component/composite.
  void _handleTap() {
    if (widget.onExpansionChanged != null) {
      widget.onExpansionChanged!(_isExpanded);
    } else {
      /// Creates a `setState` instance.
      setState(() {
        _isExpanded = !_isExpanded;
      });
    }
  }

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    final compTheme = ComponentTheme.maybeOf<CollapsibleTheme>(context);

    return Data.inherit(
      data: CollapsibleStateData(
        isExpanded: _isExpanded,
        handleTap: _handleTap,
      ),
      child: IntrinsicWidth(
        child: Column(
          crossAxisAlignment:
              compTheme?.crossAxisAlignment ?? CrossAxisAlignment.stretch,
          mainAxisAlignment:
              compTheme?.mainAxisAlignment ?? MainAxisAlignment.start,
          children: widget.children,
        ),
      ),
    );
  }
}
