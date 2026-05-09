// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../navigation_bar.dart';

/// _NavigationButtonState defines a reusable type for this registry module.
class _NavigationButtonState
    extends _AbstractNavigationButtonState<NavigationButton> {
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
    bool showLabel =
        labelType == NavigationLabelType.all ||
        (labelType == NavigationLabelType.expanded && data?.expanded == true);
    AbstractButtonStyle style =
        widget.style ??
        (data?.containerType != NavigationContainerType.sidebar
            ? const ButtonStyle.ghost(density: ButtonDensity.icon)
            : const ButtonStyle.ghost());

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
      child: Button(
        enabled: widget.enabled,
        onPressed: widget.onPressed,
        enableFeedback: widget.enableFeedback,
        marginAlignment: widget.marginAlignment,
        style: style,
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
