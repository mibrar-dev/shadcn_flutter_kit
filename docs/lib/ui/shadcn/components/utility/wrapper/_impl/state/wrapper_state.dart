// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../wrapper.dart';

/// _WrapperState defines a reusable type for this registry module.
class _WrapperState extends State<Wrapper> {
  final GlobalKey _key = GlobalKey();

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    /// Stores `wrappedChild` state/configuration for this implementation.
    Widget wrappedChild = widget.child;
    if (widget.maintainStructure) {
      wrappedChild = KeyedSubtree(key: _key, child: wrappedChild);
    }
    if (widget.wrap && widget.builder != null) {
      wrappedChild = widget.builder!(context, wrappedChild);
    }
    return wrappedChild;
  }
}
