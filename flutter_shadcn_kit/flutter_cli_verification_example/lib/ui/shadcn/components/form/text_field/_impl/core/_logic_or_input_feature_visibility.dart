part of '../../text_field.dart';

/// _LogicOrInputFeatureVisibility renders form UI and wires input behavior.
class _LogicOrInputFeatureVisibility extends InputFeatureVisibility {
  /// Field storing `features` for this form implementation.
  final Iterable<InputFeatureVisibility> features;
  const _LogicOrInputFeatureVisibility(this.features);
  @override
  Iterable<Listenable> getDependencies(TextFieldState state) sync* {
    for (final feature in features) {
      yield* feature.getDependencies(state);
    }
  }

  /// Performs `canShow` logic for this form component.
  @override
  bool canShow(TextFieldState state) {
    return features.any((feature) => feature.canShow(state));
  }

  /// Compares this object with another for value equality.
  @override
  bool operator ==(Object other) =>
      other is _LogicOrInputFeatureVisibility &&
      other.features.length == features.length &&
      other.features.every((otherFeature) => features.contains(otherFeature));

  /// Flag indicating whether `hashCode` is enabled/active.
  @override
  int get hashCode => features.hashCode;
}
