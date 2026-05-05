part of '../../text_field.dart';

/// _LogicAndInputFeatureVisibility renders form UI and wires input behavior.
class _LogicAndInputFeatureVisibility extends InputFeatureVisibility {
  /// Field storing `features` for this form implementation.
  final Iterable<InputFeatureVisibility> features;
  const _LogicAndInputFeatureVisibility(this.features);
  @override
  Iterable<Listenable> getDependencies(TextFieldState state) sync* {
    for (final feature in features) {
      yield* feature.getDependencies(state);
    }
  }

  /// Performs `canShow` logic for this form component.
  @override
  bool canShow(TextFieldState state) {
    return features.every((feature) => feature.canShow(state));
  }

  /// Compares this object with another for value equality.
  @override
  bool operator ==(Object other) =>
      other is _LogicAndInputFeatureVisibility &&
      other.features.length == features.length &&
      other.features.every((otherFeature) => features.contains(otherFeature));

  /// Flag indicating whether `hashCode` is enabled/active.
  @override
  int get hashCode => features.hashCode;
}
