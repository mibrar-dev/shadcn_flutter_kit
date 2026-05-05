part of '../../text_field.dart';

/// _InputLeadingFeatureState stores and manages mutable widget state.
class _InputLeadingFeatureState extends InputFeatureState<InputLeadingFeature> {
  @override
  Iterable<Widget> buildLeading() sync* {
    yield feature.prefix;
  }
}
