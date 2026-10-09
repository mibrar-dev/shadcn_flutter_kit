// The `tooltip` component: [Tooltip] (a delayed hover label presented through
// the popover machinery), [TooltipContainer] (the themed surface both this
// component and its dependents build their content with) and the tooltip
// overlay handler.
//
// Ported from `components/overlay/tooltip/**` (a 25-line barrel plus seven
// `part`s). Fixes, all verified against the old source:
//   * `InstantTooltip` was a byte-for-byte second copy of `Tooltip` with a
//     zero `waitDuration` and an un-debounced `MouseRegion`. It is one widget
//     with `waitDuration: Duration.zero` now.
//   * `FixedTooltipOverlayHandler` (142 lines) re-implemented
//     `PopoverOverlayHandler.show` and had **zero** readers. Deleted; the
//     primitive already captures `InheritedTheme` and `Data`.
//   * `adaptiveOverlay` went through `showOverlay` + `TooltipConfiguration`
//     from the `overlay_configuration` component, which this component may not
//     depend on. Dropped: an app installs a distinct tooltip handler through
//     `ShadcnLayer.tooltipHandler` instead, and the handler is used below.
//   * `TooltipContainer` read only `this.theme ?? ComponentTheme.maybeOf`, so
//     app-wide overrides never applied and no token default existed for the
//     background, padding or radius.
//   * `TooltipContainer` multiplied the *already resolved* padding by
//     `theme.scaling`, so a caller padding was silently inflated.

import 'dart:ui' show ImageFilter;

import 'package:flutter/widgets.dart';

import '../../primitives/hover.dart';
import '../../primitives/overlay.dart';
import '../../primitives/overlay_manager.dart';
import '../../primitives/popover_controller.dart';
import '../../primitives/popover_overlay_state.dart';
import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';
import 'tooltip_style.dart';

export 'tooltip_style.dart';

/// Default delay before a tooltip appears (shadcn `delayDuration: 0`, the old
/// Flutter default was 500 ms and is kept).
const Duration kTooltipWaitDuration = Duration(milliseconds: 500);

/// Default grace period after the pointer leaves before the tooltip hides.
const Duration kTooltipShowDuration = Duration(milliseconds: 200);

/// A short label shown while the pointer rests on [child].
///
/// [tooltip] returns the bare content: the widget wraps it in a
/// [TooltipContainer] itself, so a plain `Text` is enough:
///
/// ```dart
/// Tooltip(
///   child: Icon(LucideIcons.info),
///   tooltip: (context) => const Text('Details'),
/// );
/// ```
class Tooltip extends StatefulWidget {
  /// Creates a tooltip.
  const Tooltip({
    super.key,
    required this.child,
    required this.tooltip,
    this.alignment = Alignment.topCenter,
    this.anchorAlignment = Alignment.bottomCenter,
    this.waitDuration = kTooltipWaitDuration,
    this.showDuration = kTooltipShowDuration,
    this.minDuration = Duration.zero,
    this.theme,
  });

  /// The anchor the tooltip points at.
  final Widget child;

  /// Builds the tooltip content. The result is wrapped in a
  /// [TooltipContainer], so return the bare content (usually a `Text`).
  final WidgetBuilder tooltip;

  /// Where the tooltip sits relative to itself.
  final AlignmentGeometry alignment;

  /// Which edge of [child] the tooltip points at.
  final AlignmentGeometry anchorAlignment;

  /// Delay before the tooltip appears.
  final Duration waitDuration;

  /// Grace period after the pointer leaves.
  final Duration showDuration;

  /// Minimum time the tooltip stays visible.
  final Duration minDuration;

  /// Widget-leg theme override for the presented container.
  final TooltipTheme? theme;

  @override
  State<Tooltip> createState() => _TooltipState();
}

class _TooltipState extends State<Tooltip> {
  final PopoverController _controller = PopoverController();

  /// Routes a presentation request to the app's tooltip handler.
  ///
  /// `showPopover` only knows how to call `OverlayHandler.show`, while
  /// `ShadcnLayer` installs a distinct handler for tooltips; this adapter
  /// keeps that distinction without a component dependency.
  OverlayHandler _handler(BuildContext context) {
    return TooltipOverlayHandler(OverlayManager.of(context));
  }

  void _show(BuildContext context) {
    final TooltipTheme theme = _resolveTheme(context);
    _controller.show<void>(
      context: context,
      modal: false,
      // The label is not interactive: an outside tap must not steal focus.
      dismissBackdropFocus: false,
      alignment: widget.alignment,
      anchorAlignment: widget.anchorAlignment,
      handler: _handler(context),
      builder: (overlayContext) =>
          TooltipContainer(theme: theme, child: widget.tooltip(overlayContext)),
    );
  }

  void _hide() => _controller.close();

  TooltipTheme _resolveTheme(BuildContext context) {
    return resolveComponentStyle<TooltipTheme, TooltipTheme>(
      context,
      widget: widget.theme,
      select: (t) => t,
      defaults: tooltipDefaults,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Hover(
      waitDuration: widget.waitDuration,
      minDuration: widget.minDuration,
      showDuration: widget.showDuration,
      onHover: (hovered) {
        if (hovered) {
          _show(context);
        } else {
          _hide();
        }
      },
      child: widget.child,
    );
  }
}

/// Presents every overlay kind through an [OverlayManager]'s tooltip route.
///
/// The manager interface splits `show`, `showTooltip` and `showMenu` so an app
/// can style each kind separately; this adapter is what a component needs to
/// reach the tooltip route from [showPopover].
class TooltipOverlayHandler extends OverlayHandler {
  /// The manager every presentation is delegated to.
  final OverlayManager manager;

  /// Creates a tooltip overlay handler.
  const TooltipOverlayHandler(this.manager);

  @override
  OverlayCompleter<T?> show<T>({
    required BuildContext context,
    required AlignmentGeometry alignment,
    required WidgetBuilder builder,
    Offset? position,
    AlignmentGeometry? anchorAlignment,
    PopoverConstraint widthConstraint = PopoverConstraint.flexible,
    PopoverConstraint heightConstraint = PopoverConstraint.flexible,
    Key? key,
    bool rootOverlay = true,
    bool modal = true,
    bool barrierDismissable = true,
    Clip clipBehavior = Clip.none,
    Object? regionGroupId,
    Offset? offset,
    AlignmentGeometry? transitionAlignment,
    EdgeInsetsGeometry? margin,
    bool follow = true,
    bool consumeOutsideTaps = true,
    ValueChanged<PopoverOverlayWidgetState>? onTickFollow,
    bool allowInvertHorizontal = true,
    bool allowInvertVertical = true,
    bool dismissBackdropFocus = true,
    Duration? showDuration,
    Duration? dismissDuration,
    OverlayBarrier? overlayBarrier,
    LayerLink? layerLink,
  }) {
    return manager.showTooltip<T>(
      context: context,
      alignment: alignment,
      builder: builder,
      position: position,
      anchorAlignment: anchorAlignment,
      widthConstraint: widthConstraint,
      heightConstraint: heightConstraint,
      key: key,
      rootOverlay: rootOverlay,
      modal: modal,
      barrierDismissable: barrierDismissable,
      clipBehavior: clipBehavior,
      regionGroupId: regionGroupId,
      offset: offset,
      transitionAlignment: transitionAlignment,
      margin: margin,
      follow: follow,
      consumeOutsideTaps: consumeOutsideTaps,
      onTickFollow: onTickFollow,
      allowInvertHorizontal: allowInvertHorizontal,
      allowInvertVertical: allowInvertVertical,
      dismissBackdropFocus: dismissBackdropFocus,
      showDuration: showDuration,
      dismissDuration: dismissDuration,
      overlayBarrier: overlayBarrier,
      layerLink: layerLink,
    );
  }
}

/// The themed surface a tooltip's content is painted on.
///
/// Dependents that build their own overlay content (`tracker`, `navigation_bar`)
/// use this instead of `Tooltip` directly.
class TooltipContainer extends StatelessWidget {
  /// Creates a tooltip surface.
  const TooltipContainer({
    super.key,
    required this.child,
    this.theme,
    this.padding,
    this.borderRadius,
    this.maxWidth,
  });

  /// The tooltip content.
  final Widget child;

  /// Widget-leg theme override, merged on top of the other legs.
  final TooltipTheme? theme;

  /// Inner padding override; applied once, never re-scaled.
  final EdgeInsetsGeometry? padding;

  /// Corner radius override.
  final BorderRadiusGeometry? borderRadius;

  /// Maximum content width before wrapping.
  final double? maxWidth;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData appTheme = ShadcnTheme.of(context);
    final TooltipTheme resolved =
        resolveComponentStyle<TooltipTheme, TooltipTheme>(
          context,
          widget: theme,
          select: (t) => t,
          defaults: tooltipDefaults,
        );
    final Color background =
        resolved.background?.resolve(appTheme.colors) ??
        appTheme.colors.primary;
    final Color foreground =
        resolved.foreground?.resolve(appTheme.colors) ??
        appTheme.colors.primaryForeground;
    final BorderRadius radius =
        (borderRadius ?? resolved.borderRadius ?? appTheme.borderRadiusSm)
            .resolve(Directionality.of(context));
    final EdgeInsets inner =
        (padding ??
                resolved.padding ??
                EdgeInsets.symmetric(
                  horizontal:
                      appTheme.density.baseContentPadding *
                      appTheme.scaling *
                      0.75,
                  vertical: appTheme.density.baseGap * appTheme.scaling * 0.75,
                ))
            .resolve(Directionality.of(context));
    final TextStyle textStyle = (resolved.textStyle ?? tooltipDefaultTextStyle)
        .copyWith(color: foreground);
    final double blur = resolved.surfaceBlur ?? appTheme.surfaceBlur ?? 0;

    Widget surface = Padding(
      padding: const EdgeInsets.all(4),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth ?? double.infinity),
        child: Container(
          padding: inner,
          decoration: BoxDecoration(color: background, borderRadius: radius),
          child: DefaultTextStyle(
            style: textStyle,
            child: IconTheme.merge(
              data: IconThemeData(color: foreground),
              child: child,
            ),
          ),
        ),
      ),
    );
    if (blur > 0) {
      surface = ClipRRect(
        borderRadius: radius,
        child: BackdropFilter(filter: _blur(blur), child: surface),
      );
    }
    return surface;
  }
}

/// Builds the blur filter for [TooltipContainer].
ImageFilter _blur(double sigma) =>
    ImageFilter.blur(sigmaX: sigma, sigmaY: sigma);
