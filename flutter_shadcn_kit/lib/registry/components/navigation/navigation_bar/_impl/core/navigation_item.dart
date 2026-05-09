// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../navigation_bar.dart';

/// NavigationItem defines a reusable type for this registry module.
class NavigationItem extends AbstractNavigationButton {
  /// Custom style when item is selected.
  final AbstractButtonStyle? selectedStyle;

  /// Whether this item is currently selected.
  final bool? selected;

  /// Callback when selection state changes.
  final ValueChanged<bool>? onChanged;

  /// Optional index for selection management.
  final int? index;

  /// Creates a navigation item.
  ///
  /// Parameters:
  /// - [child] (Widget, required): Icon or content widget
  /// - [selectedStyle] (AbstractButtonStyle?): Style when selected
  /// - [selected] (bool?): Current selection state
  /// - [onChanged] (`ValueChanged<bool>?`): Selection change callback
  /// - [index] (int?): Item index for selection
  /// - [label] (Widget?): Optional label text
  /// - [spacing] (double?): Space between icon and label
  /// - [style] (AbstractButtonStyle?): Default style
  /// - [alignment] (AlignmentGeometry?): Content alignment
  /// - [enabled] (bool?): Whether enabled for interaction
  /// - [overflow] (TextOverflow?): Label overflow behavior
  /// - [marginAlignment] (AlignmentGeometry?): Margin alignment
  const NavigationItem({
    super.key,
    this.selectedStyle,
    this.selected,
    this.onChanged,
    super.label,
    super.spacing,
    super.style,
    super.alignment,
    this.index,
    super.enabled,
    super.overflow,
    super.marginAlignment,
    required super.child,
  });

  @override
  bool get selectable {
    // if index is not null, then the child itself handles the selection
    // if index is null, then the parent handles the selection
    return index == null;
  }

  @override
  /// Executes `createState` behavior for this component/composite.
  State<AbstractNavigationButton> createState() => _NavigationItemState();
}
