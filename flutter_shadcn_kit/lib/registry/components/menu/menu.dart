// The `menu` component: rows, submenus, [showShadcnMenu] and [MenuPopup];
// traversal and row surfaces live in primitives, rows resolve legs here.

import 'package:flutter/widgets.dart';
import '../../foundation/data.dart';
import '../../foundation/icons/lucide_icons.dart';
import '../../primitives/menu_nav.dart';
import '../../primitives/menu_rows.dart';
import '../../primitives/popover_controller.dart';
import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';
import 'menu_style.dart';

export '../../primitives/menu_nav.dart';
export '../../primitives/menu_rows.dart';
export 'menu_style.dart';

/// Press handler receiving the item's context.
typedef MenuPressedCallback = void Function(BuildContext context);

/// Value-change handler receiving the item's context and the next value.
typedef MenuChangedCallback<T> = void Function(BuildContext context, T value);

/// One row inside a [MenuGroup].
abstract class MenuItem extends Widget {
  const MenuItem({super.key});
  bool get hasLeading;
  bool get enabled;
}

/// Resolves [MenuTheme] through widget > tree > app > defaults.
MenuTheme _menuThemeOf(BuildContext context, MenuTheme? widget) =>
    resolveComponentStyle<MenuTheme, MenuTheme>(
      context,
      widget: widget,
      select: (t) => t,
      defaults: menuDefaults,
    );

/// A keyboard-navigable list of rows over [RovingGroup] (headers and
/// separators render without taking focus).
class MenuGroup extends RovingGroup {
  MenuGroup({
    super.key,
    required super.children,
    super.builder = columnMenuBuilder,
    super.parent,
    super.direction,
    super.itemPadding = EdgeInsets.zero,
    super.subMenuOffset,
    super.onDismissed,
    super.autofocus,
  }) : super(hasLeading: children.any((c) => c is MenuItem && c.hasLeading));
}

/// An actionable menu row, optionally owning a submenu; hover focuses and
/// opens it, press activates [onPressed] and (with [autoClose]) dismisses.
class MenuButton extends StatefulWidget implements MenuItem {
  const MenuButton({
    super.key,
    required this.child,
    this.subMenu,
    this.onPressed,
    this.trailing,
    this.leading,
    this.enabled = true,
    this.focusNode,
    this.autoClose = true,
    this.theme,
  });
  final Widget child;
  final List<Widget>? subMenu;
  final MenuPressedCallback? onPressed;
  final Widget? trailing;
  final Widget? leading;
  @override
  final bool enabled;
  final FocusNode? focusNode;
  final bool autoClose;
  final MenuTheme? theme;
  @override
  bool get hasLeading => leading != null;
  @override
  State<MenuButton> createState() => _MenuButtonState();
}

class _MenuButtonState extends State<MenuButton> {
  final PopoverController _controller = PopoverController();
  bool get _hasSub => widget.subMenu?.isNotEmpty ?? false;
  void _open({required bool autofocus}) {
    final MenuGroupData? group = Data.maybeFind<MenuGroupData>(context);
    assert(group != null, 'MenuButton must be a child of MenuGroup');
    if (group == null) return;
    group.closeOthers();
    showMenuPopover<void>(
      context: context,
      controller: _controller,
      offset:
          group.subMenuOffset ??
          _menuThemeOf(context, widget.theme).subMenuOffset,
      popupBuilder: (context) => MenuPopup(
        children: <Widget>[
          MenuGroup(
            parent: group,
            direction: group.direction,
            autofocus: autofocus,
            children: widget.subMenu!,
          ),
        ],
      ),
    );
  }

  void _press() {
    widget.onPressed?.call(context);
    if (_hasSub) {
      if (!_controller.hasOpenPopover) _open(autofocus: false);
    } else if (widget.autoClose) {
      Data.maybeFind<MenuGroupData>(context)?.closeAll();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final MenuGroupData? group = Data.maybeOf<MenuGroupData>(context);
    assert(group != null, 'MenuButton must be a child of MenuGroup');
    final bool reserve = (group?.hasLeading ?? false) && widget.leading == null;
    return _plainRow(
      context,
      theme: widget.theme,
      enabled: widget.enabled,
      focusNode: widget.focusNode,
      onPressed: _press,
      autoClose: false,
      onHover: !widget.enabled
          ? null
          : (hovered) {
              if (!hovered) return;
              if (_hasSub) {
                if (!_controller.hasOpenPopover) _open(autofocus: false);
              } else {
                group?.closeOthers();
              }
            },
      onOpen: _hasSub ? () => _open(autofocus: true) : null,
      onClose: _hasSub ? _controller.close : null,
      isOpen: _hasSub ? () => _controller.hasOpenPopover : null,
      leading: widget.leading,
      reserveLeading: reserve,
      trailing: widget.trailing,
      showChevron: _hasSub && widget.trailing == null,
      child: widget.child,
    );
  }
}

/// Resolved plain row shared by [MenuCheckboxItem] and [MenuRadioItem].
RovingRow _plainRow(
  BuildContext context, {
  MenuTheme? theme,
  required bool enabled,
  required VoidCallback onPressed,
  required Widget? leading,
  required Widget child,
  Widget? trailing,
  bool autoClose = true,
  FocusNode? focusNode,
  ValueChanged<bool>? onHover,
  VoidCallback? onOpen,
  VoidCallback? onClose,
  bool Function()? isOpen,
  bool showChevron = false,
  bool reserveLeading = false,
}) {
  final MenuGroupData? group = Data.maybeOf<MenuGroupData>(context);
  final ShadcnThemeData app = ShadcnTheme.of(context);
  final MenuTheme style = _menuThemeOf(context, theme);
  Color? resolvedColor(
    StateValue<ThemedColor>? value,
    Set<WidgetState> states,
  ) => value?.resolve(states)?.resolve(app.colors);
  // Hover/focus paint uses the theme's hovered row; disabled rows keep the
  // rest colours and dim through the row's opacity.
  const Set<WidgetState> hovered = <WidgetState>{WidgetState.hovered};
  return RovingRow(
    enabled: enabled,
    focusNode: focusNode,
    onPressed: () {
      onPressed();
      if (autoClose) group?.closeAll();
    },
    onHover: onHover,
    fill: resolvedColor(style.background, const <WidgetState>{}),
    highlightFill: resolvedColor(style.background, hovered),
    foreground: resolvedColor(style.foreground, const <WidgetState>{}),
    highlightForeground: resolvedColor(style.foreground, hovered),
    radius: (style.borderRadius ?? app.borderRadiusSm).resolve(
      Directionality.of(context),
    ),
    padding:
        (style.itemPadding ??
                const EdgeInsets.symmetric(horizontal: 8, vertical: 6))
            .add(group?.itemPadding ?? EdgeInsets.zero),
    textStyle: style.textStyle,
    onOpen: onOpen,
    onClose: onClose,
    isOpen: isOpen,
    leading: leading,
    reserveLeading: reserveLeading,
    trailing: trailing,
    showChevron: showChevron,
    child: child,
  );
}

/// Shared selection of a [MenuRadioItem] set, provided to the subtree.
class MenuRadioGroup<T> extends StatelessWidget {
  const MenuRadioGroup({
    super.key,
    required this.value,
    required this.onChanged,
    required this.child,
  });
  final T? value;
  final MenuChangedCallback<T>? onChanged;
  final Widget child;
  @override
  Widget build(BuildContext context) =>
      Data<MenuRadioGroup<T>>.inherit(data: this, child: child);
}

/// A checkable row: toggles on press and on Enter/Space; stays open.
class MenuCheckboxItem extends StatelessWidget implements MenuItem {
  const MenuCheckboxItem({
    super.key,
    required this.child,
    required this.value,
    required this.onChanged,
    this.trailing,
    this.enabled = true,
    this.autoClose = false,
    this.theme,
  });
  final Widget child;
  final bool value;
  final MenuChangedCallback<bool>? onChanged;
  final Widget? trailing;
  @override
  final bool enabled;
  final bool autoClose;
  final MenuTheme? theme;
  @override
  bool get hasLeading => true;
  @override
  Widget build(BuildContext context) {
    return _plainRow(
      context,
      theme: theme,
      enabled: enabled,
      onPressed: () => onChanged?.call(context, !value),
      leading: value
          ? const Icon(LucideIcons.check, size: 16)
          : const SizedBox(width: 16, height: 16),
      trailing: trailing,
      autoClose: autoClose,
      child: child,
    );
  }
}

/// A radio row: exactly one per group is selected on press/Enter/Space.
class MenuRadioItem<T> extends StatelessWidget implements MenuItem {
  const MenuRadioItem({
    super.key,
    required this.value,
    required this.child,
    this.trailing,
    this.enabled = true,
    this.autoClose = true,
    this.theme,
  });
  final T value;
  final Widget child;
  final Widget? trailing;
  @override
  final bool enabled;
  final bool autoClose;
  final MenuTheme? theme;
  @override
  bool get hasLeading => true;
  @override
  Widget build(BuildContext context) {
    final MenuRadioGroup<T>? group = Data.maybeOf<MenuRadioGroup<T>>(context);
    assert(group != null, 'MenuRadioItem must be a child of MenuRadioGroup');
    return _plainRow(
      context,
      theme: theme,
      enabled: enabled,
      onPressed: () => group?.onChanged?.call(context, value),
      leading: group?.value == value
          ? const Icon(LucideIcons.dot, size: 16)
          : const SizedBox(width: 16, height: 16),
      trailing: trailing,
      autoClose: autoClose,
      child: child,
    );
  }
}

/// A submenu: [trigger] opens [children] on hover or ArrowRight, ArrowLeft
/// closes; traversal and theming match [MenuButton].
class MenuSub extends StatelessWidget implements MenuItem {
  const MenuSub({
    super.key,
    required this.trigger,
    required this.children,
    this.enabled = true,
    this.theme,
  });
  final Widget trigger;
  final List<Widget> children;
  @override
  final bool enabled;
  final MenuTheme? theme;
  @override
  bool get hasLeading => false;
  @override
  Widget build(BuildContext context) => MenuButton(
    enabled: enabled,
    theme: theme,
    subMenu: children,
    child: trigger,
  );
}

/// The themed popup surface rows are presented on. B20 re-exports this.
class MenuPopup extends StatelessWidget {
  const MenuPopup({super.key, required this.children, this.theme});
  final List<Widget> children;
  final MenuPopupTheme? theme;
  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData app = ShadcnTheme.of(context);
    final MenuPopupTheme style =
        resolveComponentStyle<MenuPopupTheme, MenuPopupTheme>(
          context,
          widget: theme,
          select: (t) => t,
          defaults: menuPopupDefaults,
        );
    return MenuPopupSurface(
      fill: style.background?.resolve(app.colors),
      foreground: style.foreground?.resolve(app.colors),
      borderColor: style.borderColor?.resolve(app.colors),
      borderWidth: style.borderWidth ?? 1,
      borderRadius: (style.borderRadius ?? app.borderRadiusMd).resolve(
        Directionality.of(context),
      ),
      padding: style.padding,
      minWidth: style.minWidth ?? 192,
      children: children,
    );
  }
}

/// Shows [children] as a root menu popover; Escape closes the root group.
Future<T?> showShadcnMenu<T>({
  required BuildContext context,
  required List<Widget> children,
  AlignmentGeometry alignment = Alignment.topLeft,
  AlignmentGeometry anchorAlignment = Alignment.bottomLeft,
  Offset offset = const Offset(0, 4),
  MenuTheme theme = const MenuTheme(),
  MenuPopupTheme? popupTheme,
}) {
  final PopoverController controller = PopoverController();
  return showMenuPopover<T>(
    context: context,
    controller: controller,
    offset: offset,
    alignment: alignment,
    anchorAlignment: anchorAlignment,
    popupBuilder: (context) => MenuPopup(
      theme: popupTheme,
      children: <Widget>[
        ComponentTheme<MenuTheme>(
          data: theme,
          child: MenuGroup(onDismissed: controller.close, children: children),
        ),
      ],
    ),
  );
}
