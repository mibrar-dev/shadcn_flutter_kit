// The navigation item widgets shared by the `navigation_bar` component.
//
// Ported from `components/navigation/navigation_bar/_impl/core/navigation_item.dart`,
// `navigation_collapsible.dart`, `navigation_group.dart`, `navigation_label.dart`
// and `navigation_divider.dart`. They live in `primitives/navigation` (P4-B22,
// Q7) so the component keeps its three-Dart-file folder.
//
// No component is imported: the container injects the tooltip and marquee
// wrappers through `NavigationControlData`, and the icons are foundation glyphs.

import 'package:flutter/widgets.dart';

import '../../foundation/constants.dart';
import '../../foundation/data.dart';
import '../../foundation/gap.dart';
import '../../foundation/icons/radix_icons.dart';
import '../../theme/theme.dart';
import '../hidden.dart';
import 'navigation_item_row.dart';
import 'navigation_theme.dart';

/// The container data navigation items read; one instance per container build.
typedef NavigationControlData = ({
  NavigationContainerType container,
  Axis direction,
  NavigationLabelType labelType,
  NavigationLabelPosition labelPosition,
  NavigationLabelSize labelSize,
  int? selectedIndex,
  ValueChanged<int> onSelected,
  bool expanded,
  NavigationItemStyle itemStyle,
  NavigationItemStyle activeItemStyle,
  Widget Function(Widget child, Widget label)? tooltipWrapper,
  Widget Function(Widget label)? marqueeWrapper,
});

/// The per-child position data the container wraps children with.
typedef NavigationChildData = ({int? index, int actualIndex});

/// Lookup key of a collapsible's children wrapper (tests, scroll-to).
const ValueKey<String> navigationCollapsibleChildrenKey = ValueKey<String>(
  'shadcn.navigationBar.collapsibleChildren',
);

/// A widget that can live in a `NavigationBar`.
abstract class NavigationBarItem extends Widget {
  /// Creates a navigation bar item.
  const NavigationBarItem({super.key});

  /// Whether the container numbers this child for index-based selection.
  bool get selectable;
}

/// One selectable navigation item, or an action when [onPressed] is set.
///
/// ```dart
/// NavigationItem(child: Icon(RadixIcons.home), label: Text('Home'))
/// NavigationItem(child: Icon(RadixIcons.gear), onPressed: _openSettings)
/// ```
class NavigationItem extends StatelessWidget implements NavigationBarItem {
  /// Creates a navigation item.
  const NavigationItem({
    super.key,
    required this.child,
    this.label,
    this.index,
    this.selected,
    this.onChanged,
    this.onPressed,
    this.enabled,
    this.overflow = NavigationOverflow.ellipsis,
    this.style,
    this.activeStyle,
  });
  final Widget child;
  final Widget? label;
  final int? index;
  final bool? selected;
  final ValueChanged<bool>? onChanged;
  final VoidCallback? onPressed;
  final bool? enabled;
  final NavigationOverflow overflow;
  final NavigationItemStyle? style;
  final NavigationItemStyle? activeStyle;

  @override
  bool get selectable => onPressed == null;

  @override
  Widget build(BuildContext context) {
    final NavigationControlData? data = Data.maybeOf<NavigationControlData>(
      context,
    );
    final NavigationChildData? childData = Data.maybeOf<NavigationChildData>(
      context,
    );
    final int? effective = childData?.index ?? index;
    final bool isSelected =
        selected ?? (effective != null && effective == data?.selectedIndex);
    final NavigationItemStyle base =
        style?.merge(data?.itemStyle) ??
        data?.itemStyle ??
        navigationItemDefaults;
    final NavigationItemStyle active =
        activeStyle?.merge(data?.activeItemStyle) ??
        data?.activeItemStyle ??
        navigationActiveItemDefaults;
    return _navigationRow(
      context,
      child: child,
      label: label,
      style: isSelected ? active : base,
      selected: isSelected,
      enabled: enabled ?? true,
      onPressed:
          onPressed ??
          () {
            onChanged?.call(!isSelected);
            if (!isSelected && effective != null) {
              data?.onSelected(effective);
            }
          },
      registryValue: onPressed == null ? effective : null,
      overflow: overflow,
    );
  }
}

/// A navigation item that expands to reveal nested items.
class NavigationCollapsible extends StatefulWidget
    implements NavigationBarItem {
  /// Creates a collapsible navigation item.
  const NavigationCollapsible({
    super.key,
    required this.label,
    required this.children,
    this.leading,
    this.expanded,
    this.initialExpanded = false,
    this.onExpandedChanged,
    this.selected,
    this.onChanged,
    this.enabled,
    this.childIndent,
    this.overflow = NavigationOverflow.ellipsis,
  });
  final Widget label;
  final List<Widget> children;
  final Widget? leading;
  final bool? expanded;
  final bool initialExpanded;
  final ValueChanged<bool>? onExpandedChanged;
  final bool? selected;
  final ValueChanged<bool>? onChanged;
  final bool? enabled;
  final double? childIndent;
  final NavigationOverflow overflow;

  @override
  bool get selectable => true;

  @override
  State<NavigationCollapsible> createState() => _NavigationCollapsibleState();
}

class _NavigationCollapsibleState extends State<NavigationCollapsible> {
  late bool _expanded = widget.expanded ?? widget.initialExpanded;

  @override
  void didUpdateWidget(covariant NavigationCollapsible oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.expanded != null) {
      _expanded = widget.expanded!;
    }
  }

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData ambient = ShadcnTheme.of(context);
    final NavigationControlData? data = Data.maybeOf<NavigationControlData>(
      context,
    );
    final NavigationChildData? childData = Data.maybeOf<NavigationChildData>(
      context,
    );
    final bool isSelected =
        widget.selected ??
        (childData?.index != null && childData!.index == data?.selectedIndex);
    final bool expanded = widget.expanded ?? _expanded;
    final Widget header = _navigationRow(
      context,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          widget.leading ?? const SizedBox.shrink(),
          if (widget.children.isNotEmpty)
            AnimatedRotation(
              turns: expanded ? 0.25 : 0,
              duration: kDefaultDuration,
              child: const Icon(RadixIcons.chevronRight),
            ),
        ],
      ),
      label: widget.label,
      style: isSelected
          ? (data?.activeItemStyle ?? navigationActiveItemDefaults)
          : (data?.itemStyle ?? navigationItemDefaults),
      selected: isSelected,
      enabled: widget.enabled ?? true,
      onPressed: () {
        widget.onChanged?.call(!isSelected);
        if (!isSelected && childData?.index != null) {
          data?.onSelected(childData!.index!);
        }
        if (widget.children.isNotEmpty) {
          final bool next = !expanded;
          if (widget.expanded == null) {
            setState(() => _expanded = next);
          }
          widget.onExpandedChanged?.call(next);
        }
      },
      registryValue: childData?.index,
      overflow: widget.overflow,
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        header,
        Hidden(
          key: navigationCollapsibleChildrenKey,
          hidden: !expanded || !(data?.expanded ?? true),
          direction: Axis.vertical,
          child: Padding(
            padding: EdgeInsetsDirectional.only(
              start: widget.childIndent ?? 16 * ambient.scaling,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: widget.children,
            ),
          ),
        ),
      ],
    );
  }
}

/// A custom header/footer item: leading, title/subtitle and trailing, with an
/// optional press action (the old `NavigationSlot`).
class NavigationSlot extends StatelessWidget implements NavigationBarItem {
  /// Creates a navigation slot.
  const NavigationSlot({
    super.key,
    required this.leading,
    required this.title,
    this.subtitle,
    this.trailing,
    this.trailingGap,
    this.onPressed,
    this.overflow = NavigationOverflow.ellipsis,
  });

  /// Leading widget (usually an avatar or icon).
  final Widget leading;
  final Widget title;
  final Widget? subtitle;
  final Widget? trailing;

  /// Gap between the title block and [trailing].
  final double? trailingGap;

  /// Press callback; null renders an inert slot.
  final VoidCallback? onPressed;
  final NavigationOverflow overflow;

  @override
  bool get selectable => false;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData ambient = ShadcnTheme.of(context);
    final NavigationControlData? data = Data.maybeOf<NavigationControlData>(
      context,
    );
    final Widget? trailing = this.trailing;
    return _navigationRow(
      context,
      child: leading,
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[title, ?subtitle],
            ),
          ),
          if (trailing != null) ...<Widget>[
            Gap((trailingGap ?? 8) * ambient.scaling),
            trailing,
          ],
        ],
      ),
      style: data?.itemStyle ?? navigationItemDefaults,
      selected: false,
      enabled: true,
      onPressed: onPressed,
      overflow: overflow,
    );
  }
}

/// Builds one styled, labelled navigation row from the ambient control data.
Widget _navigationRow(
  BuildContext context, {
  required Widget child,
  Widget? label,
  required NavigationItemStyle style,
  required bool selected,
  bool enabled = true,
  VoidCallback? onPressed,
  int? registryValue,
  NavigationOverflow overflow = NavigationOverflow.clip,
}) {
  final ShadcnThemeData ambient = ShadcnTheme.of(context);
  final NavigationControlData? data = Data.maybeOf<NavigationControlData>(
    context,
  );
  final NavigationLabelType labelType =
      data?.labelType ?? NavigationLabelType.none;
  final bool showLabel =
      labelType == NavigationLabelType.all ||
      (labelType == NavigationLabelType.selected && selected) ||
      (labelType == NavigationLabelType.expanded && (data?.expanded ?? true));
  Widget row = NavigationItemRow(
    label: label,
    selected: selected,
    enabled: enabled,
    showLabel: showLabel,
    position: data?.labelPosition ?? NavigationLabelPosition.bottom,
    spacing: 8 * ambient.scaling,
    labelStyle:
        (data?.labelSize ?? NavigationLabelSize.small) ==
            NavigationLabelSize.small
        ? ambient.typography.xSmall
        : ambient.typography.small,
    overflow: switch (overflow) {
      NavigationOverflow.ellipsis => TextOverflow.ellipsis,
      NavigationOverflow.none => TextOverflow.visible,
      NavigationOverflow.clip ||
      NavigationOverflow.marquee => TextOverflow.clip,
    },
    wrapLabel: showLabel && overflow == NavigationOverflow.marquee
        ? data?.marqueeWrapper
        : null,
    background: style.background,
    foreground: style.foreground,
    borderColor: style.borderColor,
    borderWidth: style.borderWidth ?? 1,
    padding: style.padding,
    minHeight: style.minHeight,
    textStyle: style.textStyle,
    onPressed: enabled ? onPressed : null,
    registryValue: registryValue,
    child: child,
  );
  final Widget Function(Widget child, Widget label)? tooltipWrapper =
      data?.tooltipWrapper;
  if (labelType == NavigationLabelType.tooltip &&
      label != null &&
      tooltipWrapper != null) {
    row = tooltipWrapper(row, label);
  }
  return row;
}
