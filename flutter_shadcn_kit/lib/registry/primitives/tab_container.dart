// Shared tab-indexing machinery: [TabContainer] assigns indices to [TabItem]
// children and publishes [TabContainerData]; [Tabs] and [TabPane] paint on
// top of it and custom strips build on it directly.
//
// Lives in `primitives/` (not the `tabs` component) so both the strip and
// the pane share one owner without duplicating the 21 names the old
// `tabs`/`tab_container`/`tab_pane` trio repeated. Absorbs `tab_container`
// byte-for-byte in behaviour.

import 'package:flutter/widgets.dart';

import '../foundation/data.dart';
import '../theme/color_tokens.dart';
import 'clickable.dart';

/// A tight pressable for tab rows. Unlike `Button` it carries no minimum size
/// or padding, so strips keep their own metrics.
class TabButton extends StatelessWidget {
  /// Creates a tab button.
  const TabButton({
    super.key,
    required this.child,
    this.onPressed,
    this.enabled,
    this.selected = false,
    this.focusNode,
    this.onHover,
    this.onFocusChange,
    this.padding,
    this.shortcuts,
    this.actions,
  });

  /// Button content, usually a label.
  final Widget child;

  /// Called on tap; null disables unless [enabled] is true.
  final VoidCallback? onPressed;

  /// Enabled override; null means `onPressed != null`.
  final bool? enabled;

  /// Selected state for assistive tech.
  final bool selected;

  /// Focus node; owned internally when null.
  final FocusNode? focusNode;

  /// Called on hover/focus changes.
  final ValueChanged<bool>? onHover;

  /// Called when the focus state changes.
  final ValueChanged<bool>? onFocusChange;

  /// Padding around [child]; null means none.
  final EdgeInsetsGeometry? padding;

  /// Extra keyboard shortcuts (arrow-key maps go here).
  final Map<LogicalKeySet, Intent>? shortcuts;

  /// Actions for [shortcuts].
  final Map<Type, Action<Intent>>? actions;

  @override
  Widget build(BuildContext context) {
    final enabled = this.enabled ?? (onPressed != null);
    return Semantics(
      button: true,
      selected: selected,
      enabled: enabled,
      child: Opacity(
        opacity: enabled ? 1 : 0.5,
        child: Clickable(
          enabled: enabled,
          onPressed: enabled ? onPressed : null,
          onHover: onHover,
          onFocus: onFocusChange,
          focusNode: focusNode,
          shortcuts: shortcuts,
          actions: actions,
          mouseCursor: const StateValue<MouseCursor>(
            rest: SystemMouseCursors.click,
            disabled: SystemMouseCursors.basic,
          ),
          padding: WidgetStatePropertyAll<EdgeInsetsGeometry>(
            padding ?? EdgeInsets.zero,
          ),
          child: child,
        ),
      ),
    );
  }
}

/// Paints one folder tab: focused tabs merge into the content card through
/// the folder-tab ears; idle tabs get breathing room.
class TabShell extends StatelessWidget {
  /// Creates a tab shell.
  const TabShell({
    super.key,
    required this.focused,
    required this.background,
    required this.borderColor,
    required this.borderWidth,
    required this.radius,
    required this.child,
  });

  /// Whether this tab is focused.
  final bool focused;

  /// Card fill.
  final Color background;

  /// Border colour.
  final Color borderColor;

  /// Border width.
  final double borderWidth;

  /// Content radius shaping the folder ears.
  final BorderRadiusGeometry radius;

  /// Raw tab button.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (!focused) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: IntrinsicWidth(child: child),
      );
    }
    final resolved = radius.resolve(Directionality.of(context));
    return SizedBox(
      height: double.infinity,
      child: CustomPaint(
        painter: TabShellPainter(
          borderRadius: resolved,
          backgroundColor: background,
          borderColor: borderColor,
          borderWidth: borderWidth,
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: IntrinsicWidth(child: child),
        ),
      ),
    );
  }
}

/// Folder-tab painter behind [TabShell]: fills the focused tab and strokes
/// its open outline so it reads as one surface with the content card below.
class TabShellPainter extends CustomPainter {
  /// Creates a tab shell painter.
  TabShellPainter({
    required this.borderRadius,
    required this.backgroundColor,
    required this.borderColor,
    required this.borderWidth,
  });

  /// Content radius shaping the folder ears.
  final BorderRadius borderRadius;

  /// Fill of the focused tab.
  final Color backgroundColor;

  /// Outline colour.
  final Color borderColor;

  /// Outline width.
  final double borderWidth;

  @override
  bool shouldRepaint(covariant TabShellPainter old) =>
      old.borderRadius != borderRadius ||
      old.backgroundColor != backgroundColor ||
      old.borderColor != borderColor ||
      old.borderWidth != borderWidth;

  Path _path(Size size, bool closed) {
    final r = borderRadius;
    final path = Path()
      ..moveTo(-r.bottomLeft.x, size.height + borderWidth)
      ..quadraticBezierTo(0, size.height, 0, size.height - r.bottomLeft.y)
      ..lineTo(0, r.topLeft.y)
      ..quadraticBezierTo(0, 0, r.topLeft.x, 0)
      ..lineTo(size.width - r.topRight.x, 0)
      ..quadraticBezierTo(size.width, 0, size.width, r.topRight.y)
      ..lineTo(size.width, size.height - r.bottomRight.y)
      ..quadraticBezierTo(
        size.width,
        size.height,
        size.width + r.bottomRight.x,
        size.height + borderWidth,
      );
    if (closed) path.close();
    return path;
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPath(
      _path(size, true),
      Paint()
        ..color = backgroundColor
        ..style = PaintingStyle.fill,
    );
    canvas.drawPath(
      _path(size, false),
      Paint()
        ..color = borderColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = borderWidth,
    );
  }
}

/// Indexing context a [TabContainer] publishes to its tab children.
class TabContainerData {
  /// Creates container data.
  const TabContainerData({
    required this.index,
    required this.selected,
    required this.onSelect,
    required this.childBuilder,
  });

  /// This tab's index.
  final int index;

  /// The currently selected index.
  final int selected;

  /// Selection callback; null renders tabs disabled.
  final ValueChanged<int>? onSelect;

  /// Wrapper applied to each tab child.
  final TabChildBuilder childBuilder;

  /// Nearest ancestor data; asserts inside a tab container.
  static TabContainerData of(BuildContext context) =>
      Data.of<TabContainerData>(context);

  /// Nearest ancestor data, or null.
  static TabContainerData? maybeOf(BuildContext context) =>
      Data.maybeOf<TabContainerData>(context);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TabContainerData &&
          other.index == index &&
          other.selected == selected &&
          other.onSelect == onSelect &&
          other.childBuilder == childBuilder;

  @override
  int get hashCode => Object.hash(index, selected, onSelect, childBuilder);
}

/// Layout builder for a tab strip.
typedef TabBuilder =
    Widget Function(BuildContext context, List<Widget> children);

/// Wrapper builder applied to each tab child.
typedef TabChildBuilder =
    Widget Function(BuildContext context, TabContainerData data, Widget child);

/// Marker for widgets that can live in a [TabContainer].
mixin TabChild on Widget {
  /// Whether the container assigns this child an index.
  bool get indexed;
}

/// A [TabChild] identified by a custom key instead of its position.
mixin KeyedTabChild<T> on TabChild {
  /// The key identifying this tab.
  T get tabKey;
}

/// An indexed tab: builds through the container's `childBuilder`.
class TabItem extends StatelessWidget with TabChild {
  /// Creates a tab item.
  const TabItem({super.key, required this.child});

  /// The tab content.
  final Widget child;

  @override
  bool get indexed => true;

  @override
  Widget build(BuildContext context) {
    final TabContainerData data = TabContainerData.of(context);
    return data.childBuilder(context, data, child);
  }
}

/// A [TabItem] carrying a custom [tabKey].
class KeyedTabItem<T> extends TabItem with KeyedTabChild<T> {
  /// Creates a keyed tab item.
  KeyedTabItem({required T key, required super.child})
    : super(key: ValueKey<T>(key));

  @override
  ValueKey<T> get key => super.key! as ValueKey<T>;

  @override
  T get tabKey => key.value;
}

/// Assigns indices to [TabItem] children and lays them out.
///
/// Non-indexed children render as-is. [Tabs] and [TabPane] supply the shadcn
/// paint through `builder`/`childBuilder`.
class TabContainer extends StatelessWidget {
  /// Creates a tab container.
  ///
  /// [builder]/[childBuilder] are explicit: app-wide defaults resolve in
  /// [Tabs]/[TabPane] through `TabContainerTheme` and are forwarded here.
  const TabContainer({
    super.key,
    required this.selected,
    required this.onSelect,
    required this.children,
    this.builder,
    this.childBuilder,
  });

  /// Currently selected index.
  final int selected;

  /// Selection callback; null renders every tab disabled.
  final ValueChanged<int>? onSelect;

  /// Tab children in order.
  final List<TabChild> children;

  /// Layout override; null lays children in a column.
  final TabBuilder? builder;

  /// Per-tab wrapper override; null passes children through.
  final TabChildBuilder? childBuilder;

  @override
  Widget build(BuildContext context) {
    final TabBuilder layout =
        builder ?? (context, children) => Column(children: children);
    final TabChildBuilder wrap =
        childBuilder ?? (context, data, child) => child;
    final List<Widget> laid = <Widget>[];
    int index = 0;
    for (final TabChild child in children) {
      if (!child.indexed) {
        laid.add(child);
        continue;
      }
      // No key: the wrapper updates in place, so tab state (drag sessions,
      // focus, scroll) survives parent rebuilds. A key on the child widget
      // would remount every tab on each rebuild (widget instances differ),
      // killing active drags.
      laid.add(
        Data<TabContainerData>.inherit(
          data: TabContainerData(
            index: index,
            selected: selected,
            onSelect: onSelect,
            childBuilder: wrap,
          ),
          child: child,
        ),
      );
      index++;
    }
    return layout(context, laid);
  }
}
