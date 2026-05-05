part of '../../text_field.dart';

/// _AttachedInputFeature renders form UI and wires input behavior.
class _AttachedInputFeature {
  /// Field storing `feature` for this form implementation.
  InputFeature feature;

  /// Field storing `state` for this form implementation.
  final InputFeatureState state;
  _AttachedInputFeature(this.feature, this.state);
}
