part of '../../overlay.dart';

/// OverlayPopoverEntry defines a reusable type for this registry module.
class OverlayPopoverEntry<T> implements OverlayCompleter<T> {
/// Stores `_overlayEntry` state/configuration for this implementation.
  late OverlayEntry _overlayEntry;
/// Stores `_barrierEntry` state/configuration for this implementation.
  late OverlayEntry? _barrierEntry;

  /// Completer for the popover's result value.
  final Completer<T?> completer = Completer();

  /// Completer that tracks the popover's animation lifecycle.
  ///
  /// Completes when the popover's entry and exit animations finish.
  /// Used internally to coordinate animation timing and cleanup.
  final Completer<T?> animationCompleter = Completer();

/// Stores `_removed` state/configuration for this implementation.
  bool _removed = false;
/// Stores `_disposed` state/configuration for this implementation.
  bool _disposed = false;

  @override
/// Stores `isCompleted` state/configuration for this implementation.
  bool get isCompleted => completer.isCompleted;

  /// Initializes the popover entry with overlay entries.
  ///
  /// Must be called before the popover can be displayed.
  ///
  /// Parameters:
  /// - [overlayEntry] (OverlayEntry, required): Main overlay entry
  /// - [barrierEntry] (OverlayEntry?): Optional barrier entry
  void initialize(OverlayEntry overlayEntry, [OverlayEntry? barrierEntry]) {
    _overlayEntry = overlayEntry;
    _barrierEntry = barrierEntry;
  }

  @override
/// Executes `remove` behavior for this component/composite.
  void remove() {
    if (_removed) return;
    _removed = true;
    _overlayEntry.remove();
    _barrierEntry?.remove();
  }

  @override
/// Executes `dispose` behavior for this component/composite.
  void dispose() {
    if (_disposed) return;
    _disposed = true;
    _overlayEntry.dispose();
    _barrierEntry?.dispose();
  }

  @override
/// Stores `future` state/configuration for this implementation.
  Future<T?> get future => completer.future;

  @override
/// Stores `animationFuture` state/configuration for this implementation.
  Future<T?> get animationFuture => animationCompleter.future;

  @override
/// Stores `isAnimationCompleted` state/configuration for this implementation.
  bool get isAnimationCompleted => animationCompleter.isCompleted;
}

/// Displays a popover overlay with specified alignment and behavior.
///
/// Parameters:
/// - [context] (`BuildContext`, required): Widget context.
/// - [alignment] (`AlignmentGeometry`, required): Popover alignment relative to anchor.
/// - [builder] (`WidgetBuilder`, required): Builds popover content.
/// - [position] (`Offset?`, optional): Explicit position.
/// - [anchorAlignment] (`AlignmentGeometry?`, optional): Anchor alignment point.
/// - [widthConstraint] (`PopoverConstraint`, optional): Width constraint mode. Default: flexible.
/// - [heightConstraint] (`PopoverConstraint`, optional): Height constraint mode. Default: flexible.
/// - [key] (`Key?`, optional): Widget key.
/// - [rootOverlay] (`bool`, optional): Use root overlay. Default: true.
/// - [modal] (`bool`, optional): Modal behavior. Default: true.
/// - [barrierDismissable] (`bool`, optional): Tap outside to dismiss. Default: true.
/// - [clipBehavior] (`Clip`, optional): Clipping behavior. Default: Clip.none.
/// - [regionGroupId] (`Object?`, optional): Region grouping identifier.
/// - [offset] (`Offset?`, optional): Additional offset.
/// - [transitionAlignment] (`AlignmentGeometry?`, optional): Transition origin.
/// - [margin] (`EdgeInsetsGeometry?`, optional): Popover margin.
/// - [follow] (`bool`, optional): Follow anchor movement. Default: true.
/// - [consumeOutsideTaps] (`bool`, optional): Consume outside taps. Default: true.
/// - [onTickFollow] (`ValueChanged<PopoverOverlayWidgetState>?`, optional): Follow callback.
/// - [allowInvertHorizontal] (`bool`, optional): Allow horizontal inversion. Default: true.
/// - [allowInvertVertical] (`bool`, optional): Allow vertical inversion. Default: true.
/// - [dismissBackdropFocus] (`bool`, optional): Dismiss on backdrop focus. Default: true.
/// - [showDuration] (`Duration?`, optional): Show animation duration.
/// - [dismissDuration] (`Duration?`, optional): Dismiss animation duration.
/// - [overlayBarrier] (`OverlayBarrier?`, optional): Custom barrier configuration.
/// - [handler] (`OverlayHandler?`, optional): Custom overlay handler.
///
/// Returns: `OverlayCompleter<T?>` — handle to control the popover.
///
/// Example:
/// ```dart
/// showPopover(
///   context: context,
///   alignment: Alignment.bottomCenter,
///   builder: (context) => Text('Popover content'),
/// );
/// ```
OverlayCompleter<T?> showPopover<T>({
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
  OverlayHandler? handler,
}) {
  handler ??= OverlayManager.of(context);
  return handler.show<T>(
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
  );
}

/// A comprehensive popover overlay system for displaying contextual content.
///
/// [Popover] provides a flexible foundation for creating overlay widgets that appear
/// relative to anchor elements. It handles positioning, layering, and lifecycle
/// management for temporary content displays such as dropdowns, menus, tooltips,
/// and dialogs. The system automatically manages positioning constraints and
/// viewport boundaries.
///
/// The popover system consists of:
/// - [Popover]: Individual popover instances with control methods
/// - [PopoverController]: Manager for multiple popovers with lifecycle control
/// - [PopoverLayout]: Positioning and constraint resolution
/// - Overlay integration for proper z-ordering and event handling
///
/// Key features:
/// - Intelligent positioning with automatic viewport constraint handling
/// - Multiple attachment points and alignment options
/// - Modal and non-modal display modes
/// - Animation and transition support
/// - Barrier dismissal with configurable behavior
/// - Follow-anchor behavior for responsive positioning
/// - Multi-popover management with close coordination
///
/// Positioning capabilities:
/// - Flexible alignment relative to anchor widgets
/// - Automatic inversion when space is constrained
/// - Custom offset adjustments
/// - Margin and padding controls
/// - Width and height constraint options
///
/// Example usage:
/// ```dart
/// final controller = PopoverController();
///
/// // Show a popover
/// final popover = await controller.show<String>(
///   context: context,
///   alignment: Alignment.bottomStart,
///   anchorAlignment: Alignment.topStart,
///   builder: (context) => PopoverMenu(
///     children: [
///       PopoverMenuItem(child: Text('Option 1')),
///       PopoverMenuItem(child: Text('Option 2')),
///     ],
///   ),
/// );
/// ```
