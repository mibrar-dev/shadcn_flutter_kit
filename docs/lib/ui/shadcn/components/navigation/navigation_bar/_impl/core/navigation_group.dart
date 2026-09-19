// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../navigation_bar.dart';

/// Multi-purpose navigation group that organizes children with a label
/// (upstream parity with `shadcn_flutter`'s `NavigationGroup`).
///
/// Groups [children] under [label], which is positioned according to
/// [labelPosition]. In non-sidebar containers this renders as a flex column
/// (or row for horizontal navigation); sidebar sliver chrome from upstream
/// (pinned/floating headers) is simplified to the same box layout so the
/// widget works in every container without sliver context requirements.
///
/// Example:
/// ```dart
/// NavigationGroup(
///   label: Text('Main'),
///   children: [
///     NavigationItem(child: Icon(Icons.home), label: Text('Home')),
///   ],
/// )
/// ```
class NavigationGroup extends StatelessWidget {
  /// Label widget to display for the group.
  final Widget label;

  /// The child items within this group.
  final List<Widget> children;

  /// Position of the label relative to the children.
  final NavigationLabelPosition labelPosition;

  /// Alignment of the label content.
  final AlignmentGeometry? labelAlignment;

  /// Padding around the label.
  final EdgeInsetsGeometry? labelPadding;

  /// How to handle label text overflow.
  final NavigationOverflow labelOverflow;

  /// Whether the label floats when scrolling (accepted for upstream parity;
  /// sidebar sliver pinning is simplified in this port — stored, no-op).
  final bool labelFloating;

  /// Whether the label is pinned when scrolling (accepted for upstream
  /// parity; sidebar sliver pinning is simplified in this port — stored,
  /// documented, no-op).
  final bool labelPinned;

  /// Creates a new navigation group.
  const NavigationGroup({
    super.key,
    required this.label,
    this.children = const [],
    this.labelPosition = NavigationLabelPosition.top,
    this.labelAlignment,
    this.labelPadding,
    this.labelOverflow = NavigationOverflow.clip,
    this.labelFloating = false,
    this.labelPinned = true,
  });

  @override
  Widget build(BuildContext context) {
    final data = Data.maybeOf<NavigationControlData>(context);
    final theme = Theme.of(context);
    final scaling = theme.scaling;
    final densityContentPadding = theme.density.baseContentPadding * scaling;
    final direction = data?.direction ?? Axis.vertical;

    final labelWidget = Hidden(
      hidden: !(data?.expanded ?? true),
      direction: direction,
      reverse: true,
      child: DefaultTextStyle.merge(
        textAlign: TextAlign.center,
        maxLines: 1,
        child: _NavigationChildOverflowHandle(
          overflow: labelOverflow,
          child: label,
        ),
      ),
    );
    final paddedLabel = Container(
      alignment: labelAlignment ?? Alignment.center,
      padding:
          labelPadding ??
          EdgeInsets.symmetric(horizontal: densityContentPadding * 0.5),
      child: labelWidget,
    );

    final childControlData = data == null
        ? null
        : NavigationControlData(
            containerType: data.containerType,
            parentLabelType: data.parentLabelType,
            parentLabelPosition: data.parentLabelPosition,
            parentLabelSize: data.parentLabelSize,
            parentPadding: data.parentPadding,
            direction: data.direction,
            selectedIndex: data.selectedIndex,
            onSelected: data.onSelected,
            selectedKey: data.selectedKey,
            onSelectedKey: data.onSelectedKey,
            expanded: data.expanded,
            childCount: children.length,
            spacing: data.spacing,
            keepCrossAxisSize: data.keepCrossAxisSize,
            keepMainAxisSize: data.keepMainAxisSize,
          );

    final groupChildren = Data.inherit(
      data: childControlData,
      child: Flex(
        direction: direction,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );

    final gap = theme.density.baseGap * scaling * 0.5;
    final spacer = direction == Axis.horizontal
        ? SizedBox(width: gap)
        : SizedBox(height: gap);

    return Flex(
      direction: direction,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (labelPosition == NavigationLabelPosition.top ||
            labelPosition == NavigationLabelPosition.start) ...[
          paddedLabel,
          spacer,
        ],
        groupChildren,
        if (labelPosition == NavigationLabelPosition.bottom ||
            labelPosition == NavigationLabelPosition.end) ...[
          spacer,
          paddedLabel,
        ],
      ],
    );
  }
}

/// A navigation header/footer item with configurable content
/// (upstream parity with `shadcn_flutter`'s `NavigationSlot`).
///
/// Designed for navigation header and footer sections (see
/// [NavigationRail.header]/[NavigationRail.footer] and
/// [NavigationSidebar.header]/[NavigationSidebar.footer]). The layout adapts
/// to the navigation expansion state and keeps a compact density when
/// collapsed.
///
/// Example:
/// ```dart
/// NavigationSlot(
///   leading: CircleAvatar(child: Text('A')),
///   title: Text('Ada'),
///   subtitle: Text('Admin'),
///   onPressed: () => _openProfile(),
/// )
/// ```
class NavigationSlot extends StatelessWidget {
  /// Leading widget (usually an icon or avatar).
  final Widget leading;

  /// Primary title widget.
  final Widget title;

  /// Optional subtitle widget shown under the title.
  final Widget? subtitle;

  /// Optional trailing widget (often a chevron or action icon).
  final Widget? trailing;

  /// Gap between the text block and trailing widget.
  final double? trailingGap;

  /// Callback for press interactions.
  final VoidCallback? onPressed;

  /// Alignment for the button content.
  final AlignmentGeometry? alignment;

  /// Creates a [NavigationSlot].
  const NavigationSlot({
    super.key,
    required this.leading,
    required this.title,
    this.subtitle,
    this.trailing,
    this.trailingGap,
    this.onPressed,
    this.alignment,
  });

  @override
  Widget build(BuildContext context) {
    final data = Data.maybeOf<NavigationControlData>(context);
    final theme = Theme.of(context);
    final scaling = theme.scaling;
    final densityGap = theme.density.baseGap * scaling;
    final expanded = data?.expanded ?? true;
    final showLabel =
        data == null ||
        data.parentLabelType == NavigationLabelType.all ||
        (data.parentLabelType == NavigationLabelType.expanded && expanded);

    final titleColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [title, if (subtitle != null) subtitle!],
    );

    final content = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        leading,
        SizedBox(width: showLabel ? densityGap : 0),
        Flexible(
          child: Hidden(
            hidden: !showLabel,
            direction: Axis.horizontal,
            child: DefaultTextStyle.merge(
              maxLines: 1,
              overflow: TextOverflow.clip,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(child: titleColumn),
                  if (trailing != null) ...[
                    SizedBox(width: trailingGap ?? densityGap),
                    trailing!,
                  ],
                ],
              ),
            ),
          ),
        ),
      ],
    );

    return Button(
      onPressed: onPressed,
      alignment: alignment,
      style: const ButtonStyle.ghost(density: ButtonDensity.compact),
      child: content,
    );
  }
}
