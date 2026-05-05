part of '../../text_field.dart';

/// _HoveredInputFeatureVisibility renders form UI and wires input behavior.
class _HoveredInputFeatureVisibility extends InputFeatureVisibility {
  const _HoveredInputFeatureVisibility();
  @override
  Iterable<Listenable> getDependencies(TextFieldState state) sync* {
    yield state._statesController;
  }

  /// Performs `canShow` logic for this form component.
  @override
  bool canShow(TextFieldState state) {
    return state._statesController.value.hovered;
  }
}
