// The `overlay_configuration` component: describe *what* overlay to show and
// *how*, independent of the mechanism (popover, drawer, sheet, dialog,
// tooltip).
//
// Ported from `components/overlay/overlay_configuration`. The old compile-
// parity shim stored dozens of unused upstream parameters; this is a clean
// break: drawer/sheet configurations drive the real `drawer` routes,
// popover/tooltip use `primitives/popover`.
//
// Breaking change (B06): custom anchors resolve through the tree. A non-
// `ContextAnchor` (for example a `LinkedAnchor`) only resolves under an
// `OverlayAnchorScope`; the old process-wide anchor registry is gone.

import 'package:flutter/widgets.dart';

import '../../components/anchor/anchor.dart';
import '../../components/drawer/drawer.dart';
import '../../foundation/data.dart';
import '../../foundation/platform.dart';
import '../../primitives/overlay.dart';
import '../../primitives/popover.dart';
import '../../theme/theme.dart';

export '../../primitives/overlay.dart' show OverlayCompleter, OverlayBarrier;
export '../../components/drawer/drawer.dart' show OverlayPosition;

/// Describes what overlay to show and how, independent of the specific
/// mechanism.
abstract class OverlayConfiguration {
  const OverlayConfiguration();

  OverlayCompleter<T?> show<T>(BuildContext context, WidgetBuilder builder);

  OverlayConfiguration adaptiveConversion(BuildContext context) => this;

  OverlayConfiguration get nonAdaptive => this;

  static OverlayConfiguration? maybeOf(BuildContext context) =>
      Data.maybeOf<OverlayConfiguration>(context);
}

/// Presents [configuration] with [builder] as its content.
OverlayCompleter<T?> showOverlay<T>(
  BuildContext context,
  OverlayConfiguration configuration, {
  required WidgetBuilder builder,
  bool adaptive = true,
}) {
  final OverlayConfiguration resolved = adaptive
      ? configuration.adaptiveConversion(context)
      : configuration;
  return resolved.show<T>(context, builder);
}

/// Wraps [builder] so [OverlayConfiguration.maybeOf] keeps working inside the
/// presented content.
WidgetBuilder _content(
  OverlayConfiguration configuration,
  WidgetBuilder builder,
) {
  return (BuildContext context) => Data<OverlayConfiguration>.inherit(
    data: configuration,
    child: Builder(builder: builder),
  );
}

/// Resolves the context a popover anchors to: the [Anchor]'s own context when
/// it exposes one, otherwise the caller's.
BuildContext _anchorContext(BuildContext context, Anchor? anchor) {
  final Anchor? resolved = anchor?.resolve(context);
  if (resolved is ContextAnchor && resolved.context != null) {
    return resolved.context!;
  }
  return context;
}

OverlayCompleter<T?> _showPopoverConfiguration<T>({
  required BuildContext context,
  required OverlayConfiguration configuration,
  required WidgetBuilder builder,
  required AlignmentGeometry alignment,
  Anchor? anchor,
  AlignmentGeometry? anchorAlignment,
  bool modal = true,
  bool barrierDismissable = true,
  Offset? offset,
  bool follow = true,
  bool consumeOutsideTaps = true,
  bool dismissBackdropFocus = true,
  Duration? showDuration,
  Duration? dismissDuration,
  OverlayBarrier? overlayBarrier,
}) {
  return showPopover<T>(
    context: _anchorContext(context, anchor),
    alignment: alignment,
    anchorAlignment: anchorAlignment,
    modal: modal,
    barrierDismissable: barrierDismissable,
    offset: offset,
    follow: follow,
    consumeOutsideTaps: consumeOutsideTaps,
    dismissBackdropFocus: dismissBackdropFocus,
    showDuration: showDuration,
    dismissDuration: dismissDuration,
    overlayBarrier: overlayBarrier,
    builder: _content(configuration, builder),
  );
}

/// Presents its content as a popover.
///
/// On mobile, [adaptiveConversion] maps to a bottom [DrawerConfiguration]
/// (matching upstream adaptive behaviour); there is no separate
/// `MenuConfiguration` because it was identical to this.
class PopoverConfiguration extends OverlayConfiguration {
  const PopoverConfiguration({
    required this.alignment,
    this.anchor,
    this.anchorAlignment,
    this.modal = true,
    this.barrierDismissable = true,
    this.offset,
    this.follow = true,
    this.showDuration,
    this.dismissDuration,
    this.overlayBarrier,
  });

  final Anchor? anchor;

  final AlignmentGeometry alignment;

  final AlignmentGeometry? anchorAlignment;

  final bool modal;

  final bool barrierDismissable;

  final Offset? offset;

  final bool follow;

  final Duration? showDuration;

  final Duration? dismissDuration;

  final OverlayBarrier? overlayBarrier;

  @override
  OverlayConfiguration adaptiveConversion(BuildContext context) {
    if (isMobile(ShadcnTheme.of(context).platform)) {
      return DrawerConfiguration(
        position: OverlayPosition.bottom,
        barrierDismissible: barrierDismissable,
      );
    }
    return this;
  }

  OverlayCompleter<T?> _showPopoverWith<T>(
    BuildContext context,
    WidgetBuilder builder, {
    AlignmentGeometry? at,
    bool? asModal,
    bool? follows,
    bool consumeOutsideTaps = true,
    bool dismissBackdropFocus = true,
  }) {
    return _showPopoverConfiguration<T>(
      context: context,
      configuration: this,
      builder: builder,
      alignment: at ?? alignment,
      anchor: anchor,
      anchorAlignment: anchorAlignment,
      modal: asModal ?? modal,
      barrierDismissable: barrierDismissable,
      offset: offset,
      follow: follows ?? follow,
      consumeOutsideTaps: consumeOutsideTaps,
      dismissBackdropFocus: dismissBackdropFocus,
      showDuration: showDuration,
      dismissDuration: dismissDuration,
      overlayBarrier: overlayBarrier,
    );
  }

  @override
  OverlayCompleter<T?> show<T>(BuildContext context, WidgetBuilder builder) =>
      _showPopoverWith<T>(context, builder);
}

/// Presents its content as a tooltip: a non-modal popover that never follows
/// on mobile.
class TooltipConfiguration extends PopoverConfiguration {
  const TooltipConfiguration({
    super.anchor,
    super.alignment = Alignment.center,
    super.anchorAlignment,
    super.offset,
    super.follow = true,
    super.showDuration,
    super.dismissDuration,
  });

  @override
  OverlayCompleter<T?> show<T>(BuildContext context, WidgetBuilder builder) {
    final bool mobile = isMobile(ShadcnTheme.of(context).platform);
    return _showPopoverWith<T>(
      context,
      builder,
      asModal: false,
      follows: mobile ? false : follow,
      consumeOutsideTaps: false,
      dismissBackdropFocus: false,
    );
  }
}

/// Presents its content as a drawer via the `drawer` component.
class DrawerConfiguration extends OverlayConfiguration {
  const DrawerConfiguration({
    this.anchor,
    this.position = OverlayPosition.bottom,
    this.expands = false,
    this.draggable = true,
    this.barrierDismissible = true,
    this.useSafeArea = true,
    this.showDragHandle,
    this.borderRadius,
    this.maxSize,
    this.useRootNavigator = true,
  });

  final Anchor? anchor;

  final OverlayPosition position;

  final bool expands;

  final bool draggable;

  final bool barrierDismissible;

  final bool useSafeArea;

  final bool? showDragHandle;

  final BorderRadius? borderRadius;

  final double? maxSize;

  final bool useRootNavigator;

  @override
  OverlayCompleter<T?> show<T>(BuildContext context, WidgetBuilder builder) {
    return openDrawerOverlay<T>(
      context: context,
      position: position,
      expands: expands,
      draggable: draggable,
      barrierDismissible: barrierDismissible,
      useSafeArea: useSafeArea,
      showDragHandle: showDragHandle,
      borderRadius: borderRadius,
      maxSize: maxSize,
      useRootNavigator: useRootNavigator,
      builder: _content(this, builder),
    );
  }
}

/// Presents its content as a full-extent sheet via the `drawer` component.
class SheetConfiguration extends DrawerConfiguration {
  const SheetConfiguration({
    super.anchor,
    super.position = OverlayPosition.bottom,
    super.expands = true,
    super.draggable = false,
    super.barrierDismissible,
    super.useSafeArea = false,
    super.showDragHandle,
    super.borderRadius,
    super.maxSize,
    super.useRootNavigator,
  });

  @override
  OverlayCompleter<T?> show<T>(BuildContext context, WidgetBuilder builder) {
    return openSheetOverlay<T>(
      context: context,
      position: position,
      expands: expands,
      draggable: draggable,
      barrierDismissible: barrierDismissible,
      useSafeArea: useSafeArea,
      showDragHandle: showDragHandle,
      borderRadius: borderRadius,
      maxSize: maxSize,
      useRootNavigator: useRootNavigator,
      builder: _content(this, builder),
    );
  }
}

/// Presents its content as a centered modal dialog.
class DialogConfiguration extends OverlayConfiguration {
  const DialogConfiguration({
    this.alignment = Alignment.center,
    this.barrierDismissible = true,
    this.barrierColor = const Color(0x80000000),
  });

  final AlignmentGeometry alignment;

  final bool barrierDismissible;

  final Color barrierColor;

  @override
  OverlayCompleter<T?> show<T>(BuildContext context, WidgetBuilder builder) {
    return _showPopoverConfiguration<T>(
      context: context,
      configuration: this,
      builder: builder,
      alignment: alignment,
      modal: true,
      barrierDismissable: barrierDismissible,
      overlayBarrier: OverlayBarrier(barrierColor: barrierColor),
    );
  }
}

/// Controls a single managed overlay presented from an
/// [OverlayConfiguration].
class OverlayController extends ChangeNotifier {
  OverlayCompleter<Object?>? _completer;
  OverlayConfiguration? _config;
  bool _disposed = false;

  OverlayConfiguration? get config => _config;

  bool get hasOpenOverlay => _completer != null && !_completer!.isCompleted;

  bool get hasMountedOverlay =>
      _completer != null && !_completer!.isAnimationCompleted;

  Future<T?> show<T>(
    BuildContext context,
    OverlayConfiguration configuration, {
    required WidgetBuilder builder,
    bool adaptive = true,
  }) {
    close();
    final OverlayConfiguration resolved = adaptive
        ? configuration.adaptiveConversion(context)
        : configuration;
    final OverlayCompleter<T?> completer = resolved.show<T>(context, builder);
    _completer = completer;
    _config = resolved;
    notifyListeners();
    completer.future.whenComplete(() {
      if (identical(_completer, completer)) {
        _completer = null;
        _config = null;
        if (!_disposed) {
          notifyListeners();
        }
      }
    });
    return completer.future;
  }

  void close() {
    final OverlayCompleter<Object?>? completer = _completer;
    _completer = null;
    _config = null;
    completer?.remove();
    if (!_disposed) {
      notifyListeners();
    }
  }

  void closeLater() => close();

  @override
  void dispose() {
    if (_disposed) {
      return;
    }
    _disposed = true;
    _completer?.remove();
    _completer = null;
    super.dispose();
  }
}
