part of '../../text_field.dart';

/// _NeverVisibleInputFeatureVisibility renders form UI and wires input behavior.
class _NeverVisibleInputFeatureVisibility extends InputFeatureVisibility {
  const _NeverVisibleInputFeatureVisibility();
  @override
  Iterable<Listenable> getDependencies(TextFieldState state) sync* {}

  /// Performs `canShow` logic for this form component.
  @override
  bool canShow(TextFieldState state) => false;
}
