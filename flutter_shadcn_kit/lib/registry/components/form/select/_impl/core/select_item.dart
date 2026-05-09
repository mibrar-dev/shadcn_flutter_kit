// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../select.dart';

/// Represents a selectable item in a dropdown menu.
///
/// Used within select popups to define individual selectable options.
/// Automatically applies selected state styling when the item matches
/// the current selection.
///
/// Example:
/// ```dart
/// SelectItem(
///   value: 'option1',
///   builder: (context) => Text('Option 1'),
/// )
/// ```
class SelectItem extends StatelessWidget {
  /// Builder for the item's content.
  final WidgetBuilder builder;

  /// The value associated with this item.
  final Object? value;

  /// Creates a [SelectItem].
  ///
  /// Parameters:
  /// - [value] (`Object?`, required): Item value.
  /// - [builder] (`WidgetBuilder`, required): Content builder.
  const SelectItem({super.key, required this.value, required this.builder});

  /// Builds the widget tree for this component state.
  @override
  Widget build(BuildContext context) {
    final data = Data.maybeOf<SelectData>(context);
    final selected = data?.isSelected(value) ?? false;
    return WidgetStatesProvider(
      states: {if (selected) WidgetState.selected},
      child: Builder(builder: builder),
    );
  }
}
