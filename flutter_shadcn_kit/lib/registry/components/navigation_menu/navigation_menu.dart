// The `navigation_menu` component: adaptive path dropped, `Button` theme
// rows, Lucide icons.

import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../foundation/data.dart';
import '../../foundation/icons/lucide_icons.dart';
import '../../primitives/layout.dart';
import '../../primitives/overlay.dart';
import '../../primitives/popover_controller.dart';
import '../../primitives/text/text_extension.dart';
import '../../theme/color_tokens.dart';
import '../../theme/density.dart';
import '../../theme/theme.dart';
import '../button/button.dart';
import '../outlined_container/outlined_container.dart';
import 'navigation_menu_style.dart';

export 'navigation_menu_style.dart';

const Duration _menuDebounce = Duration(milliseconds: 200);

/// Active-item highlight row (muted fill, no label change).
const ButtonVariantStyle _activeRow = ButtonVariantStyle(
  background: StateValue(rest: ThemedColor.ref(ColorRef.muted, alpha: 0.8)),
);

/// Horizontal bar of entries with dropdown content.
class NavigationMenu extends StatefulWidget {
  const NavigationMenu({
    super.key,
    this.surfaceOpacity,
    this.surfaceBlur,
    required this.children,
    this.theme,
  });

  final double? surfaceOpacity;
  final double? surfaceBlur;
  final List<Widget> children;

  /// Widget-leg theme override, merged over the other legs.
  final NavigationMenuTheme? theme;

  @override
  State<NavigationMenu> createState() => NavigationMenuState();
}

/// State of [NavigationMenu]; items reach it for activation and closing.
class NavigationMenuState extends State<NavigationMenu> {
  final PopoverController _popovers = PopoverController();
  final ValueNotifier<int> _version = ValueNotifier<int>(0);
  final Map<NavigationMenuItemState, WidgetBuilder> _content = {};
  NavigationMenuItemState? _activeItem;
  int _hoverCount = 0;

  NavigationMenuTheme _resolve(BuildContext context) =>
      resolveComponentStyle<NavigationMenuTheme, NavigationMenuTheme>(
        context,
        widget: widget.theme,
        select: (t) => t,
        defaults: navigationMenuDefaults,
      );

  static void exitGrace(NavigationMenuState menu) {
    final int seen = ++menu._hoverCount;
    Future<void>.delayed(_menuDebounce, () {
      if (seen == menu._hoverCount && menu.mounted) menu.close();
    });
  }

  bool isActive(NavigationMenuItemState item) {
    return _popovers.hasOpenPopover && identical(_activeItem, item);
  }

  /// Opens [item]'s content (or closes when it has none).
  void openItem(NavigationMenuItemState item) {
    if (item.widget.content == null) {
      close();
      return;
    }
    _activeItem = item;
    _version.value++;
    _show(item.context);
  }

  void close() {
    _activeItem = null;
    _version.value++;
    _popovers.close();
  }

  void _show(BuildContext context) {
    final ShadcnThemeData ambient = ShadcnTheme.of(context);
    final NavigationMenuTheme style = _resolve(context);
    final double scale = ambient.scaling;
    if (_popovers.hasOpenPopover) {
      _popovers.anchorContext = context;
      return;
    }
    _popovers.show<void>(
      context: context,
      alignment: Alignment.topCenter,
      regionGroupId: this,
      offset: style.offset ?? Offset(0, ambient.density.baseGap * scale * 0.5),
      modal: false,
      margin: style.margin ?? EdgeInsets.all(ambient.density.baseGap * scale),
      allowInvertHorizontal: false,
      allowInvertVertical: true,
      builder: (context) => _MenuPopover(menu: this, style: style),
    );
  }

  @override
  void dispose() {
    _version.dispose();
    _popovers.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      hitTestBehavior: HitTestBehavior.translucent,
      onEnter: (_) => _hoverCount++,
      onExit: (_) => NavigationMenuState.exitGrace(this),
      child: IntrinsicHeight(
        child: Data<NavigationMenuState>.inherit(
          data: this,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: widget.children,
          ),
        ),
      ),
    );
  }
}

/// Popover surface of an open entry.
class _MenuPopover extends StatelessWidget {
  const _MenuPopover({required this.menu, required this.style});

  final NavigationMenuState menu;
  final NavigationMenuTheme style;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData ambient = ShadcnTheme.of(context);
    final double opacity =
        menu.widget.surfaceOpacity ??
        style.surfaceOpacity ??
        ambient.surfaceOpacity ??
        1;
    final double blur =
        menu.widget.surfaceBlur ??
        style.surfaceBlur ??
        ambient.surfaceBlur ??
        0;
    return MouseRegion(
      hitTestBehavior: HitTestBehavior.translucent,
      onEnter: (_) => menu._hoverCount++,
      onExit: (_) => NavigationMenuState.exitGrace(menu),
      child: Shortcuts(
        shortcuts: const <ShortcutActivator, Intent>{
          SingleActivator(LogicalKeyboardKey.escape): DismissIntent(),
        },
        child: Actions(
          actions: <Type, Action<Intent>>{
            DismissIntent: CallbackAction<DismissIntent>(
              onInvoke: (_) {
                menu.close();
                return null;
              },
            ),
          },
          child: OutlinedContainer(
            surfaceOpacity: opacity,
            surfaceBlur: blur,
            padding: resolveEdgeInsets(
              style.padding ?? EdgeInsets.zero,
              ambient.density.baseContentPadding * ambient.scaling,
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: style.maxWidth ?? double.infinity,
              ),
              child: AnimatedBuilder(
                animation: menu._version,
                builder: (context, _) {
                  final NavigationMenuItemState? item = menu._activeItem;
                  final WidgetBuilder? content = item == null
                      ? null
                      : menu._content[item];
                  // Block the outer menu scope inside popover content.
                  return Data<NavigationMenuState>.boundary(
                    child: content?.call(context) ?? const SizedBox.shrink(),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// One menu entry: action button, content trigger, or both.
class NavigationMenuItem extends StatefulWidget {
  const NavigationMenuItem({
    super.key,
    this.onPressed,
    this.content,
    required this.child,
  });

  final VoidCallback? onPressed;

  final Widget? content;
  final Widget child;

  @override
  State<NavigationMenuItem> createState() => NavigationMenuItemState();
}

class NavigationMenuItemState extends State<NavigationMenuItem> {
  NavigationMenuState? _menu;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _menu?._content.remove(this);
    _menu = Data.maybeOf<NavigationMenuState>(context);
    assert(
      _menu != null,
      'NavigationMenuItem must descend from NavigationMenu',
    );
    if (widget.content != null) {
      _menu!._content[this] = (context) => widget.content!;
    }
  }

  @override
  void didUpdateWidget(covariant NavigationMenuItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.content != oldWidget.content && _menu != null) {
      if (widget.content != null) {
        _menu!._content[this] = (context) => widget.content!;
      } else {
        _menu!._content.remove(this);
      }
    }
  }

  @override
  void dispose() {
    if (_menu != null && widget.content != null) _menu!._content.remove(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final NavigationMenuState menu = _menu!;
    return AnimatedBuilder(
      animation: Listenable.merge(<Listenable>[menu._version, menu._popovers]),
      builder: (context, _) {
        final bool active = menu.isActive(this);
        // MouseRegion, not Button.onHover: the Clickable hover callback is
        // strategy-gated and never fires in widget tests.
        return MouseRegion(
          hitTestBehavior: HitTestBehavior.translucent,
          onEnter: (_) => menu.openItem(this),
          child: Button(
            variant: ButtonVariant.ghost,
            theme: active ? _activeRow : null,
            trailing: widget.content != null
                ? AnimatedRotation(
                    duration: const Duration(milliseconds: 150),
                    turns: active ? 0.5 : 0,
                    child: const Icon(LucideIcons.chevronDown, size: 12),
                  )
                : null,
            onPressed: widget.onPressed != null || widget.content != null
                ? () {
                    widget.onPressed?.call();
                    if (widget.content != null) menu.openItem(this);
                  }
                : null,
            child: widget.child,
          ),
        );
      },
    );
  }
}

class NavigationMenuContent extends StatelessWidget {
  const NavigationMenuContent({
    super.key,
    required this.title,
    this.content,
    this.leading,
    this.trailing,
    this.onPressed,
  });

  final Widget title;
  final Widget? content;
  final Widget? leading;
  final Widget? trailing;

  /// Action on press (closes the menu first).
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Button(
      variant: ButtonVariant.ghost,
      onPressed: onPressed == null
          ? null
          : () {
              closeOverlay(context);
              onPressed!();
            },
      leading: leading,
      trailing: trailing,
      child: Basic(
        title: title.medium(),
        content: content?.muted(),
        mainAxisAlignment: MainAxisAlignment.start,
      ),
    );
  }
}

/// Grid of content entries; rows share equal-width columns.
class NavigationMenuContentList extends StatelessWidget {
  const NavigationMenuContentList({
    super.key,
    required this.children,
    this.crossAxisCount = 3,
    this.spacing,
    this.runSpacing,
    this.reverse = false,
  });

  final List<Widget> children;
  final int crossAxisCount;
  final double? spacing;
  final double? runSpacing;

  /// Whether to reverse the order (for RTL).
  final bool reverse;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData ambient = ShadcnTheme.of(context);
    final double scale = ambient.scaling;
    final double gap = spacing ?? ambient.density.baseGap * scale;
    final double rowGap = runSpacing ?? 12 * scale;
    final List<Widget> ordered = reverse
        ? children.reversed.toList()
        : children;
    final List<Widget> rows = <Widget>[];
    for (int i = 0; i < ordered.length; i += crossAxisCount) {
      final List<Widget> cells = ordered
          .skip(i)
          .take(crossAxisCount)
          .map((Widget cell) => Expanded(child: cell))
          .toList();
      rows.add(
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _spaced(cells, SizedBox(width: gap)),
        ),
      );
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: _spaced(rows, SizedBox(height: rowGap)),
    );
  }

  static List<Widget> _spaced(List<Widget> widgets, Widget separator) {
    final List<Widget> out = <Widget>[];
    for (int i = 0; i < widgets.length; i++) {
      if (i > 0) out.add(separator);
      out.add(widgets[i]);
    }
    return out;
  }
}
