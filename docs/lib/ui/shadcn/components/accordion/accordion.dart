// The `accordion` component: stacked sections where only one panel is open at
// a time.
//
// `Accordion` owns the single-open state and renders dividers between items;
// `AccordionItem` animates its content; `AccordionTrigger` is the keyboard-
// and pointer-accessible header. Interaction lives in `Clickable`, the arrow
// uses the bundled Lucide set and no Material import remains.

import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../../foundation/constants.dart';
import '../../foundation/data.dart';
import '../../foundation/gap.dart';
import '../../foundation/icons/lucide_icons.dart';
import '../../primitives/clickable.dart';
import '../../primitives/text/text_extension.dart';
import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';
import 'accordion_style.dart';

export 'accordion_style.dart';

/// A container of expandable sections; at most one panel is open.
///
/// ```dart
/// Accordion(
///   items: <Widget>[
///     AccordionItem(
///       trigger: const AccordionTrigger(child: Text('Is it accessible?')),
///       content: const Text('Yes.'),
///     ),
///   ],
/// );
/// ```
class Accordion extends StatefulWidget {
  /// Creates an accordion from [items].
  const Accordion({super.key, required this.items, this.theme});

  /// Usually [AccordionItem] widgets; dividers are inserted between them.
  final List<Widget> items;

  /// Widget-leg style override, merged on top of the other resolver legs.
  final AccordionTheme? theme;

  @override
  State<Accordion> createState() => AccordionState();
}

/// State of [Accordion]: owns the currently expanded item.
class AccordionState extends State<Accordion> {
  /// The item state that is currently expanded, or null.
  final ValueNotifier<Object?> _expanded = ValueNotifier<Object?>(null);

  /// Whether [item] is the expanded one.
  bool isExpanded(Object item) => _expanded.value == item;

  /// Opens [item] or closes it when it was already open.
  void toggle(Object item) {
    _expanded.value = _expanded.value == item ? null : item;
  }

  @override
  void dispose() {
    _expanded.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData ambient = ShadcnTheme.of(context);
    final AccordionTheme resolved =
        resolveComponentStyle<AccordionTheme, AccordionTheme>(
          context,
          widget: widget.theme,
          select: (t) => t,
          defaults: accordionDefaults,
        );
    final double dividerHeight = resolved.dividerHeight ?? 1 * ambient.scaling;
    final Color dividerColor =
        (resolved.dividerColor ?? const ThemedColor.ref(ColorRef.muted))
            .resolve(ambient.colors);
    final List<Widget> children = <Widget>[];
    for (int index = 0; index < widget.items.length; index++) {
      children.add(widget.items[index]);
      if (index < widget.items.length - 1) {
        children.add(
          SizedBox(
            height: dividerHeight,
            child: ColoredBox(color: dividerColor),
          ),
        );
      }
    }
    return Data<AccordionState>.inherit(
      data: this,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );
  }
}

/// One collapsible entry inside an [Accordion].
class AccordionItem extends StatefulWidget {
  /// Creates an accordion entry.
  const AccordionItem({
    super.key,
    required this.trigger,
    required this.content,
    this.expanded = false,
    this.theme,
  });

  /// Widget that toggles this item.
  final Widget trigger;

  /// Content revealed while the item is expanded.
  final Widget content;

  /// Whether the item starts expanded when no other item is.
  final bool expanded;

  /// Widget-leg style override, merged on top of the other resolver legs.
  final AccordionTheme? theme;

  @override
  State<AccordionItem> createState() => _AccordionItemState();
}

class _AccordionItemState extends State<AccordionItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  CurvedAnimation? _curve;
  AccordionState? _accordion;
  bool _expanded = false;
  bool _initialApplied = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: accordionDefaults.duration,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final AccordionState? next = Data.maybeOf<AccordionState>(context);
    if (next != _accordion) {
      _accordion?._expanded.removeListener(_handleExpansionChanged);
      _accordion = next;
      // Apply the initial expansion once, before listening, so a later
      // inherited change cannot re-expand a section the user collapsed.
      if (!_initialApplied && next != null) {
        _initialApplied = true;
        if (widget.expanded && next._expanded.value == null) {
          next._expanded.value = this;
        }
      }
      next?._expanded.addListener(_handleExpansionChanged);
      _syncExpansion(animate: false);
    }
  }

  @override
  void dispose() {
    _accordion?._expanded.removeListener(_handleExpansionChanged);
    _controller.dispose();
    super.dispose();
  }

  /// Whether this item is the expanded one.
  bool get isExpanded => _expanded;

  /// Opens this item or closes it when it was already open.
  void dispatchToggle() {
    _accordion?.toggle(this);
  }

  void _handleExpansionChanged() => _syncExpansion(animate: true);

  void _syncExpansion({required bool animate}) {
    final bool shouldExpand = _accordion?.isExpanded(this) ?? false;
    if (shouldExpand == _expanded) {
      return;
    }
    setState(() {
      _expanded = shouldExpand;
    });
    if (!animate) {
      _controller.value = shouldExpand ? 1 : 0;
    } else if (shouldExpand) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  CurvedAnimation _animationFor(Curve curve, Curve reverseCurve) {
    final CurvedAnimation? current = _curve;
    if (current == null ||
        current.curve != curve ||
        current.reverseCurve != reverseCurve) {
      _curve = CurvedAnimation(
        parent: _controller,
        curve: curve,
        reverseCurve: reverseCurve,
      );
    }
    return _curve!;
  }

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData ambient = ShadcnTheme.of(context);
    final AccordionTheme resolved =
        resolveComponentStyle<AccordionTheme, AccordionTheme>(
          context,
          widget: widget.theme,
          select: (t) => t,
          defaults: accordionDefaults,
        );
    final Duration duration = resolved.duration ?? kDefaultDuration;
    if (_controller.duration != duration) {
      _controller.duration = duration;
    }
    final double padding =
        resolved.padding ??
        (resolved.themeDensity ?? ambient.density).baseContentPadding *
            ambient.scaling;
    return Data<_AccordionItemState>.inherit(
      data: this,
      child: Column(
        children: <Widget>[
          widget.trigger,
          SizeTransition(
            sizeFactor: _animationFor(
              resolved.curve ?? Curves.easeIn,
              resolved.reverseCurve ?? Curves.easeOut,
            ),
            alignment: AlignmentDirectional.topStart,
            child: Padding(
              padding: EdgeInsets.only(bottom: padding),
              child: widget.content.small.normal,
            ),
          ),
        ],
      ),
    );
  }
}

/// The tappable header of an [AccordionItem].
class AccordionTrigger extends StatelessWidget {
  /// Creates a trigger with [child] as its label.
  const AccordionTrigger({super.key, required this.child, this.theme});

  /// Content shown next to the indicator.
  final Widget child;

  /// Widget-leg style override, merged on top of the other resolver legs.
  final AccordionTheme? theme;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData ambient = ShadcnTheme.of(context);
    final AccordionTheme resolved =
        resolveComponentStyle<AccordionTheme, AccordionTheme>(
          context,
          widget: theme,
          select: (t) => t,
          defaults: accordionDefaults,
        );
    final _AccordionItemState item = Data.of<_AccordionItemState>(context);
    final double padding =
        resolved.padding ??
        (resolved.themeDensity ?? ambient.density).baseContentPadding *
            ambient.scaling;
    // shadcn trigger `gap-4` = 16 between the label and the chevron.
    final double iconGap = resolved.iconGap ?? 16 * ambient.scaling;
    final Color arrowColor =
        (resolved.arrowIconColor ??
                const ThemedColor.ref(ColorRef.mutedForeground))
            .resolve(ambient.colors);
    // shadcn chevron `size-4` = 16; prefer the small icon rung so a themed
    // medium (20) rung does not inflate the trigger.
    final double iconSize =
        ambient.iconTheme.small.size ??
        ambient.iconTheme.xSmall.size ??
        ambient.iconTheme.medium.size ??
        16 * ambient.scaling;

    return Semantics(
      button: true,
      expanded: item.isExpanded,
      child: Clickable(
        onPressed: item.dispatchToggle,
        padding: WidgetStatePropertyAll<EdgeInsetsGeometry>(
          EdgeInsets.symmetric(vertical: padding),
        ),
        textStyle: WidgetStateProperty.resolveWith((Set<WidgetState> states) {
          final bool active =
              states.contains(WidgetState.hovered) ||
              states.contains(WidgetState.pressed);
          return TextStyle(
            decoration: active ? TextDecoration.underline : TextDecoration.none,
          );
        }),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: child,
              ),
            ),
            Gap(iconGap),
            TweenAnimationBuilder<double>(
              tween: Tween<double>(end: item.isExpanded ? 0 : 1),
              duration: resolved.duration ?? kDefaultDuration,
              builder: (context, value, child) => Transform.rotate(
                angle: value * math.pi,
                child: IconTheme(
                  data: IconThemeData(color: arrowColor, size: iconSize),
                  child: Icon(resolved.arrowIcon ?? LucideIcons.chevronUp),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
