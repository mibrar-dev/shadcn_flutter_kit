// The navigation section widgets (group, label, divider) shared by the
// `navigation_bar` component.
//
// Ported from `components/navigation/navigation_bar/_impl/core/navigation_group.dart`,
// `navigation_label.dart` and `navigation_divider.dart`. They live in
// `primitives/navigation` (P4-B22, Q7) with the item widgets.

import 'package:flutter/widgets.dart';

import '../../foundation/data.dart';
import '../../foundation/gap.dart';
import '../../theme/theme.dart';
import '../hidden.dart';
import 'navigation_items.dart';
import 'navigation_theme.dart';

/// A labelled group of navigation items.
class NavigationGroup extends StatelessWidget implements NavigationBarItem {
  /// Creates a navigation group.
  const NavigationGroup({
    super.key,
    required this.label,
    this.children = const <Widget>[],
    this.labelPosition = NavigationLabelPosition.top,
    this.labelAlignment,
    this.labelPadding,
    this.labelOverflow = NavigationOverflow.clip,
  });

  /// Group label.
  final Widget label;

  /// Group items.
  final List<Widget> children;

  /// Label position relative to the items.
  final NavigationLabelPosition labelPosition;

  /// Label alignment.
  final AlignmentGeometry? labelAlignment;

  /// Label padding.
  final EdgeInsetsGeometry? labelPadding;

  /// Label overflow behaviour.
  final NavigationOverflow labelOverflow;

  @override
  bool get selectable => false;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData ambient = ShadcnTheme.of(context);
    final NavigationControlData? data = Data.maybeOf<NavigationControlData>(
      context,
    );
    final Widget padded = Container(
      alignment: labelAlignment ?? Alignment.center,
      padding:
          labelPadding ?? EdgeInsets.symmetric(horizontal: 8 * ambient.scaling),
      child: Hidden(
        hidden: !(data?.expanded ?? true),
        direction: Axis.vertical,
        reverse: true,
        child: DefaultTextStyle.merge(
          style: ambient.typography.xSmall.copyWith(
            color: ambient.colors.mutedForeground,
          ),
          maxLines: 1,
          child: _overflowLabel(label, labelOverflow, data),
        ),
      ),
    );
    final bool top =
        labelPosition == NavigationLabelPosition.top ||
        labelPosition == NavigationLabelPosition.start;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        if (top) ...<Widget>[padded, Gap(4 * ambient.scaling)],
        ...children,
        if (!top) ...<Widget>[Gap(4 * ambient.scaling), padded],
      ],
    );
  }
}

/// A non-interactive section label.
class NavigationLabel extends StatelessWidget implements NavigationBarItem {
  /// Creates a navigation label.
  const NavigationLabel({
    super.key,
    required this.child,
    this.padding,
    this.overflow = NavigationOverflow.clip,
  });

  /// Label content.
  final Widget child;

  /// Label padding.
  final EdgeInsetsGeometry? padding;

  /// Label overflow behaviour.
  final NavigationOverflow overflow;

  @override
  bool get selectable => false;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData ambient = ShadcnTheme.of(context);
    final NavigationControlData? data = Data.maybeOf<NavigationControlData>(
      context,
    );
    return Hidden(
      hidden: !(data?.expanded ?? true),
      direction: data?.direction ?? Axis.vertical,
      child: DefaultTextStyle.merge(
        style: ambient.typography.xSmall.copyWith(
          color: ambient.colors.mutedForeground,
        ),
        maxLines: 1,
        child: Padding(
          padding:
              padding ?? EdgeInsets.symmetric(horizontal: 8 * ambient.scaling),
          child: _overflowLabel(child, overflow, data),
        ),
      ),
    );
  }
}

/// A 1px rule between navigation items.
class NavigationDivider extends StatelessWidget implements NavigationBarItem {
  /// Creates a navigation divider.
  const NavigationDivider({super.key, this.thickness, this.color});

  /// Line thickness; null resolves 1.
  final double? thickness;

  /// Line colour; null resolves the `muted` token.
  final Color? color;

  @override
  bool get selectable => false;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData ambient = ShadcnTheme.of(context);
    final Axis direction =
        Data.maybeOf<NavigationControlData>(context)?.direction ??
        Axis.vertical;
    final bool vertical = direction == Axis.vertical;
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: vertical ? 4 * ambient.scaling : 0,
        horizontal: vertical ? 0 : 4 * ambient.scaling,
      ),
      child: ColoredBox(
        color: color ?? ambient.colors.muted,
        child: SizedBox(
          width: vertical ? null : thickness ?? 1,
          height: vertical ? thickness ?? 1 : null,
        ),
      ),
    );
  }
}

/// Applies the container's marquee wrapper to [label] when requested.
Widget _overflowLabel(
  Widget label,
  NavigationOverflow overflow,
  NavigationControlData? data,
) {
  final Widget Function(Widget label)? marquee = data?.marqueeWrapper;
  if (overflow == NavigationOverflow.marquee && marquee != null) {
    return marquee(label);
  }
  return label;
}

/// A fixed gap between navigation items (the old `NavigationGap`).
class NavigationGap extends StatelessWidget implements NavigationBarItem {
  /// Creates a gap of [gap] logical pixels along the container's main axis.
  const NavigationGap(this.gap, {super.key});

  /// Gap size in logical pixels.
  final double gap;

  @override
  bool get selectable => false;

  @override
  Widget build(BuildContext context) {
    final Axis direction =
        Data.maybeOf<NavigationControlData>(context)?.direction ??
        Axis.vertical;
    return direction == Axis.horizontal
        ? SizedBox(width: gap)
        : SizedBox(height: gap);
  }
}
