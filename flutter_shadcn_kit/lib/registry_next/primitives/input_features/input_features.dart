// The `input` feature framework: positions, visibility conditions, the host
// contract features build against, the base classes and the per-feature slot
// store.
//
// Concrete features live in the sibling files (`adornment_features.dart`,
// `numeric_features.dart`, `suggestion_feature.dart`). `autocomplete` is not
// here: the suggestion slot is widgets/theme-typed only (design §2.2 / I2).

import 'dart:async';

import 'package:flutter/widgets.dart';

import '../../theme/theme.dart';
import '../clickable.dart';

/// Position where an input feature is displayed.
enum InputFeaturePosition {
  /// Before the editable text (start side).
  leading,

  /// After the editable text (end side).
  trailing,

  /// Above the decorated field.
  above,

  /// Below the decorated field.
  below,
}

/// A callback providing suggestions for a query string.
typedef SuggestionBuilder = FutureOr<Iterable<String>> Function(String query);

/// A condition deciding whether an [InputFeature] is shown.
abstract interface class InputFeatureCondition {
  /// Whether the feature should be visible for [state].
  bool canShow(InputFeatureState state);

  /// Logical AND with [other].
  InputFeatureCondition and(InputFeatureCondition other);

  /// Logical OR with [other].
  InputFeatureCondition or(InputFeatureCondition other);

  /// Logical NOT.
  InputFeatureCondition negate();
}

/// Leaf visibility conditions, composable with `&`, `|` and `~`.
enum InputFeatureVisibility implements InputFeatureCondition {
  /// Always visible.
  always,

  /// Never visible.
  never,

  /// Visible while the field has focus.
  focused,

  /// Visible while the pointer hovers the field.
  hovered,

  /// Visible while the field text is empty.
  textEmpty,

  /// Visible while the field text is not empty.
  textNotEmpty,

  /// Visible while the field has a non-collapsed selection.
  hasSelection;

  @override
  bool canShow(InputFeatureState state) => switch (this) {
    InputFeatureVisibility.always => true,
    InputFeatureVisibility.never => false,
    InputFeatureVisibility.focused => state.focused,
    InputFeatureVisibility.hovered => state.hovered,
    InputFeatureVisibility.textEmpty => state.text.isEmpty,
    InputFeatureVisibility.textNotEmpty => state.text.isNotEmpty,
    InputFeatureVisibility.hasSelection =>
      state.selection.isValid && !state.selection.isCollapsed,
  };

  @override
  InputFeatureCondition and(InputFeatureCondition other) =>
      _CompositeCondition((state) => canShow(state) && other.canShow(state));

  @override
  InputFeatureCondition or(InputFeatureCondition other) =>
      _CompositeCondition((state) => canShow(state) || other.canShow(state));

  @override
  InputFeatureCondition negate() =>
      _CompositeCondition((state) => !canShow(state));

  InputFeatureCondition operator &(InputFeatureCondition other) => and(other);

  InputFeatureCondition operator |(InputFeatureCondition other) => or(other);

  InputFeatureCondition operator ~() => negate();
}

class _CompositeCondition implements InputFeatureCondition {
  const _CompositeCondition(this._eval);

  final bool Function(InputFeatureState state) _eval;

  @override
  bool canShow(InputFeatureState state) => _eval(state);

  @override
  InputFeatureCondition and(InputFeatureCondition other) =>
      _CompositeCondition((state) => _eval(state) && other.canShow(state));

  @override
  InputFeatureCondition or(InputFeatureCondition other) =>
      _CompositeCondition((state) => _eval(state) || other.canShow(state));

  @override
  InputFeatureCondition negate() =>
      _CompositeCondition((state) => !_eval(state));
}

/// What a feature sees of its input field.
///
/// Features are stateless descriptors building against this one contract;
/// mutable per-feature state lives in [slot].
abstract class InputFeatureState {
  /// Context of the input widget; safe for popovers and `Actions.invoke`.
  BuildContext get featureContext;

  /// The effective text controller.
  TextEditingController get controller;

  /// Whether the input state is still mounted.
  bool get mounted;

  /// Current text.
  String get text;

  /// Current selection.
  TextSelection get selection;

  /// Whether the field has focus.
  bool get focused;

  /// Whether the pointer hovers the field.
  bool get hovered;

  /// Effective obscure flag (widget value or a password feature override).
  bool get obscureText;

  /// Sets the password override; null falls back to the widget value.
  void setObscureText(bool? value);

  /// Rebuilds the input.
  void setFeatureState(VoidCallback fn);

  /// Runs the widget-leg validator immediately.
  void validateNow();

  /// Per-feature mutable slot, created on first use, disposed with the input.
  T slot<T extends Object>(InputFeature feature, T Function() create);
}

/// One piece of input behaviour or decoration.
abstract class InputFeature {
  /// Creates a feature.
  const InputFeature({
    this.visibility = InputFeatureVisibility.always,
    this.skipFocusTraversal = true,
  });

  /// When the feature is shown.
  final InputFeatureCondition visibility;

  /// Whether the feature is skipped in focus traversal.
  final bool skipFocusTraversal;

  /// Leading widgets contributed while visible.
  Iterable<Widget> buildLeading(
    InputFeatureState state,
    BuildContext context,
  ) => const <Widget>[];

  /// Trailing widgets contributed while visible.
  Iterable<Widget> buildTrailing(
    InputFeatureState state,
    BuildContext context,
  ) => const <Widget>[];

  /// Wraps the decorated field (above/below and suggestion-menu features).
  Widget wrap(InputFeatureState state, Widget child) => child;

  /// Called after the field text changes.
  void onTextChanged(InputFeatureState state, String text) {}

  /// Keyboard shortcuts contributed by this feature.
  Iterable<MapEntry<ShortcutActivator, Intent>> buildShortcuts(
    InputFeatureState state,
  ) => const <MapEntry<ShortcutActivator, Intent>>[];

  /// Actions contributed by this feature.
  Iterable<MapEntry<Type, Action<Intent>>> buildActions(
    InputFeatureState state,
  ) => const <MapEntry<Type, Action<Intent>>>[];

  /// Called when the input is disposed or this feature is removed; dispose
  /// slot state (controllers) here.
  void dispose(InputFeatureState state) {}

  /// Whether [newFeature] can replace [oldFeature] without losing its slot.
  static bool canUpdate(InputFeature oldFeature, InputFeature newFeature) =>
      oldFeature.runtimeType == newFeature.runtimeType;
}

/// Base for features rendered as one small icon button.
abstract class InputIconFeature extends InputFeature {
  /// Creates an icon feature at [position].
  const InputIconFeature({
    this.position = InputFeaturePosition.trailing,
    super.visibility,
    super.skipFocusTraversal,
  });

  /// Where the button is placed.
  final InputFeaturePosition position;

  /// The button icon.
  Widget buildIcon(BuildContext context);

  /// Called when the button is pressed.
  void onPressed(InputFeatureState state, BuildContext context);

  /// The button widget; the password hold mode overrides this.
  Widget buildButton(InputFeatureState state, BuildContext context) {
    // The Builder context sits below the input's `Actions` scope, so button
    // callbacks can `Actions.invoke` the feature intents.
    return Builder(
      builder: (buttonContext) => InputFeatureIconButton(
        icon: buildIcon(buttonContext),
        onPressed: () => onPressed(state, buttonContext),
      ),
    );
  }

  @override
  Iterable<Widget> buildLeading(
    InputFeatureState state,
    BuildContext context,
  ) sync* {
    if (position == InputFeaturePosition.leading) {
      yield buildButton(state, context);
    }
  }

  @override
  Iterable<Widget> buildTrailing(
    InputFeatureState state,
    BuildContext context,
  ) sync* {
    if (position == InputFeaturePosition.trailing) {
      yield buildButton(state, context);
    }
  }
}

/// The shared small icon button used by feature implementations.
class InputFeatureIconButton extends StatelessWidget {
  /// Creates an icon button.
  const InputFeatureIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.onTapDown,
    this.onTapUp,
    this.onTapCancel,
    this.enabled = true,
  });

  final Widget icon;
  final VoidCallback? onPressed;
  final GestureTapDownCallback? onTapDown;
  final GestureTapUpCallback? onTapUp;
  final GestureTapCancelCallback? onTapCancel;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    return Clickable(
      enabled: enabled,
      onPressed: onPressed,
      onTapDown: onTapDown,
      onTapUp: onTapUp,
      onTapCancel: onTapCancel,
      focusOutline: false,
      decoration: WidgetStateProperty.resolveWith<Decoration?>((states) {
        final highlighted =
            states.contains(WidgetState.hovered) ||
            states.contains(WidgetState.pressed);
        return highlighted
            ? BoxDecoration(
                color: theme.colors.accent,
                borderRadius: theme.borderRadiusXs,
              )
            : null;
      }),
      padding: WidgetStatePropertyAll<EdgeInsetsGeometry>(
        EdgeInsets.all(theme.spacing.xs),
      ),
      iconTheme: WidgetStatePropertyAll<IconThemeData>(
        theme.iconTheme.small.copyWith(color: theme.colors.mutedForeground),
      ),
      child: icon,
    );
  }
}

/// Per-feature mutable slots for one field.
///
/// [sync] carries slots over to replacement feature instances at the same
/// index when [InputFeature.canUpdate] holds, and disposes the rest.
class InputFeatureSlots {
  final Map<InputFeature, Object> _slots = <InputFeature, Object>{};

  /// The slot of [feature], created by [create] on first use.
  T slot<T extends Object>(InputFeature feature, T Function() create) {
    final existing = _slots[feature];
    if (existing is T) {
      return existing;
    }
    final created = create();
    _slots[feature] = created;
    return created;
  }

  /// Carries slots to the new feature instances and disposes removed ones.
  void sync({
    required InputFeatureState state,
    required List<InputFeature> oldFeatures,
    required List<InputFeature> newFeatures,
  }) {
    final carried = <InputFeature, Object>{};
    final int count = oldFeatures.length > newFeatures.length
        ? oldFeatures.length
        : newFeatures.length;
    for (var i = 0; i < count; i++) {
      if (i >= oldFeatures.length || i >= newFeatures.length) {
        break;
      }
      final oldFeature = oldFeatures[i];
      final newFeature = newFeatures[i];
      if (!InputFeature.canUpdate(oldFeature, newFeature)) {
        continue;
      }
      final value = _slots.remove(oldFeature);
      if (value != null) {
        carried[newFeature] = value;
      }
    }
    for (final entry in _slots.entries) {
      entry.key.dispose(state);
    }
    _slots
      ..clear()
      ..addAll(carried);
  }
}
