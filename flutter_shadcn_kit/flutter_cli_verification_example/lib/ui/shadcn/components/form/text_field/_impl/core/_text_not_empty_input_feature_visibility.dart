part of '../../text_field.dart';

/// _TextNotEmptyInputFeatureVisibility renders form UI and wires input behavior.
class _TextNotEmptyInputFeatureVisibility extends InputFeatureVisibility {
  const _TextNotEmptyInputFeatureVisibility();
  @override
  Iterable<Listenable> getDependencies(TextFieldState state) sync* {
    yield state._effectiveText;
  }

  /// Performs `canShow` logic for this form component.
  @override
  bool canShow(TextFieldState state) {
    return state._effectiveText.value.isNotEmpty;
  }
}
