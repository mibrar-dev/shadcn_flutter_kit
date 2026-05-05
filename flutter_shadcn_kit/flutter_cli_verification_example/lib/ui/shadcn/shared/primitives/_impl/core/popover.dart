part of '../../overlay.dart';

/// Popover defines a reusable type for this registry module.
class Popover {
  /// Global key for accessing the overlay handler state.
  final GlobalKey<OverlayHandlerStateMixin> key;

  /// The overlay completer that manages this popover's lifecycle.
  final OverlayCompleter entry;

  /// Creates a popover instance with the specified key and entry.
  ///
  /// This constructor is typically used internally by the popover system.
  /// Use [PopoverController.show] to create and display popovers.
  Popover._(this.key, this.entry);

  /// Closes this popover with optional immediate dismissal.
  ///
  /// If [immediate] is true, skips closing animations and removes the popover
  /// immediately. Otherwise, plays the closing animation before removal.
  ///
  /// Returns a Future that completes when the popover is fully dismissed.
  ///
  /// Parameters:
  /// - [immediate] (bool, default: false): Whether to skip closing animations
  ///
  /// Example:
  /// ```dart
  /// await popover.close(); // Animated close
  /// await popover.close(true); // Immediate close
  /// ```
  Future<void> close([bool immediate = false]) {
/// Stores `currentState` state/configuration for this implementation.
    var currentState = key.currentState;
    if (currentState != null) {
      return currentState.close(immediate);
    } else {
      entry.remove();
    }
    return Future.value();
  }

  /// Schedules this popover to close after the current frame.
  ///
  /// This method queues the close operation for the next frame, allowing
  /// any current operations to complete before dismissing the popover.
  void closeLater() {
/// Stores `currentState` state/configuration for this implementation.
    var currentState = key.currentState;
    if (currentState != null) {
      currentState.closeLater();
    } else {
      entry.remove();
    }
  }

  /// Immediately removes this popover from the overlay without animations.
  ///
  /// This method bypasses all closing animations and state management,
  /// directly removing the popover from the overlay stack. Use with caution
  /// as it may interrupt ongoing operations.
  void remove() {
    entry.remove();
  }

  /// Gets the current overlay handler state if the popover is mounted.
  ///
  /// Returns null if the popover has been disposed or is not currently
  /// in the widget tree. Useful for checking popover status and accessing
  /// advanced control methods.
  OverlayHandlerStateMixin? get currentState => key.currentState;
}

/// A controller for managing multiple popovers and their lifecycle.
///
/// [PopoverController] provides centralized management for popover instances,
/// including creation, lifecycle tracking, and coordination between multiple
/// popovers. It handles the complexity of overlay management and provides
/// a clean API for popover operations.
///
/// Key responsibilities:
/// - Creating and showing new popovers
/// - Tracking active popover instances
/// - Coordinating close operations across popovers
/// - Managing popover lifecycle states
/// - Providing status queries for open/mounted popovers
///
/// The controller maintains a list of active popovers and provides methods
/// to query their status, close them individually or collectively, and
/// coordinate their display behavior.
///
/// Example:
/// ```dart
/// class MyWidget extends StatefulWidget {
///   @override
///   _MyWidgetState createState() => _MyWidgetState();
/// }
///
/// class _MyWidgetState extends State<MyWidget> {
///   final PopoverController _popoverController = PopoverController();
///
///   @override
///   void dispose() {
///     _popoverController.dispose();
///     super.dispose();
///   }
///
///   void _showMenu() async {
///     await _popoverController.show(
///       context: context,
///       alignment: Alignment.bottomStart,
///       builder: (context) => MyPopoverContent(),
///     );
///   }
/// }
/// ```
