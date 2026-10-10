// Shared row/submenu machinery for the menu family (round 2): resolved
// values in, painted rows out. Wave-D consumers reuse rows and levels.

import 'dart:math' as math;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import '../theme/theme.dart';
import 'overlay.dart';
import 'popover_controller.dart';

export 'roving_row.dart';

/// The popup surface rows are presented on, from resolved values.
///
/// The surface never issues intrinsic queries: an earlier revision wrapped
/// the rows in an `IntrinsicWidth`, and any `LayoutBuilder` descendant (the
/// registry `Slider`, for example) throws "LayoutBuilder does not support
/// returning intrinsic dimensions" while `RenderIntrinsicWidth` measures it
/// during layout — one root error cascading into a "was not laid out" error
/// per ancestor. Width is deterministic instead (`width`, else up to
/// [maxWidth] and at least [minWidth]), so arbitrary content is safe.
/// Height is capped at [maxHeight] with its own scroll area, so long lists
/// stay on-screen.
class MenuPopupSurface extends StatelessWidget {
  /// Creates a menu popup surface.
  const MenuPopupSurface({
    super.key,
    required this.children,
    this.fill,
    this.foreground,
    this.borderColor,
    this.borderWidth = 1,
    this.borderRadius,
    this.padding,
    this.minWidth = 192,
    this.width,
    this.maxWidth = 288,
    this.maxHeight = 360,
  });

  /// The rows.
  final List<Widget> children;

  /// Resolved surface fill; null resolves the popover token.
  final Color? fill;

  /// Resolved content colour; null resolves popoverForeground.
  final Color? foreground;

  /// Resolved border colour; null resolves the border token.
  final Color? borderColor;

  /// Border width.
  final double borderWidth;

  /// Resolved corner radius; null resolves `borderRadiusMd`.
  final BorderRadius? borderRadius;

  /// Resolved inner padding; null resolves all 4.
  final EdgeInsetsGeometry? padding;

  /// Minimum popup width (12rem).
  final double minWidth;

  /// Exact popup width; null sizes up to [maxWidth] (at least [minWidth]).
  final double? width;

  /// Maximum popup width; the rows stretch to it.
  final double maxWidth;

  /// Maximum popup height; taller content scrolls inside the surface.
  final double maxHeight;
  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData app = ShadcnTheme.of(context);
    final Color fg = foreground ?? app.colors.popoverForeground;
    final BorderRadius radius =
        borderRadius ?? app.borderRadiusMd.resolve(Directionality.of(context));
    return _SurfaceSizing(
      minWidth: minWidth,
      width: width,
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      child: Container(
        padding: padding ?? const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: fill ?? app.colors.popover,
          border: Border.all(
            color: borderColor ?? app.colors.border,
            width: borderWidth,
          ),
          borderRadius: radius,
        ),
        child: DefaultTextStyle(
          style: TextStyle(color: fg),
          child: IconTheme.merge(
            data: IconThemeData(color: fg),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: children,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Sizes the popup surface from the incoming constraints without issuing
/// intrinsic queries.
///
/// A `LayoutBuilder` cannot do this job: anchored popovers with an intrinsic
/// size constraint (`PopoverConstraint.intrinsic`, e.g. the mobile rail
/// sheet) measure the surface with `getMaxIntrinsicWidth` during layout, and
/// any `LayoutBuilder` answers that with "does not support returning
/// intrinsic dimensions". This render object only lays out, so arbitrary
/// content (including `LayoutBuilder` descendants like `Slider`) is safe.
class _SurfaceSizing extends SingleChildRenderObjectWidget {
  /// Creates a surface sizer.
  const _SurfaceSizing({
    required this.minWidth,
    required this.width,
    required this.maxWidth,
    required this.maxHeight,
    required super.child,
  });

  /// Minimum popup width.
  final double minWidth;

  /// Exact popup width; null sizes up to [maxWidth].
  final double? width;

  /// Maximum popup width.
  final double maxWidth;

  /// Maximum popup height.
  final double maxHeight;

  @override
  RenderObject createRenderObject(BuildContext context) => _RenderSurfaceSizing(
    minWidth: minWidth,
    width: width,
    maxWidth: maxWidth,
    maxHeight: maxHeight,
  );

  @override
  void updateRenderObject(
    BuildContext context,
    _RenderSurfaceSizing renderObject,
  ) {
    if (renderObject.minWidth != minWidth ||
        renderObject.width != width ||
        renderObject.maxWidth != maxWidth ||
        renderObject.maxHeight != maxHeight) {
      renderObject
        ..minWidth = minWidth
        ..width = width
        ..maxWidth = maxWidth
        ..maxHeight = maxHeight;
      renderObject.markNeedsLayout();
    }
  }
}

/// The render object behind [_SurfaceSizing].
class _RenderSurfaceSizing extends RenderProxyBox {
  /// Creates a surface sizer.
  _RenderSurfaceSizing({
    required this.minWidth,
    required this.width,
    required this.maxWidth,
    required this.maxHeight,
  });

  /// Minimum popup width.
  double minWidth;

  /// Exact popup width; null sizes up to [maxWidth].
  double? width;

  /// Maximum popup width.
  double maxWidth;

  /// Maximum popup height.
  double maxHeight;

  @override
  void performLayout() {
    final RenderBox? child = this.child;
    if (child == null) {
      size = constraints.smallest;
      return;
    }
    final BoxConstraints incoming = constraints;
    double hi = math.min(maxWidth, incoming.maxWidth);
    if (hi < incoming.minWidth) hi = incoming.minWidth;
    double lo = math.min(minWidth, hi);
    final double? exact = width;
    if (exact != null) {
      final double tight = math.min(exact, hi);
      lo = math.max(incoming.minWidth, tight);
      hi = math.max(incoming.minWidth, tight);
    } else {
      lo = math.max(incoming.minWidth, lo);
    }
    // A tight incoming height comes from an anchored size constraint (the
    // select trigger, for example), not from the viewport: it must not cap
    // the popup, or every list would clip to one row. A loose height is the
    // viewport, so the popup stays inside it.
    final double ceiling = incoming.hasTightHeight
        ? maxHeight
        : incoming.hasBoundedHeight
        ? math.min(maxHeight, incoming.maxHeight)
        : maxHeight;
    child.layout(
      BoxConstraints(
        minWidth: lo,
        maxWidth: hi,
        minHeight: incoming.minHeight,
        maxHeight: math.max(ceiling, incoming.minHeight),
      ),
      parentUsesSize: true,
    );
    size = incoming.constrain(child.size);
  }
}

/// Opens one menu level as a non-modal popover anchored to [context].
///
/// The popover never dismisses itself: siblings close through the caller's
/// `MenuGroupData.closeOthers()` first, the whole menu through `closeAll()`.
/// Themes stay live through the handler's captured themes.
Future<T?> showMenuPopover<T>({
  required BuildContext context,
  required PopoverController controller,
  required WidgetBuilder popupBuilder,
  Offset? offset,
  AlignmentGeometry alignment = Alignment.topLeft,
  AlignmentGeometry anchorAlignment = Alignment.topRight,
}) {
  return controller.show<T>(
    context: context,
    handler: OverlayHandler.popover,
    modal: false,
    consumeOutsideTaps: false,
    dismissBackdropFocus: false,
    alignment: alignment,
    anchorAlignment: anchorAlignment,
    offset: offset ?? const Offset(8, -4),
    builder: popupBuilder,
  );
}

/// A non-interactive section header (shadcn `font-semibold`).
///
/// Plain widget on purpose: headers never take focus, so they stay out of
/// the `MenuItem` traversal contract and compose into any row list.
class MenuLabel extends StatelessWidget {
  /// Creates a menu label.
  const MenuLabel({super.key, required this.child});

  /// Label content.
  final Widget child;
  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData app = ShadcnTheme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: DefaultTextStyle(
        style: app.typography.small.copyWith(
          color: app.colors.foreground,
          fontWeight: FontWeight.w600,
        ),
        child: child,
      ),
    );
  }
}

/// A keyboard-shortcut hint: text-xs, widest tracking, muted, end-aligned
/// (compose as a row's trailing).
class MenuShortcut extends StatelessWidget {
  /// Creates a shortcut hint.
  const MenuShortcut({super.key, required this.shortcut});

  /// Hint text, e.g. '⇧⌘P'.
  final String shortcut;
  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData app = ShadcnTheme.of(context);
    return Text(
      shortcut,
      style: app.typography.small.copyWith(
        fontSize: 12,
        letterSpacing: 1.2,
        color: app.colors.mutedForeground,
      ),
    );
  }
}

/// A 1px separator between rows. Never focusable, like [MenuLabel].
class MenuSeparator extends StatelessWidget {
  /// Creates a menu separator.
  const MenuSeparator({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Container(height: 1, color: ShadcnTheme.of(context).colors.border),
    );
  }
}

/// Default vertical stretcher layout for [RovingGroup] menus.
Widget columnMenuBuilder(BuildContext context, List<Widget> rows) => Column(
  mainAxisSize: MainAxisSize.min,
  crossAxisAlignment: CrossAxisAlignment.stretch,
  children: rows,
);
