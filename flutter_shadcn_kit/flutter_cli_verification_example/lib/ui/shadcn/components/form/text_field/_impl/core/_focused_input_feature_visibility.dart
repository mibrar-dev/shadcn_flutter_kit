part of '../../text_field.dart';

/// _FocusedInputFeatureVisibility renders form UI and wires input behavior.
class _FocusedInputFeatureVisibility extends InputFeatureVisibility {
  const _FocusedInputFeatureVisibility();
  @override
  Iterable<Listenable> getDependencies(TextFieldState state) sync* {
    yield state._effectiveFocusNode;
  }

  /// Performs `canShow` logic for this form component.
  @override
  bool canShow(TextFieldState state) {
    return state._effectiveFocusNode.hasFocus;
  }
}
