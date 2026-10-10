// The painted chrome of a drawer/sheet panel: fill, inner-edge border, rounded
// outer corners and an optional drag handle. Shared by the route shell
// (`drawer_shell.dart`) and the in-tree `swiper`, so both look identical and a
// `DrawerTheme` override applies to either.

import 'package:flutter/widgets.dart';

import '../../theme/color_tokens.dart';
import '../../theme/density.dart';
import '../../theme/theme.dart';
import 'drawer_route.dart';

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

/// Paints a drawer/sheet panel around [child] from [theme].
class DrawerPanelSurface extends StatelessWidget {
  /// Creates a panel surface.
  const DrawerPanelSurface({
    super.key,
    required this.position,
    required this.theme,
    required this.child,
    this.showDragHandle = true,
    this.borderRadius,
  });

  /// Physical edge the panel is anchored to.
  final OverlayPosition position;

  /// Resolved panel style (`DrawerTheme` implements [DrawerRouteTheme]).
  final DrawerRouteTheme theme;

  /// Panel content.
  final Widget child;

  /// Whether the drag handle is drawn.
  final bool showDragHandle;

  /// Widget-leg radius override; null falls back to [theme].
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData ambient = ShadcnTheme.of(context);
    final ShadcnColors colors = ambient.colors;

    // The drawer/sheet panel is a container: `theme.padding` defaults to a
    // density-multiplier value (see `drawerDefaultPadding`), so it is resolved
    // here, where it is painted. A plain `EdgeInsets` override (the shared
    // `swiper` chrome passes one) resolves unchanged.
    Widget content = Padding(
      padding: resolveEdgeInsets(
        theme.padding ?? EdgeInsets.zero,
        ambient.density.baseContentPadding * ambient.scaling,
      ),
      child: child,
    );
    if (showDragHandle) {
      final Size handleSize = theme.dragHandleSize ?? const Size(36, 4);
      final Color handleColor =
          (theme.dragHandleColor ?? ThemedColor.ref(ColorRef.muted)).resolve(
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

    final BorderRadius radius =
        borderRadius ?? theme.borderRadius ?? ambient.borderRadiusLg;
    final Color? borderColor = theme.borderColor?.resolve(colors);
    final double borderWidth = theme.borderWidth ?? 0;
    final List<BoxShadow> shadows =
        theme.shadows ??
        (theme.themeShadows ?? ambient.tokens.shadows).shadowLg;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.background?.resolve(colors),
        borderRadius: _innerRadius(radius, position),
        border: borderColor == null || borderWidth <= 0
            ? null
            : _innerBorder(borderColor, borderWidth, position),
        boxShadow: shadows.isEmpty ? null : shadows,
      ),
      child: content,
    );
  }
}
