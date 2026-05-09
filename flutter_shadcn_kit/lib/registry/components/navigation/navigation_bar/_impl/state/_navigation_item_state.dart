// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../navigation_bar.dart';

/// _NavigationItemState defines a reusable type for this registry module.
class _NavigationItemState
    extends _AbstractNavigationButtonState<NavigationItem> {
  @override
  Widget buildBox(
    BuildContext context,
    NavigationControlData? data,
    NavigationChildControlData? childData,
  ) {
    final theme = Theme.of(context);

    /// Stores `scaling` state/configuration for this implementation.
    final scaling = theme.scaling;

    /// Stores `labelType` state/configuration for this implementation.
    final labelType = data?.parentLabelType ?? NavigationLabelType.none;

    /// Stores `direction` state/configuration for this implementation.
    final direction = data?.direction ?? Axis.vertical;

    /// Stores `index` state/configuration for this implementation.
    var index = childData?.index ?? widget.index;

    /// Stores `isSelected` state/configuration for this implementation.
    var isSelected = widget.selected ?? index == data?.selectedIndex;

    /// Stores `parentIndex` state/configuration for this implementation.
    var parentIndex = childData?.index;
    bool showLabel =
        labelType == NavigationLabelType.all ||
        (labelType == NavigationLabelType.selected && isSelected) ||
        (labelType == NavigationLabelType.expanded && data?.expanded == true);
    AbstractButtonStyle style =
        widget.style ??
        (data?.containerType != NavigationContainerType.sidebar
            ? const ButtonStyle.ghost(density: ButtonDensity.icon)
            : const ButtonStyle.ghost());
    AbstractButtonStyle selectedStyle =
        widget.selectedStyle ??
        (data?.containerType != NavigationContainerType.sidebar
            ? const ButtonStyle.secondary(density: ButtonDensity.icon)
            : const ButtonStyle.secondary());

    Widget? label = widget.label == null
        ? const SizedBox()
        : DefaultTextStyle.merge(
            textAlign: TextAlign.center,
            child: _NavigationChildOverflowHandle(
              overflow: widget.overflow,
              child: data?.parentLabelSize == NavigationLabelSize.small
                  ? widget.label!.xSmall()
                  : widget.label!,
            ),
          );
    var canShowLabel =
        (labelType == NavigationLabelType.expanded ||
        labelType == NavigationLabelType.all ||
        labelType == NavigationLabelType.selected);
    return NavigationPadding(
      child: SelectedButton(
        value: isSelected,
        enabled: widget.enabled,
        onChanged: parentIndex != null || widget.index != null
            ? (value) {
                widget.onChanged?.call(value);
                data?.onSelected(parentIndex ?? widget.index!);
              }
            : widget.onChanged,
        marginAlignment: widget.marginAlignment,
        style: style,
        selectedStyle: selectedStyle,
        alignment:
            widget.alignment ??
            (data?.containerType == NavigationContainerType.sidebar &&
                    data?.labelDirection == Axis.horizontal
                ? (data?.parentLabelPosition == NavigationLabelPosition.start
                      ? AlignmentDirectional.centerEnd
                      : AlignmentDirectional.centerStart)
                : null),
        child: _NavigationLabeled(
          label: label,
          showLabel: showLabel,
          labelType: labelType,
          direction: direction,
          keepMainAxisSize: (data?.keepMainAxisSize ?? false) && canShowLabel,
          keepCrossAxisSize: (data?.keepCrossAxisSize ?? false) && canShowLabel,
          position: data?.parentLabelPosition ?? NavigationLabelPosition.bottom,
          spacing: widget.spacing ?? (theme.density.baseGap * scaling),
          child: widget.child,
        ),
      ),
    );
  }
}
