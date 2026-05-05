part of '../../text_field.dart';

/// _TextEmptyInputFeatureVisibility renders form UI and wires input behavior.
class _TextEmptyInputFeatureVisibility extends InputFeatureVisibility {
  const _TextEmptyInputFeatureVisibility();
  @override
  Iterable<Listenable> getDependencies(TextFieldState state) sync* {
    yield state._effectiveText;
  }

  /// Performs `canShow` logic for this form component.
  @override
  bool canShow(TextFieldState state) {
    return state._effectiveText.value.isEmpty;
  }
}
