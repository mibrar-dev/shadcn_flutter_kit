// The edge-panel shell: sizes the panel, applies the slide transform and
// handles the drag-to-dismiss, safe area, focus and Escape. The painted chrome
// lives in `drawer_panel_surface.dart`, shared with the in-tree `swiper`.

import 'dart:math' as math;

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../foundation/data.dart';
import '../sheet_overlay.dart';
import 'drawer_panel.dart';
import 'drawer_panel_surface.dart';
import 'drawer_route.dart';

/// The panel shell of a [ShadcnDrawerRoute]; built by the route's page.
class DrawerRouteShell extends StatefulWidget {
  /// Creates the shell for [route].
  const DrawerRouteShell(this.route, {super.key});

  /// The route whose values drive this shell.
  final ShadcnDrawerRoute<dynamic> route;

  @override
  State<DrawerRouteShell> createState() => _DrawerRouteShellState();
}

class _DrawerRouteShellState extends State<DrawerRouteShell> {
  final GlobalKey _panelKey = GlobalKey();
  final FocusScopeNode _focusNode = FocusScopeNode(debugLabel: 'ShadcnDrawer');

  ShadcnDrawerRoute<dynamic> get route => widget.route;

  @override
  void dispose() {
    _focusNode.dispose();
    final FocusNode? opener = route.openerFocus;
    if (opener != null && opener.canRequestFocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (opener.context != null && opener.canRequestFocus) {
          opener.requestFocus();
        }
      });
    }
    super.dispose();
  }

  double _extent(bool horizontal) {
    final Size? size = _panelKey.currentContext?.size;
    if (size == null) {
      return 1;
    }
    final double value = horizontal ? size.width : size.height;
    return value <= 0 ? 1 : value;
  }

  void _onDragUpdate(OverlayPosition position, DragUpdateDetails details) {
    final AnimationController? controller = route.dragController;
    if (controller == null) {
      return;
    }
    final double extent = _extent(position.isHorizontal);
    final double next =
        controller.value +
        position.dismissDragSign * (details.primaryDelta ?? 0) / extent;
    controller.value = next.clamp(0.0, 1.0);
  }

  void _onDragEnd(DragEndDetails details) {
    final AnimationController? controller = route.dragController;
    if (controller == null) {
      return;
    }
    if (controller.value < 0.5) {
      controller.animateBack(0.0, curve: Curves.easeOut).whenComplete(() {
        if (mounted) {
          Navigator.of(context).maybePop();
        }
      });
    } else {
      controller.animateTo(1.0, curve: Curves.easeOut);
    }
  }

  void _dismiss() {
    if (!route.barrierDismissible) {
      return;
    }
    final NavigatorState navigator = Navigator.of(context);
    if (navigator.canPop()) {
      navigator.pop();
    }
  }

  KeyEventResult _onKeyEvent(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }
    if (event.logicalKey != LogicalKeyboardKey.tab) {
      return KeyEventResult.ignored;
    }
    final List<FocusNode> targets = _focusNode.traversalDescendants.toList();
    if (targets.isEmpty) {
      return KeyEventResult.ignored;
    }
    final FocusNode? current = FocusManager.instance.primaryFocus;
    final int index = current == null ? -1 : targets.indexOf(current);
    final bool backwards = HardwareKeyboard.instance.isShiftPressed;
    final int next = index < 0
        ? (backwards ? targets.length - 1 : 0)
        : (index + (backwards ? -1 : 1)) % targets.length;
    if (next != index) {
      targets[next].requestFocus();
    }
    return KeyEventResult.handled;
  }

  @override
  Widget build(BuildContext context) {
    final DrawerRouteTheme style = route.themeOf(context);
    final OverlayPosition position = route.position.resolve(
      Directionality.of(context),
    );
    final bool horizontal = position.isHorizontal;
    final double maxSize = route.maxSize ?? style.maxSize ?? 320;

    Widget panel = DrawerPanelSurface(
      position: position,
      theme: style,
      showDragHandle: route.showDragHandle,
      borderRadius: route.borderRadius,
      child: Builder(builder: route.builder),
    );
    panel = SizedBox(
      key: _panelKey,
      width: horizontal
          ? (route.expands ? double.infinity : maxSize)
          : double.infinity,
      height: horizontal
          ? double.infinity
          : (route.expands ? double.infinity : maxSize),
      child: panel,
    );
    if (route.draggable) {
      panel = GestureDetector(
        behavior: HitTestBehavior.opaque,
        onHorizontalDragUpdate: horizontal
            ? (DragUpdateDetails details) => _onDragUpdate(position, details)
            : null,
        onHorizontalDragEnd: horizontal ? _onDragEnd : null,
        onVerticalDragUpdate: horizontal
            ? null
            : (DragUpdateDetails details) => _onDragUpdate(position, details),
        onVerticalDragEnd: horizontal ? null : _onDragEnd,
        child: panel,
      );
    }
    final Size screen = MediaQuery.sizeOf(context);
    final double routeExtent = horizontal ? screen.width : screen.height;
    final double panelExtent = route.expands
        ? routeExtent
        : math.min(maxSize, routeExtent);
    final Animation<double> anim =
        route.animation ?? const AlwaysStoppedAnimation<double>(1);
    panel = Align(alignment: position.alignment, child: panel);
    panel = AnimatedBuilder(
      animation: anim,
      child: panel,
      builder: (BuildContext context, Widget? child) => Transform.translate(
        offset: horizontal
            ? Offset(
                position.slideOffset.dx * panelExtent * (1 - anim.value),
                0,
              )
            : Offset(
                0,
                position.slideOffset.dy * panelExtent * (1 - anim.value),
              ),
        child: child,
      ),
    );
    if (route.useSafeArea) {
      panel = SafeArea(
        top: position != OverlayPosition.top,
        bottom: position != OverlayPosition.bottom,
        left: position != OverlayPosition.left,
        right: position != OverlayPosition.right,
        child: panel,
      );
    }
    panel = FocusScope(
      node: _focusNode,
      autofocus: true,
      onKeyEvent: _onKeyEvent,
      child: panel,
    );
    panel = Shortcuts(
      shortcuts: const <ShortcutActivator, Intent>{
        SingleActivator(LogicalKeyboardKey.escape): DismissIntent(),
      },
      child: Actions(
        actions: <Type, Action<Intent>>{
          DismissIntent: CallbackAction<DismissIntent>(
            onInvoke: (DismissIntent intent) {
              _dismiss();
              return null;
            },
          ),
        },
        child: panel,
      ),
    );

    Widget result = DrawerPanelScope(position: position, child: panel);
    if (route.isSheet) {
      result = Data<SheetOverlayMarker>.inherit(
        data: const SheetOverlayMarker(),
        child: result,
      );
    }
    return result;
  }
}
