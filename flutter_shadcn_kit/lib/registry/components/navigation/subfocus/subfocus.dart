// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:data_widget/data_widget.dart';
import 'package:flutter/widgets.dart';
part '_impl/state/_sub_focus_state.dart';
part '_impl/core/sub_focus.dart';
part '_impl/state/_sub_focus_scope_state.dart';

/// Callback function type for building SubFocusScope widgets.
///
/// Receives the build context and the scope state for managing focus
/// within the scope's widget tree.
typedef SubFocusScopeBuilder =
    Widget Function(BuildContext context, SubFocusScopeState state);

/// Hierarchical focus management system for complex widget trees.
///
/// Creates a focus scope that manages keyboard navigation and focus traversal
/// for child widgets. Provides centralized control over which child widget
/// has focus and handles focus navigation between multiple focusable elements.
///
/// Key Features:
/// - **Focus Hierarchy**: Manages focus relationships between parent and child widgets
/// - **Keyboard Navigation**: Handles arrow key and tab navigation between elements
/// - **Action Delegation**: Routes keyboard actions to currently focused child
/// - **Auto-focus Support**: Automatically focuses first child when enabled
/// - **Focus State Management**: Tracks and updates focus state across widget rebuilds
/// - **Scroll Integration**: Ensures focused elements remain visible in scrollable areas
///
/// The scope maintains a list of attached [SubFocus] widgets and manages which
/// one currently has focus. It handles focus traversal, action routing, and
/// ensures focused widgets remain visible through scroll positioning.
///
/// Used commonly in:
/// - Lists with keyboard navigation
/// - Form field traversal
/// - Menu and dropdown navigation
/// - Tree view navigation
/// - Tab panel systems
///
/// Example:
/// ```dart
/// SubFocusScope(
///   autofocus: true,
///   builder: (context, state) => Column(
///     children: [
///       SubFocus(
///         builder: (context, focusState) => Container(
///           color: focusState.isFocused ? Colors.blue : Colors.grey,
///           child: Text('Item 1'),
///         ),
///       ),
///       SubFocus(
///         builder: (context, focusState) => Container(
///           color: focusState.isFocused ? Colors.blue : Colors.grey,
///           child: Text('Item 2'),
///         ),
///       ),
///     ],
///   ),
/// )
/// ```
class SubFocusScope extends StatefulWidget {
  /// Builder function that creates the widget tree for this scope.
  ///
  /// Called with the build context and the scope's state for managing
  /// focus within child widgets. If `null`, the scope acts as an invisible
  /// wrapper without building additional UI.
  final SubFocusScopeBuilder? builder;

  /// Whether the first child should automatically receive focus.
  ///
  /// When `true`, the first attached [SubFocus] widget will automatically
  /// gain focus when the scope is built. Defaults to `false`.
  final bool autofocus;

  /// Creates a sub-focus scope.
  ///
  /// Parameters:
  /// - [builder]: Widget builder with scope state (optional)
  /// - [autofocus]: Auto-focus first child (defaults to `false`)
  const SubFocusScope({super.key, this.builder, this.autofocus = false});

  @override
  /// Executes `createState` behavior for this component/composite.
  State<SubFocusScope> createState() => _SubFocusScopeState();
}

/// Mixin providing focus scope state management capabilities.
///
/// Defines the interface for interacting with a [SubFocusScope], including
/// methods for focus management, child attachment/detachment, and action routing.
///
/// This mixin is implemented by internal scope state classes and provides
/// the public API for focus operations within a scope.
mixin SubFocusScopeState {
  /// Invokes an action on the currently focused child widget.
  ///
  /// Routes keyboard shortcuts or other intents to the focused child.
  /// Returns the result of the action, or `null` if no child is focused
  /// or the action is not handled.
  ///
  /// Parameters:
  /// - [intent]: The intent/action to invoke
  ///
  /// Returns the action result or `null`.
  Object? invokeActionOnFocused(Intent intent);

  /// Moves focus to the next child in the specified direction.
  ///
  /// Traverses the focus order in the given direction, wrapping around
  /// at the edges if needed. Returns `true` if focus was successfully
  /// moved, `false` otherwise (e.g., no children available).
  ///
  /// Parameters:
  /// - [direction]: Direction to traverse (defaults to [TraversalDirection.down])
  ///
  /// Returns `true` if focus moved successfully.
  bool nextFocus([TraversalDirection direction = TraversalDirection.down]);

  /// Retrieves the nearest [SubFocusScopeState] from the widget tree.
  ///
  /// Searches up the widget tree for an ancestor [SubFocusScope] and
  /// returns its state. Returns `null` if no scope is found.
  ///
  /// Parameters:
  /// - [context]: Build context to search from
  ///
  /// Returns the scope state or `null`.
  static SubFocusScopeState? maybeOf(BuildContext context) {
    return Data.maybeOf<SubFocusScopeState>(context);
  }

  /// Detaches a child focus state from this scope.
  ///
  /// Called when a [SubFocus] widget is disposed or removed from the tree.
  /// Removes the child from the scope's managed focus list.
  ///
  /// Parameters:
  /// - [child]: The child state to detach
  void detach(SubFocusState child);

  /// Attaches a child focus state to this scope.
  ///
  /// Called when a [SubFocus] widget is initialized. Adds the child to
  /// the scope's managed focus list and may auto-focus it if configured.
  ///
  /// Parameters:
  /// - [child]: The child state to attach
  ///
  /// Returns `true` if attachment succeeded.
  bool attach(SubFocusState child);

  /// Requests focus for a specific child.
  ///
  /// Transfers focus to the specified child, unfocusing the previously
  /// focused child if any. Updates visual state and ensures the focused
  /// widget is scrolled into view if needed.
  ///
  /// Parameters:
  /// - [child]: The child to receive focus
  ///
  /// Returns `true` if focus was granted successfully.
  bool requestFocus(SubFocusState child);

  /// Removes focus from a specific child.
  ///
  /// If the specified child currently has focus, clears the focus state.
  /// Otherwise, does nothing.
  ///
  /// Parameters:
  /// - [child]: The child to unfocus
  ///
  /// Returns `true` if the child was unfocused, `false` if it didn't have focus.
  bool unfocus(SubFocusState child);
}

/// Callback function type for building SubFocus widgets.
///
/// Receives the build context and focus state for creating widgets that
/// respond to focus changes and user interactions.
/// Callback function type for building SubFocus widgets.
///
/// Receives the build context and the focus state for managing focus
/// presentation and behavior within the widget.
///
/// Parameters:
/// - [context]: The build context
/// - [state]: The focus state providing focus information and control methods
///
/// Returns the widget tree for this focusable element.
typedef SubFocusBuilder =
    Widget Function(BuildContext context, SubFocusState state);

/// Individual focusable widget within a SubFocusScope hierarchy.
///
/// Creates a single focusable element that can receive keyboard focus and respond
/// to user interactions within a [SubFocusScope]. Provides focus state information
/// and handles focus-related behaviors like visibility scrolling and action routing.
///
/// Key Features:
/// - **Focus State**: Tracks and reports whether this widget currently has focus
/// - **Focus Request**: Can programmatically request focus from its parent scope
/// - **Action Handling**: Receives and processes keyboard actions when focused
/// - **Scroll Integration**: Automatically scrolls to ensure visibility when focused
/// - **State Tracking**: Maintains focus count and state across widget lifecycle
/// - **Enable/Disable**: Can be temporarily disabled to prevent focus acquisition
///
/// The widget uses a builder pattern to provide focus state to child widgets,
/// allowing them to update their appearance and behavior based on focus status.
/// This enables rich visual feedback for focused states.
///
/// Common Use Cases:
/// - List items in navigable lists
/// - Form fields in keyboard-navigable forms
/// - Menu items in dropdown menus
/// - Tree nodes in tree views
/// - Tab headers in tab panels
///
/// Example:
/// ```dart
/// SubFocus(
///   enabled: true,
///   builder: (context, state) => GestureDetector(
///     onTap: () => state.requestFocus(),
///     child: Container(
///       padding: EdgeInsets.all(8),
///       decoration: BoxDecoration(
///         color: state.isFocused ? Colors.blue : Colors.transparent,
///         border: Border.all(
///           color: state.isFocused ? Colors.blue : Colors.grey,
///         ),
///       ),
///       child: Text(
///         'Focusable Item',
///         style: TextStyle(
///           color: state.isFocused ? Colors.white : Colors.black,
///         ),
///       ),
///     ),
///   ),
/// )
/// ```

/// Mixin providing focus state and control capabilities for focusable widgets.
///
/// Defines the interface for interacting with a [SubFocus] widget, including
/// methods for focus management, visibility control, and action handling.
///
/// This mixin is implemented by internal focus state classes and provides
/// the public API for focus operations on individual focusable elements.
mixin SubFocusState {
  /// Retrieves the render box for this focusable element.
  ///
  /// Used for positioning and scroll calculations. Returns `null` if
  /// the widget is not currently rendered.
  ///
  /// Returns the [RenderBox] or `null`.
  RenderBox? findRenderObject();

  /// Scrolls the widget into view within its scrollable ancestor.
  ///
  /// Ensures the focused widget is visible by scrolling its nearest
  /// [Scrollable] ancestor. Useful when focus moves to an off-screen element.
  ///
  /// Parameters:
  /// - [alignmentPolicy]: How to align the widget when scrolling
  void ensureVisible({
    ScrollPositionAlignmentPolicy alignmentPolicy =
        ScrollPositionAlignmentPolicy.explicit,
  });

  /// Whether this element currently has focus.
  ///
  /// Returns `true` if this is the focused element in its parent scope.
  bool get isFocused;

  /// Requests focus for this element.
  ///
  /// Asks the parent scope to transfer focus to this element. Returns
  /// `true` if focus was successfully acquired, `false` otherwise.
  ///
  /// Returns `true` on success.
  bool requestFocus();

  /// Invokes an action/intent on this focused element.
  ///
  /// Routes keyboard shortcuts or other actions to this widget's
  /// action handlers. Returns the action result or `null` if not handled.
  ///
  /// Parameters:
  /// - [intent]: The intent/action to invoke
  ///
  /// Returns the action result or `null`.
  Object? invokeAction(Intent intent);

  /// The number of times this element has received focus.
  ///
  /// Increments each time [requestFocus] succeeds. Useful for analytics
  /// or behavior tracking.
  int get focusCount;

  /// Marks this element as focused or unfocused (internal method).
  ///
  /// Called by the parent scope to update focus state. Should not be
  /// called directly by application code.
  ///
  /// Parameters:
  /// - [focused]: Whether the element should be focused
  void markFocused(bool focused);

  /// Removes focus from this element.
  ///
  /// Asks the parent scope to clear focus from this element. Returns
  /// `true` if focus was successfully removed, `false` if it didn't have focus.
  ///
  /// Returns `true` on success.
  bool unfocus();
}
