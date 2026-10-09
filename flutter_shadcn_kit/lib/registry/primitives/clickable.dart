// The registry-wide interaction primitive: hover, press, focus, keyboard
// activation, semantics feedback and state-aware styling.
//
// Ported from `shared/primitives/clickable.dart` + `_impl/**`.

import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../foundation/constants.dart';
import '../foundation/data.dart';
import '../foundation/platform.dart';
import '../theme/theme.dart';
import 'animated_value_builder.dart';
import 'clickable_state.dart';
import 'focus_outline.dart';
import 'widget_states.dart';

/// A state-aware, accessible tap target.
///
/// Owns hover/focus/press state propagation ([WidgetStatesProvider]), the
/// keyboard activation shortcuts (enter/space + arrow traversal), semantics
/// feedback and optional focus outline. Styling is resolved per state from
/// the `WidgetStateProperty` arguments.
class Clickable extends StatefulWidget {
  /// The child displayed inside the tap target.
  final Widget child;

  /// Whether the widget responds to interaction.
  final bool enabled;

  /// Called when the hover state changes.
  final ValueChanged<bool>? onHover;

  /// Called when the focus state changes.
  final ValueChanged<bool>? onFocus;

  /// State-aware decoration.
  final WidgetStateProperty<Decoration?>? decoration;

  /// State-aware mouse cursor.
  final WidgetStateProperty<MouseCursor?>? mouseCursor;

  /// State-aware padding.
  final WidgetStateProperty<EdgeInsetsGeometry?>? padding;

  /// State-aware text style.
  final WidgetStateProperty<TextStyle?>? textStyle;

  /// State-aware icon theme.
  final WidgetStateProperty<IconThemeData?>? iconTheme;

  /// State-aware margin.
  final WidgetStateProperty<EdgeInsetsGeometry?>? margin;

  /// State-aware transformation matrix.
  final WidgetStateProperty<Matrix4?>? transform;

  /// Called on primary tap.
  final VoidCallback? onPressed;

  /// Called on double tap.
  final VoidCallback? onDoubleTap;

  /// Focus node for keyboard focus. Created internally when null.
  final FocusNode? focusNode;

  /// Hit-test behavior. Defaults to [HitTestBehavior.translucent].
  final HitTestBehavior behavior;

  /// Whether to skip state transition animations.
  final bool disableTransition;

  /// Extra keyboard shortcuts.
  final Map<LogicalKeySet, Intent>? shortcuts;

  /// Extra actions.
  final Map<Type, Action<Intent>>? actions;

  /// Whether to draw the focus outline.
  final bool focusOutline;

  /// Whether to fire tap feedback (semantics event, click sound).
  final bool enableFeedback;

  /// Called on long press.
  final VoidCallback? onLongPress;

  /// Called on primary tap down.
  final GestureTapDownCallback? onTapDown;

  /// Called on primary tap up.
  final GestureTapUpCallback? onTapUp;

  /// Called when the primary tap is cancelled.
  final GestureTapCancelCallback? onTapCancel;

  /// Called on secondary (right-click) tap down.
  final GestureTapDownCallback? onSecondaryTapDown;

  /// Called on secondary tap up.
  final GestureTapUpCallback? onSecondaryTapUp;

  /// Called when the secondary tap is cancelled.
  final GestureTapCancelCallback? onSecondaryTapCancel;

  /// Called on tertiary (middle-click) tap down.
  final GestureTapDownCallback? onTertiaryTapDown;

  /// Called on tertiary tap up.
  final GestureTapUpCallback? onTertiaryTapUp;

  /// Called when the tertiary tap is cancelled.
  final GestureTapCancelCallback? onTertiaryTapCancel;

  /// Called when a long press starts.
  final GestureLongPressStartCallback? onLongPressStart;

  /// Called when a long press is released.
  final GestureLongPressUpCallback? onLongPressUp;

  /// Called when a long press moves.
  final GestureLongPressMoveUpdateCallback? onLongPressMoveUpdate;

  /// Called when a long press ends.
  final GestureLongPressEndCallback? onLongPressEnd;

  /// Called on secondary long press completion.
  final GestureLongPressUpCallback? onSecondaryLongPress;

  /// Called on tertiary long press completion.
  final GestureLongPressUpCallback? onTertiaryLongPress;

  /// Whether to suppress the hover state.
  final bool disableHoverEffect;

  /// Optional controller for programmatic state management.
  final WidgetStatesController? statesController;

  /// Alignment used when a margin is applied.
  final AlignmentGeometry? marginAlignment;

  /// Whether to suppress the focus outline.
  final bool disableFocusOutline;

  /// Creates a [Clickable].
  const Clickable({
    super.key,
    required this.child,
    this.statesController,
    this.enabled = true,
    this.decoration,
    this.mouseCursor,
    this.padding,
    this.textStyle,
    this.iconTheme,
    this.onPressed,
    this.focusNode,
    this.behavior = HitTestBehavior.translucent,
    this.onHover,
    this.onFocus,
    this.disableTransition = false,
    this.disableHoverEffect = false,
    this.margin,
    this.onDoubleTap,
    this.shortcuts,
    this.actions,
    this.focusOutline = true,
    this.enableFeedback = true,
    this.transform,
    this.onLongPress,
    this.onTapDown,
    this.onTapUp,
    this.onTapCancel,
    this.onSecondaryTapDown,
    this.onSecondaryTapUp,
    this.onSecondaryTapCancel,
    this.onTertiaryTapDown,
    this.onTertiaryTapUp,
    this.onTertiaryTapCancel,
    this.onLongPressStart,
    this.onLongPressUp,
    this.onLongPressMoveUpdate,
    this.onLongPressEnd,
    this.onSecondaryLongPress,
    this.onTertiaryLongPress,
    this.marginAlignment,
    this.disableFocusOutline = false,
  });

  @override
  State<Clickable> createState() => ClickableState();
}

/// Minimum interval between two taps for them to count as a double tap.
const kDoubleTapMinTime = Duration(milliseconds: 300);

/// Minimum interval between two taps for them to count as a double tap.
