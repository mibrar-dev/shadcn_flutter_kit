part of '../../text_field.dart';

/// _HasSelectionInputFeatureVisibility renders form UI and wires input behavior.
class _HasSelectionInputFeatureVisibility extends InputFeatureVisibility {
  const _HasSelectionInputFeatureVisibility();
  @override
  Iterable<Listenable> getDependencies(TextFieldState state) sync* {
    yield state._effectiveSelection;
  }

  /// Performs `canShow` logic for this form component.
  @override
  bool canShow(TextFieldState state) {
    var selection = state._effectiveSelection.value;
    return selection.isValid && selection.start != selection.end;
  }
}
