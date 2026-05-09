// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../select.dart';

/// A label widget for grouping items in a select popup.
///
/// Displays a non-selectable label to organize dropdown items into categories.
///
/// Example:
/// ```dart
/// SelectLabel(
///   child: Text('Category Name'),
/// )
/// ```
class SelectLabel extends StatelessWidget {
  /// The label content.
  final Widget child;

  /// Creates a [SelectLabel].
  ///
  /// Parameters:
  /// - [child] (`Widget`, required): Label content.
  const SelectLabel({super.key, required this.child});

  /// Builds the widget tree for this component state.
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scaling = theme.scaling;
    return Padding(
      padding: EdgeInsets.all(theme.density.baseGap * scaling),
      child: child.semiBold().small(),
    );
  }
}
