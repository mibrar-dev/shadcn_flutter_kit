part of '../../text_field.dart';

/// _AlwaysVisibleInputFeatureVisibility renders form UI and wires input behavior.
class _AlwaysVisibleInputFeatureVisibility extends InputFeatureVisibility {
  const _AlwaysVisibleInputFeatureVisibility();
  @override
  Iterable<Listenable> getDependencies(TextFieldState state) sync* {}

  /// Performs `canShow` logic for this form component.
  @override
  bool canShow(TextFieldState state) => true;
}
