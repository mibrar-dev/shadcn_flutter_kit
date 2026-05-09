// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../select.dart';

/// A select item delegate that uses a static list of children.
///
/// [SelectItemList] provides select items from a pre-defined list of widgets.
/// This is the simplest way to create a select dropdown with a fixed set of options.
///
/// Example:
/// ```dart
/// SelectItemList(
///   children: [
///     SelectItem(value: 1, child: Text('Option 1')),
///     SelectItem(value: 2, child: Text('Option 2')),
///     SelectItem(value: 3, child: Text('Option 3')),
///   ],
/// )
/// ```
class SelectItemList extends SelectItemDelegate {
  /// The list of widgets to display as select items.
  final List<Widget> children;

  /// Creates a [SelectItemList] with the specified children.
  const SelectItemList({required this.children});

  /// Builds the widget tree for this component state.
  @override
  Widget build(BuildContext context, int index) {
    return children[index];
  }

  /// Field storing `estimatedChildCount` for this form implementation.
  @override
  int get estimatedChildCount => children.length;

  /// Performs `shouldRebuild` logic for this form component.
  @override
  bool shouldRebuild(covariant SelectItemList oldDelegate) {
    return !listEquals(oldDelegate.children, children);
  }
}
