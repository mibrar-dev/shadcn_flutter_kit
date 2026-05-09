// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../select.dart';

/// A select item delegate that uses a builder function.
///
/// Provides items through a builder function with optional child count.
class SelectItemBuilder extends SelectItemDelegate {
  /// The builder function for creating item widgets.
  final SelectItemWidgetBuilder builder;

  /// The number of children this delegate can build.
  final int? childCount;

  /// Creates a select item builder.
  const SelectItemBuilder({required this.builder, this.childCount});

  /// Builds the widget tree for this component state.
  @override
  Widget build(BuildContext context, int index) {
    return builder(context, index);
  }

  /// Field storing `estimatedChildCount` for this form implementation.
  @override
  int? get estimatedChildCount => childCount;

  /// Performs `shouldRebuild` logic for this form component.
  @override
  bool shouldRebuild(covariant SelectItemBuilder oldDelegate) {
    return oldDelegate.builder != builder &&
        oldDelegate.childCount != childCount;
  }
}
