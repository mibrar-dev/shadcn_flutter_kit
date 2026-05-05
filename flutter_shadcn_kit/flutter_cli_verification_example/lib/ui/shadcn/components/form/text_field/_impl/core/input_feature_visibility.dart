part of '../../text_field.dart';

/// InputFeatureVisibility renders form UI and wires input behavior.
abstract class InputFeatureVisibility {
  /// Creates a visibility condition that is true when all [features] are true.
  const factory InputFeatureVisibility.and(
    Iterable<InputFeatureVisibility> features,
  ) = _LogicAndInputFeatureVisibility;

  /// Creates a visibility condition that is true when any [features] is true.
  const factory InputFeatureVisibility.or(
    Iterable<InputFeatureVisibility> features,
  ) = _LogicOrInputFeatureVisibility;

  /// Creates a visibility condition that inverts the given [feature].
  const factory InputFeatureVisibility.not(InputFeatureVisibility feature) =
      _NegateInputFeatureVisibility;

  /// Visibility condition: text field is not empty.
  static const InputFeatureVisibility textNotEmpty =
      _TextNotEmptyInputFeatureVisibility();

  /// Visibility condition: text field is empty.
  static const InputFeatureVisibility textEmpty =
      _TextEmptyInputFeatureVisibility();

  /// Visibility condition: text field has focus.
  static const InputFeatureVisibility focused =
      _FocusedInputFeatureVisibility();

  /// Visibility condition: text field is being hovered.
  static const InputFeatureVisibility hovered =
      _HoveredInputFeatureVisibility();

  /// Visibility condition: never visible.
  static const InputFeatureVisibility never =
      _NeverVisibleInputFeatureVisibility();

  /// Visibility condition: always visible.
  static const InputFeatureVisibility always =
      _AlwaysVisibleInputFeatureVisibility();

  /// Visibility condition: text field has selected text.
  static const InputFeatureVisibility hasSelection =
      _HasSelectionInputFeatureVisibility();

  /// Creates an [InputFeatureVisibility].
  const InputFeatureVisibility();

  /// Gets the listenable dependencies for this visibility condition.
  ///
  /// Returns the state objects that should be monitored for changes.
  Iterable<Listenable> getDependencies(TextFieldState state);

  /// Checks if the feature can be shown in the current state.
  ///
  /// Returns `true` if all visibility conditions are met.
  bool canShow(TextFieldState state);

  /// Combines this visibility with [other] using logical AND.
  InputFeatureVisibility and(InputFeatureVisibility other) =>
      InputFeatureVisibility.and([this, other]);

  /// Operator form of [and]. Combines conditions with logical AND.
  InputFeatureVisibility operator &(InputFeatureVisibility other) => and(other);

  /// Combines this visibility with [other] using logical OR.
  InputFeatureVisibility or(InputFeatureVisibility other) =>
      InputFeatureVisibility.or([this, other]);

  /// Operator form of [or]. Combines conditions with logical OR.
  InputFeatureVisibility operator |(InputFeatureVisibility other) => or(other);

  /// Inverts this visibility condition using logical NOT.
  InputFeatureVisibility operator ~() => InputFeatureVisibility.not(this);
}

/// Abstract factory for creating input field feature components.
///
/// Provides factory constructors for common text field features like password
/// toggles, clear buttons, hints, autocomplete, and spinners. Features can be
/// conditionally shown based on field state using [InputFeatureVisibility].
///
/// Example:
/// ```dart
/// TextField(
///   leading: [
///     InputFeature.hint(
///       popupBuilder: (context) => Text('Enter email'),
///     ),
///   ],
///   trailing: [
///     InputFeature.clear(),
///     InputFeature.passwordToggle(),
///   ],
/// )
/// ```
