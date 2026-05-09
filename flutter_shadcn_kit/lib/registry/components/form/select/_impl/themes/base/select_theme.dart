// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../../select.dart';

/// Theme data for customizing [Select] widget appearance and behavior.
///
/// This class defines the visual and behavioral properties that can be applied to
/// [Select] widgets, including popup constraints, positioning, styling, and
/// interaction behaviors. These properties can be set at the theme level
/// to provide consistent behavior across the application.
class SelectTheme extends ComponentThemeData {
  /// Constraints for the popup menu size.
  final BoxConstraints? popupConstraints;

  /// Alignment of the popover relative to the anchor.
  final AlignmentGeometry? popoverAlignment;

  /// Anchor alignment for the popover.
  final AlignmentGeometry? popoverAnchorAlignment;

  /// Border radius for select items.
  final BorderRadiusGeometry? borderRadius;

  /// Padding inside select items.
  final EdgeInsetsGeometry? padding;

  /// Whether to disable hover effects on items.
  final bool? disableHoverEffect;

  /// Whether the selected item can be unselected.
  final bool? canUnselect;

  /// Whether to automatically close the popover after selection.
  final bool? autoClosePopover;

  /// Creates a select theme.
  const SelectTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.popupConstraints,
    this.popoverAlignment,
    this.popoverAnchorAlignment,
    this.borderRadius,
    this.padding,
    this.disableHoverEffect,
    this.canUnselect,
    this.autoClosePopover,
  });

  /// Creates a copy of this theme with the given fields replaced.
  SelectTheme copyWith({
    ValueGetter<BoxConstraints?>? popupConstraints,
    ValueGetter<AlignmentGeometry?>? popoverAlignment,
    ValueGetter<AlignmentGeometry?>? popoverAnchorAlignment,
    ValueGetter<BorderRadiusGeometry?>? borderRadius,
    ValueGetter<EdgeInsetsGeometry?>? padding,
    ValueGetter<bool?>? disableHoverEffect,
    ValueGetter<bool?>? canUnselect,
    ValueGetter<bool?>? autoClosePopover,
  }) {
    return SelectTheme(
      popupConstraints: popupConstraints == null
          ? this.popupConstraints
          : popupConstraints(),
      popoverAlignment: popoverAlignment == null
          ? this.popoverAlignment
          : popoverAlignment(),
      popoverAnchorAlignment: popoverAnchorAlignment == null
          ? this.popoverAnchorAlignment
          : popoverAnchorAlignment(),
      borderRadius: borderRadius == null ? this.borderRadius : borderRadius(),
      padding: padding == null ? this.padding : padding(),
      disableHoverEffect: disableHoverEffect == null
          ? this.disableHoverEffect
          : disableHoverEffect(),
      canUnselect: canUnselect == null ? this.canUnselect : canUnselect(),
      autoClosePopover: autoClosePopover == null
          ? this.autoClosePopover
          : autoClosePopover(),
    );
  }

  /// Compares this object with another for value equality.
  @override
  bool operator ==(Object other) {
    return other is SelectTheme &&
        other.popupConstraints == popupConstraints &&
        other.popoverAlignment == popoverAlignment &&
        other.popoverAnchorAlignment == popoverAnchorAlignment &&
        other.borderRadius == borderRadius &&
        other.padding == padding &&
        other.disableHoverEffect == disableHoverEffect &&
        other.canUnselect == canUnselect &&
        other.autoClosePopover == autoClosePopover;
  }

  @override
  int get hashCode => Object.hash(
    popupConstraints,
    popoverAlignment,
    popoverAnchorAlignment,
    borderRadius,
    padding,
    disableHoverEffect,
    canUnselect,
    autoClosePopover,
  );
}
