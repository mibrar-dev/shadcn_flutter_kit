// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../select.dart';

/// Common interface for select components.
///
/// Defines the contract for both single and multi-select widgets, providing
/// properties for popup behavior, styling, and value handling.
mixin SelectBase<T> {
  /// Callback when selection changes.
  ValueChanged<T?>? get onChanged;

  /// Placeholder widget shown when nothing is selected.
  Widget? get placeholder;

  /// Whether to use filled appearance style.
  bool get filled;

  /// Focus node for keyboard navigation.
  FocusNode? get focusNode;

  /// Size constraints for the select trigger.
  BoxConstraints? get constraints;

  /// Size constraints for the popup menu.
  BoxConstraints? get popupConstraints;

  /// Overrides the [OverlayConfiguration] used to present the popup. When
  /// null, the legacy popup knobs ([popoverAlignment],
  /// [popoverAnchorAlignment], [popupWidthConstraint]) are used instead.
  OverlayConfiguration? get overlayConfiguration;

  /// Whether the popup may adapt to a different presentation on mobile
  /// platforms. Accepted for upstream API parity; the registry overlay
  /// always presents a popover, so this is currently stored but not honored.
  bool? get adaptiveOverlay;

  /// How popup width should relate to trigger width.
  ///
  /// Alias kept for backwards compatibility. Used when
  /// [overlayConfiguration] is null; otherwise the configuration's
  /// `widthConstraint` wins.
  PopoverConstraint get popupWidthConstraint;

  /// Border radius of the select trigger.
  BorderRadiusGeometry? get borderRadius;

  /// Internal padding of the select trigger.
  EdgeInsetsGeometry? get padding;

  /// Overrides the decoration of the select trigger, resolved per
  /// [WidgetState]. See [SelectTheme.decoration].
  WidgetStatePropertyDelegate<Decoration>? get decoration;

  /// Alignment of popup relative to trigger.
  AlignmentGeometry get popoverAlignment;

  /// Alignment of anchor point for popup positioning.
  AlignmentGeometry? get popoverAnchorAlignment;

  /// Whether to disable hover effects.
  bool get disableHoverEffect;

  /// Whether clicking selected item deselects it.
  bool get canUnselect;

  /// Whether popup auto-closes after selection.
  bool? get autoClosePopover;

  /// Builder for popup content.
  SelectPopupBuilder get popup;

  /// Builder for rendering selected values.
  SelectValueBuilder<T> get itemBuilder;

  /// Custom selection handler logic.
  SelectValueSelectionHandler<T>? get valueSelectionHandler;

  /// Predicate for testing selection state.
  SelectValueSelectionPredicate<T>? get valueSelectionPredicate;

  /// Predicate for showing value in trigger.
  Predicate<T>? get showValuePredicate;

  /// Expand icon for the select.
  Widget? get expandIcon;
}
