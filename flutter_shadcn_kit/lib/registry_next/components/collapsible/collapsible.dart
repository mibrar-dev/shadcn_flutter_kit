// The `collapsible` component: an expandable section that keeps its own
// open/close state by default.
//
// `Collapsible` provides the expansion state through `foundation/data.dart`;
// `CollapsibleTrigger` toggles it and `CollapsibleContent` hides or shows its
// child. The trigger icon is the component's `Button` (ghost, icon size).

import 'package:flutter/widgets.dart';

import '../../foundation/data.dart';
import '../../foundation/gap.dart';
import '../../foundation/icons/lucide_icons.dart';
import '../../primitives/text/text_extension.dart';
import '../../theme/theme.dart';
import '../button/button.dart';
import 'collapsible_style.dart';

export 'collapsible_style.dart';

/// Expansion state shared with the trigger and content widgets.
class _CollapsibleData {
  const _CollapsibleData({required this.isExpanded, required this.toggle});

  final bool isExpanded;
  final VoidCallback toggle;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _CollapsibleData &&
          other.isExpanded == isExpanded &&
          other.toggle == toggle;

  @override
  int get hashCode => Object.hash(isExpanded, toggle);
}

/// An expandable section.
///
/// ```dart
/// Collapsible(
///   children: <Widget>[
///     const CollapsibleTrigger(child: Text('Recent activity')),
///     CollapsibleContent(child: activityList),
///   ],
/// );
/// ```
class Collapsible extends StatefulWidget {
  /// Creates a collapsible section.
  const Collapsible({
    super.key,
    required this.children,
    this.isExpanded,
    this.onExpansionChanged,
    this.theme,
  });

  /// Usually one [CollapsibleTrigger] followed by [CollapsibleContent]s.
  final List<Widget> children;

  /// Expanded state. Non-null makes the widget controlled; null lets it keep
  /// its own state.
  final bool? isExpanded;

  /// Called with the **new** expansion state when the trigger is tapped.
  final ValueChanged<bool>? onExpansionChanged;

  /// Widget-leg style override, merged on top of the other resolver legs.
  final CollapsibleTheme? theme;

  @override
  State<Collapsible> createState() => CollapsibleState();
}

/// State of [Collapsible]: owns the uncontrolled flag and the toggle action.
class CollapsibleState extends State<Collapsible> {
  bool _uncontrolledExpanded = false;

  bool get _isExpanded => widget.isExpanded ?? _uncontrolledExpanded;

  /// Flips the section and reports the new state.
  void toggle() {
    final bool next = !_isExpanded;
    if (widget.isExpanded == null) {
      setState(() {
        _uncontrolledExpanded = next;
      });
    }
    widget.onExpansionChanged?.call(next);
  }

  @override
  Widget build(BuildContext context) {
    final CollapsibleTheme resolved =
        resolveComponentStyle<CollapsibleTheme, CollapsibleTheme>(
          context,
          widget: widget.theme,
          select: (t) => t,
          defaults: collapsibleDefaults,
        );
    return Data<_CollapsibleData>.inherit(
      data: _CollapsibleData(isExpanded: _isExpanded, toggle: toggle),
      child: IntrinsicWidth(
        child: Column(
          crossAxisAlignment:
              resolved.crossAxisAlignment ?? CrossAxisAlignment.stretch,
          mainAxisAlignment:
              resolved.mainAxisAlignment ?? MainAxisAlignment.start,
          children: widget.children,
        ),
      ),
    );
  }
}

/// The tappable header of a [Collapsible].
class CollapsibleTrigger extends StatelessWidget {
  /// Creates a trigger with [child] as its label.
  const CollapsibleTrigger({super.key, required this.child, this.theme});

  /// Content shown next to the expand/collapse icon.
  final Widget child;

  /// Widget-leg style override, merged on top of the other resolver legs.
  final CollapsibleTheme? theme;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData ambient = ShadcnTheme.of(context);
    final CollapsibleTheme resolved =
        resolveComponentStyle<CollapsibleTheme, CollapsibleTheme>(
          context,
          widget: theme,
          select: (t) => t,
          defaults: collapsibleDefaults,
        );
    final _CollapsibleData data = Data.of<_CollapsibleData>(context);
    final double padding =
        resolved.padding ??
        (resolved.themeDensity ?? ambient.density).baseContentPadding *
            ambient.scaling;
    final double iconGap = resolved.iconGap ?? 16 * ambient.scaling;
    final IconData icon = data.isExpanded
        ? resolved.iconExpanded ?? LucideIcons.chevronsDownUp
        : resolved.iconCollapsed ?? LucideIcons.chevronsUpDown;
    final IconThemeData iconTheme = IconThemeData(
      size:
          ambient.iconTheme.xSmall.size ??
          ambient.iconTheme.small.size ??
          16 * ambient.scaling,
      color: ambient.colors.mutedForeground,
    );

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(child: child.small.semiBold),
          Gap(iconGap),
          Button(
            variant: ButtonVariant.ghost,
            size: ButtonSize.icon,
            onPressed: data.toggle,
            child: IconTheme(data: iconTheme, child: Icon(icon)),
          ),
        ],
      ),
    );
  }
}

/// The content pane of a [Collapsible].
class CollapsibleContent extends StatelessWidget {
  /// Creates a content pane.
  const CollapsibleContent({
    super.key,
    this.collapsible = true,
    required this.child,
  });

  /// Whether this pane follows the section's expansion state.
  final bool collapsible;

  /// The widget shown while expanded.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final _CollapsibleData data = Data.of<_CollapsibleData>(context);
    return Offstage(offstage: collapsible && !data.isExpanded, child: child);
  }
}
