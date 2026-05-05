part of '../../text_field.dart';

/// _InputTrailingFeatureState stores and manages mutable widget state.
class _InputTrailingFeatureState
    extends InputFeatureState<InputTrailingFeature> {
  @override
  Iterable<Widget> buildTrailing() sync* {
    yield feature.suffix;
  }
}
