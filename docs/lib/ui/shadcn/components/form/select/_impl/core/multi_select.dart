// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../select.dart';

/// A customizable dropdown selection widget for multi-value selection.
///
/// Extends the base select functionality to support selecting multiple items
/// simultaneously. Displays selected items as removable chips within the trigger.
///
/// Example:
/// ```dart
/// MultiSelect<String>(
///   value: selectedItems,
///   onChanged: (items) => setState(() => selectedItems = items),
///   popup: SelectPopup.menu(children: [...]),
///   multiItemBuilder: (context, item) => Text(item),
/// )
/// ```
class MultiSelect<T> extends StatelessWidget with SelectBase<Iterable<T>> {
  @override
  final ValueChanged<Iterable<T>?>? onChanged; // if null, then it's a disabled combobox
  @override
  final Widget? placeholder; // placeholder when value is null
  /// Field storing `filled` for this form implementation.
  @override
  final bool filled;

  /// Focus node/reference used by `focusNode` interactions.
  @override
  final FocusNode? focusNode;

  /// Field storing `constraints` for this form implementation.
  @override
  final BoxConstraints? constraints;

  /// Field storing `popupConstraints` for this form implementation.
  @override
  final BoxConstraints? popupConstraints;

  /// Overrides the [OverlayConfiguration] used to present the popup. When
  /// null, the legacy [popoverAlignment], [popoverAnchorAlignment] and
  /// [popupWidthConstraint] knobs are used instead.
  @override
  final OverlayConfiguration? overlayConfiguration;

  /// Whether the popup may adapt to a different presentation on mobile
  /// platforms. Accepted for upstream API parity; the registry overlay
  /// always presents a popover, so this is stored but currently not honored.
  @override
  final bool? adaptiveOverlay;

  /// Field storing `popupWidthConstraint` for this form implementation.
  ///
  /// Alias kept for backwards compatibility. Used when
  /// [overlayConfiguration] is null; otherwise the configuration's
  /// `widthConstraint` wins.
  @override
  final PopoverConstraint popupWidthConstraint;

  /// The currently selected values.
  final Iterable<T>? value;

  /// Field storing `borderRadius` for this form implementation.
  @override
  final BorderRadiusGeometry? borderRadius;

  /// Field storing `padding` for this form implementation.
  @override
  final EdgeInsetsGeometry? padding;

  /// Overrides the decoration of the select trigger, resolved per
  /// [WidgetState]. See [SelectTheme.decoration].
  @override
  final WidgetStatePropertyDelegate<Decoration>? decoration;

  /// Field storing `popoverAlignment` for this form implementation.
  @override
  final AlignmentGeometry popoverAlignment;

  /// Field storing `popoverAnchorAlignment` for this form implementation.
  @override
  final AlignmentGeometry? popoverAnchorAlignment;

  /// Field storing `disableHoverEffect` for this form implementation.
  @override
  final bool disableHoverEffect;

  /// Field storing `canUnselect` for this form implementation.
  @override
  final bool canUnselect;

  /// Field storing `autoClosePopover` for this form implementation.
  @override
  final bool? autoClosePopover;

  /// Whether the multi-select is enabled for user interaction.
  final bool? enabled;

  /// Expand icon for the select. When null, no expand icon is shown.
  @override
  final Widget? expandIcon;

  /// Field storing `popup` for this form implementation.
  @override
  final SelectPopupBuilder popup;
  @override
  SelectValueBuilder<Iterable<T>> get itemBuilder => (context, value) {
    return _buildItem(multiItemBuilder, context, value);
  };

  /// Current value stored for `valueSelectionHandler`.
  @override
  final SelectValueSelectionHandler<Iterable<T>>? valueSelectionHandler;

  /// Current value stored for `valueSelectionPredicate`.
  @override
  final SelectValueSelectionPredicate<Iterable<T>>? valueSelectionPredicate;

  /// Builder for rendering individual items in the chip display.
  final SelectValueBuilder<T> multiItemBuilder;

  /// Current value stored for `showValuePredicate`.
  @override
  final Predicate<Iterable<T>>? showValuePredicate;

  /// Creates a multi-selection dropdown widget.
  ///
  /// Allows selecting multiple items from a dropdown list, displaying them as chips.
  /// The [value], [popup], and [itemBuilder] parameters are required.
  ///
  /// Parameters:
  /// - [key] (Key?): Widget key for controlling widget identity
  /// - [onChanged] (`ValueChanged<Iterable<T>?>?`): Callback when selection changes; if null, widget is disabled
  /// - [placeholder] (Widget?): Widget shown when no values are selected
  /// - [filled] (bool): Whether to use filled background style, defaults to false
  /// - [focusNode] (FocusNode?): Focus node for keyboard interaction
  /// - [constraints] (BoxConstraints?): Size constraints for the select button
  /// - [popupConstraints] (BoxConstraints?): Size constraints for the popup menu
  /// - [overlayConfiguration] (OverlayConfiguration?): overrides the popup presentation
  /// - [popupWidthConstraint] (PopoverConstraint): Width constraint mode for popup, defaults to `PopoverConstraint.anchorFixedSize`
  /// - [value] (`Iterable<T>`): Required currently selected values
  /// - [disableHoverEffect] (bool): Whether to disable hover visual feedback, defaults to false
  /// - [borderRadius] (BorderRadiusGeometry?): Custom border radius
  /// - [padding] (EdgeInsetsGeometry?): Custom padding
  /// - [decoration] (`WidgetStatePropertyDelegate<Decoration>?`): Per-state override of the trigger decoration
  /// - [canUnselect] (bool): Whether user can deselect items, defaults to true
  /// - [autoClosePopover] (bool?): Whether popup closes after selection, defaults to false
  /// - [enabled] (bool?): Whether multi-select is enabled for interaction
  /// - [valueSelectionHandler] (`SelectValueSelectionHandler<Iterable<T>>?`): Custom selection logic
  /// - [valueSelectionPredicate] (`SelectValueSelectionPredicate<Iterable<T>>?`): Predicate for allowing selection
  /// - [showValuePredicate] (`Predicate<Iterable<T>>?`): Predicate for showing items
  /// - [popup] (SelectPopupBuilder): Required builder for popup content
  /// - [itemBuilder] (`SelectValueBuilder<T>`): Required builder for individual chip items
  /// - [expandIcon] (Widget?): The expand icon for the select, defaults to [SelectExpandIcon]; null hides it
  /// - [adaptiveOverlay] (bool?): whether an adaptive presentation runs for this overlay (stored, popover always used)
  const MultiSelect({
    super.key,
    this.onChanged,
    this.placeholder,
    this.filled = false,
    this.focusNode,
    this.constraints,
    this.popupConstraints,
    this.overlayConfiguration,
    this.popupWidthConstraint = PopoverConstraint.anchorFixedSize,
    required this.value,
    this.disableHoverEffect = false,
    this.borderRadius,
    this.padding,
    this.decoration,
    this.popoverAlignment = Alignment.topCenter,
    this.popoverAnchorAlignment,
    this.canUnselect = true,
    this.autoClosePopover = false,
    this.enabled,
    this.valueSelectionHandler,
    this.valueSelectionPredicate,
    this.showValuePredicate,
    this.expandIcon = const SelectExpandIcon(),
    required this.popup,
    required SelectValueBuilder<T> itemBuilder,
    this.adaptiveOverlay,
  }) : multiItemBuilder = itemBuilder;

  static Widget _buildItem<T>(
    SelectValueBuilder<T> multiItemBuilder,
    BuildContext context,
    Iterable<T> value,
  ) {
    final theme = Theme.of(context);

    final scaling = theme.scaling;
    return Wrap(
      spacing: theme.density.baseGap * scaling * 0.5,
      runSpacing: 4 * scaling,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [for (var value in value) multiItemBuilder(context, value)],
    );
  }

  /// Builds the widget tree for this component state.
  @override
  Widget build(BuildContext context) {
    return Select<Iterable<T>>(
      popup: popup,
      itemBuilder: itemBuilder,
      onChanged: onChanged,
      placeholder: placeholder,
      filled: filled,
      focusNode: focusNode,
      constraints: constraints,
      popupConstraints: popupConstraints,
      overlayConfiguration: overlayConfiguration,
      popupWidthConstraint: popupWidthConstraint,
      value: value,
      borderRadius: borderRadius,
      padding: padding,
      decoration: decoration,
      popoverAlignment: popoverAlignment,
      popoverAnchorAlignment: popoverAnchorAlignment,
      disableHoverEffect: disableHoverEffect,
      canUnselect: canUnselect,
      autoClosePopover: autoClosePopover ?? true,
      enabled: enabled,
      expandIcon: expandIcon,
      showValuePredicate: (test) {
        return test.isNotEmpty && (showValuePredicate?.call(test) ?? true);
      },
      valueSelectionHandler:
          valueSelectionHandler ?? _defaultMultiSelectValueSelectionHandler,
      valueSelectionPredicate:
          valueSelectionPredicate ?? _defaultMultiSelectValueSelectionPredicate,
      adaptiveOverlay: adaptiveOverlay,
    );
  }
}
