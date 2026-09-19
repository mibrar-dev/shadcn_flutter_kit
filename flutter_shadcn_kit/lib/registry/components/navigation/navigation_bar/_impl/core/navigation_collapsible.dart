// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../navigation_bar.dart';

/// A navigation item that can expand to reveal nested navigation items
/// (upstream parity with `shadcn_flutter`'s `NavigationCollapsible`).
///
/// Provides a labeled header row that toggles visibility of sub-items.
/// Intended for hierarchical navigation structures, especially in vertical
/// sidebars or rails.
///
/// This registry port keeps the upstream public API (header selection,
/// controlled/uncontrolled expansion, indentation) while rendering through
/// the registry's own [Hidden], [SelectedButton], [_NavigationLabeled] and
/// [_NavigationChildOverflowHandle] primitives. Upstream-only decorations
/// (`TreeTheme` branch lines) are intentionally omitted; [childIndent]
/// controls nesting indentation instead.
///
/// Selection follows the container convention: when the surrounding
/// container provides [NavigationControlData.selectedKey] (non-null), the
/// header's `key` is matched against it and takes precedence over
/// index-based selection.
///
/// Example:
/// ```dart
/// NavigationCollapsible(
///   key: ValueKey('settings'),
///   label: Text('Settings'),
///   leading: Icon(Icons.settings),
///   children: [
///     NavigationItem(child: Icon(Icons.person), label: Text('Profile')),
///   ],
/// )
/// ```
class NavigationCollapsible extends StatefulWidget {
  /// Optional leading widget for the group header.
  final Widget? leading;

  /// Label widget for the group header.
  final Widget label;

  /// The nested navigation items for this group.
  final List<Widget> children;

  /// Whether the group is expanded (controlled mode).
  final bool? expanded;

  /// Initial expanded state when uncontrolled.
  final bool initialExpanded;

  /// Callback when expansion state changes.
  final ValueChanged<bool>? onExpandedChanged;

  /// Custom style when the group header is selected.
  final AbstractButtonStyle? selectedStyle;

  /// Whether the group header is currently selected.
  final bool? selected;

  /// Callback when header selection changes.
  final ValueChanged<bool>? onChanged;

  /// Optional button style for the header.
  final AbstractButtonStyle? style;

  /// Optional custom trailing widget for the expand indicator.
  final Widget? trailing;

  /// Indentation applied to nested items.
  final double? childIndent;

  /// Spacing between leading widget and label.
  final double? spacing;

  /// Content alignment within the header button.
  final AlignmentGeometry? alignment;

  /// Whether the header is enabled for interaction.
  final bool? enabled;

  /// How to handle label overflow.
  final NavigationOverflow overflow;

  /// Creates a [NavigationCollapsible].
  const NavigationCollapsible({
    super.key,
    this.leading,
    required this.label,
    required this.children,
    this.expanded,
    this.initialExpanded = false,
    this.onExpandedChanged,
    this.selectedStyle,
    this.selected,
    this.onChanged,
    this.style,
    this.trailing,
    this.childIndent,
    this.spacing,
    this.alignment,
    this.enabled,
    this.overflow = NavigationOverflow.marquee,
  });

  @override
  State<NavigationCollapsible> createState() => _NavigationCollapsibleState();
}

/// State for [NavigationCollapsible].
class _NavigationCollapsibleState extends State<NavigationCollapsible> {
  late bool _expanded;

  bool get _isExpanded => widget.expanded ?? _expanded;

  @override
  void initState() {
    super.initState();
    _expanded = widget.expanded ?? widget.initialExpanded;
  }

  @override
  void didUpdateWidget(covariant NavigationCollapsible oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.expanded != null && widget.expanded != oldWidget.expanded) {
      _expanded = widget.expanded ?? _expanded;
    }
  }

  void _toggleExpanded() {
    if (widget.enabled == false || widget.children.isEmpty) return;
    final next = !_isExpanded;
    if (widget.expanded == null) {
      setState(() => _expanded = next);
    }
    widget.onExpandedChanged?.call(next);
  }

  @override
  Widget build(BuildContext context) {
    final data = Data.maybeOf<NavigationControlData>(context);
    final theme = Theme.of(context);
    final scaling = theme.scaling;
    final densityGap = theme.density.baseGap * scaling;
    final labelType = data?.parentLabelType ?? NavigationLabelType.none;
    final direction = data?.direction ?? Axis.vertical;
    final showLabel =
        labelType == NavigationLabelType.all ||
        (labelType == NavigationLabelType.expanded && data?.expanded == true);
    final canShowLabel =
        labelType == NavigationLabelType.expanded ||
        labelType == NavigationLabelType.all ||
        labelType == NavigationLabelType.selected;

    final containerKey = data?.selectedKey;
    final bool? keySelected = containerKey == null
        ? null
        : (widget.key != null && widget.key == containerKey);
    final isSelected = widget.selected ?? keySelected ?? false;

    final label = DefaultTextStyle.merge(
      textAlign: TextAlign.center,
      child: _NavigationChildOverflowHandle(
        overflow: widget.overflow,
        child: data?.parentLabelSize == NavigationLabelSize.small
            ? widget.label.xSmall()
            : widget.label,
      ),
    );
    final content = _NavigationLabeled(
      label: label,
      showLabel: showLabel,
      labelType: labelType,
      direction: direction,
      keepMainAxisSize: (data?.keepMainAxisSize ?? false) && canShowLabel,
      keepCrossAxisSize: (data?.keepCrossAxisSize ?? false) && canShowLabel,
      position: data?.parentLabelPosition ?? NavigationLabelPosition.bottom,
      spacing: widget.spacing ?? densityGap,
      child: widget.leading ?? const SizedBox.shrink(),
    );

    final AbstractButtonStyle style =
        widget.style ??
        (data?.containerType != NavigationContainerType.sidebar
            ? const ButtonStyle.ghost(density: ButtonDensity.icon)
            : const ButtonStyle.ghost());
    final AbstractButtonStyle selectedStyle =
        widget.selectedStyle ??
        (data?.containerType != NavigationContainerType.sidebar
            ? const ButtonStyle.secondary(density: ButtonDensity.icon)
            : const ButtonStyle.secondary());

    final hasChildren = widget.children.isNotEmpty;
    final parentExpanded = data?.expanded ?? true;
    final indent = widget.childIndent ?? densityGap;

    Widget header = SelectedButton(
      value: isSelected,
      enabled: widget.enabled,
      onChanged: (value) {
        widget.onChanged?.call(value);
        final itemKey = widget.key;
        if (value && itemKey != null) data?.onSelectedKey?.call(itemKey);
        if (hasChildren && parentExpanded) _toggleExpanded();
      },
      style: style,
      selectedStyle: selectedStyle,
      alignment: widget.alignment,
      child: Row(
        children: [
          Expanded(child: content),
          if (hasChildren)
            Hidden(
              hidden: !(data?.expanded ?? true),
              direction: Axis.horizontal,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(width: densityGap),
                  AnimatedRotation(
                    turns: _isExpanded ? 0.25 : 0.0,
                    duration: kDefaultDuration,
                    child: IconTheme.merge(
                      data: IconThemeData(size: 16 * scaling),
                      child:
                          widget.trailing ??
                          const Icon(Icons.chevron_right),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );

    final childControlData = data == null
        ? null
        : NavigationControlData(
            containerType: data.containerType,
            parentLabelType: data.parentLabelType,
            parentLabelPosition: data.parentLabelPosition,
            parentLabelSize: data.parentLabelSize,
            parentPadding: data.parentPadding,
            direction: Axis.vertical,
            selectedIndex: data.selectedIndex,
            onSelected: data.onSelected,
            selectedKey: data.selectedKey,
            onSelectedKey: data.onSelectedKey,
            expanded: data.expanded,
            childCount: widget.children.length,
            spacing: data.spacing,
            keepCrossAxisSize: data.keepCrossAxisSize,
            keepMainAxisSize: data.keepMainAxisSize,
          );
    final childList = Data.inherit(
      data: childControlData,
      child: Padding(
        padding: EdgeInsetsDirectional.only(start: indent),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: widget.children,
        ),
      ),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        header,
        ClipRect(
          child: Hidden(
            hidden: !_isExpanded || !parentExpanded,
            direction: Axis.vertical,
            child: childList,
          ),
        ),
      ],
    );
  }
}
