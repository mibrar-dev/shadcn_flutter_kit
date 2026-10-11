// The widget that installs an app-level [OverlayManager] and routes overlay
// requests to the per-kind handlers.
//
// Ported from `shared/primitives/_impl/core/overlay_manager_layer.dart` and
// `_impl/state/__overlay_manager_layer_state.dart`.

import 'package:flutter/widgets.dart';

import '../foundation/data.dart';
import 'overlay.dart';
import 'overlay_manager.dart';
import 'popover_overlay_state.dart';

/// Installs an [OverlayManager] into the tree.
///
/// See [ShadcnLayer] for a wrapper that only installs this layer when the app
/// does not already have a manager.
class OverlayManagerLayer extends StatefulWidget {
  /// Handler for popover overlays.
  final OverlayHandler popoverHandler;

  /// Handler for tooltip overlays.
  final OverlayHandler tooltipHandler;

  /// Handler for menu overlays.
  final OverlayHandler menuHandler;

  /// The wrapped subtree.
  final Widget child;

  /// Creates an overlay manager layer.
  const OverlayManagerLayer({
    super.key,
    required this.popoverHandler,
    required this.tooltipHandler,
    required this.menuHandler,
    required this.child,
  });

  @override
  State<OverlayManagerLayer> createState() => OverlayManagerLayerState();
}

/// State of [OverlayManagerLayer].
///
/// Framework-internal: public only so the widget can create it across files.
class OverlayManagerLayerState extends State<OverlayManagerLayer>
    implements OverlayManager {
  @override
  Widget build(BuildContext context) {
    return Data<OverlayManager>.inherit(data: this, child: widget.child);
  }

  @override
  OverlayCompleter<T?> show<T>({
    required BuildContext context,
    required WidgetBuilder builder,
    AlignmentGeometry alignment = Alignment.center,
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
    return widget.popoverHandler.show(
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

  @override
  OverlayCompleter<T?> showTooltip<T>({
    required BuildContext context,
    required WidgetBuilder builder,
    AlignmentGeometry alignment = Alignment.center,
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
    return widget.tooltipHandler.show(
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

  @override
  OverlayCompleter<T?> showMenu<T>({
    required BuildContext context,
    required WidgetBuilder builder,
    AlignmentGeometry alignment = Alignment.center,
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
    return widget.menuHandler.show(
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
