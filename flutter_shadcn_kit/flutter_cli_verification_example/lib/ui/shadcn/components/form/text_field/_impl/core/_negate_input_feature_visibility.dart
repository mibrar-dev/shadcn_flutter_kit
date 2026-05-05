part of '../../text_field.dart';

/// _NegateInputFeatureVisibility renders form UI and wires input behavior.
class _NegateInputFeatureVisibility extends InputFeatureVisibility {
  /// Field storing `feature` for this form implementation.
  final InputFeatureVisibility feature;
  const _NegateInputFeatureVisibility(this.feature);

  /// Performs `getDependencies` logic for this form component.
  @override
  Iterable<Listenable> getDependencies(TextFieldState state) =>
      feature.getDependencies(state);

  /// Performs `canShow` logic for this form component.
  @override
  bool canShow(TextFieldState state) => !feature.canShow(state);

  /// Compares this object with another for value equality.
  @override
  bool operator ==(Object other) =>
      other is _NegateInputFeatureVisibility && other.feature == feature;

  /// Flag indicating whether `hashCode` is enabled/active.
  @override
  int get hashCode => feature.hashCode;
}
