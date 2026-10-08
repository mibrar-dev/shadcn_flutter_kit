// The edge-panel modal route and its private shell. The route extends the
// widgets [ModalRoute]; the shell paints the panel, drag handle, slide
// transition and focus/escape handling. The component supplies the live theme
// through [ShadcnDrawerRoute.themeOf].

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../foundation/captured_wrapper.dart';
import '../../foundation/data.dart';
import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';
import '../localizations/localizations.dart';
import '../sheet_overlay.dart';
import 'drawer_route.dart';

const Color kDrawerFallbackBarrierColor = Color(0x80000000);

BorderRadius _innerRadius(BorderRadius radius, OverlayPosition position) {
  return switch (position) {
    OverlayPosition.left => BorderRadius.only(
      topRight: radius.topRight,
      bottomRight: radius.bottomRight,
    ),
    OverlayPosition.right => BorderRadius.only(
      topLeft: radius.topLeft,
      bottomLeft: radius.bottomLeft,
    ),
    OverlayPosition.top => BorderRadius.only(
      bottomLeft: radius.bottomLeft,
      bottomRight: radius.bottomRight,
    ),
    OverlayPosition.bottom => BorderRadius.only(
      topLeft: radius.topLeft,
      topRight: radius.topRight,
    ),
    OverlayPosition.start || OverlayPosition.end => radius,
  };
}

BoxBorder _innerBorder(Color color, double width, OverlayPosition position) {
  final BorderSide side = BorderSide(color: color, width: width);
  return Border(
    left: position == OverlayPosition.left ? side : BorderSide.none,
    right: position == OverlayPosition.right ? side : BorderSide.none,
    top: position == OverlayPosition.top ? side : BorderSide.none,
    bottom: position == OverlayPosition.bottom ? side : BorderSide.none,
  );
}

class ShadcnDrawerRoute<T> extends ModalRoute<T> {
  ShadcnDrawerRoute({
    required this.builder,
    required this.position,
    required this.themeOf,
    required this.duration,
    required this.barrierDismissible,
    required this.useSafeArea,
    required this.expands,
    required this.draggable,
    required this.showDragHandle,
    required this.isSheet,
    required this.openerFocus,
    this.borderRadius,
    this.maxSize,
    this.barrierLabel,
    this.themes,
    this.data,
    super.settings,
    super.traversalEdgeBehavior,
  });

  final WidgetBuilder builder;

  final OverlayPosition position;

  final DrawerRouteTheme Function(BuildContext context) themeOf;

  final Duration duration;

  /// Whether the barrier tap / Escape pops the panel.
  @override
  final bool barrierDismissible;

  /// Semantic label of the dismissible barrier.
  @override
  final String? barrierLabel;

  final bool useSafeArea;
  final bool expands;
  final bool draggable;
  final bool showDragHandle;
  final bool isSheet;
  final FocusNode? openerFocus;
  final BorderRadius? borderRadius;
  final double? maxSize;
  final CapturedThemes? themes;
  final CapturedData? data;

  @override
  Color? get barrierColor => null;

  @override
  bool get opaque => false;

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => duration;

  @override
  Duration get reverseTransitionDuration => duration;

  AnimationController? get dragController => controller;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return _wrapPanel(_DrawerShell(this), themes, data);
  }

  @override
  Widget buildModalBarrier() {
    return _wrapPanel(
      Builder(
        builder: (BuildContext context) {
          final DrawerRouteTheme style = themeOf(context);
          final ShadcnColors colors = ShadcnTheme.of(context).colors;
          final Color color =
              style.barrierColor?.resolve(colors) ??
              kDrawerFallbackBarrierColor;
          return ModalBarrier(
            dismissible: barrierDismissible,
            color: color,
            semanticsLabel:
                barrierLabel ?? ShadcnLocalizations.of(context).dialogDismiss,
            barrierSemanticsDismissible: true,
          );
        },
      ),
      themes,
      data,
    );
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final OverlayPosition resolved = position.resolve(
      Directionality.of(context),
    );
    final Animation<Offset> slide = Tween<Offset>(
      begin: resolved.slideOffset,
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic));
    return SlideTransition(position: slide, child: child);
  }
}

Widget _wrapPanel(Widget child, CapturedThemes? themes, CapturedData? data) {
  if (themes != null) child = themes.wrap(child);
  if (data != null) child = data.wrap(child);
  return child;
}

class _DrawerShell extends StatefulWidget {
  const _DrawerShell(this.route);

  final ShadcnDrawerRoute<dynamic> route;

  @override
  State<_DrawerShell> createState() => _DrawerShellState();
}

class _DrawerShellState extends State<_DrawerShell> {
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
    final ShadcnThemeData ambient = ShadcnTheme.of(context);
    final DrawerRouteTheme style = route.themeOf(context);
    final ShadcnColors colors = ambient.colors;
    final OverlayPosition position = route.position.resolve(
      Directionality.of(context),
    );
    final bool horizontal = position.isHorizontal;

    Widget content = Padding(
      padding: style.padding ?? EdgeInsets.zero,
      child: Builder(builder: route.builder),
    );
    if (route.showDragHandle) {
      final Size handleSize = style.dragHandleSize ?? const Size(36, 4);
      final Color handleColor =
          (style.dragHandleColor ?? ThemedColor.ref(ColorRef.muted)).resolve(
            colors,
          );
      content = Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Center(
            child: Container(
              width: handleSize.width,
              height: handleSize.height,
              decoration: BoxDecoration(
                color: handleColor,
                borderRadius: BorderRadius.circular(handleSize.height / 2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(child: content),
        ],
      );
    }

    final BorderRadius baseRadius =
        route.borderRadius ?? style.borderRadius ?? ambient.borderRadiusLg;
    final Color? borderColor = style.borderColor?.resolve(colors);
    final double borderWidth = style.borderWidth ?? 0;
    final List<BoxShadow> shadows =
        style.shadows ??
        (style.themeShadows ?? ambient.tokens.shadows).shadowLg;
    final double maxSize = route.maxSize ?? style.maxSize ?? 320;

    Widget panel = DecoratedBox(
      decoration: BoxDecoration(
        color: style.background?.resolve(colors),
        borderRadius: _innerRadius(baseRadius, position),
        border: borderColor == null || borderWidth <= 0
            ? null
            : _innerBorder(borderColor, borderWidth, position),
        boxShadow: shadows.isEmpty ? null : shadows,
      ),
      child: content,
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
    panel = Align(alignment: position.alignment, child: panel);
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
