part of '../../text_field.dart';

/// _InputCopyFeatureState stores and manages mutable widget state.
class _InputCopyFeatureState extends InputFeatureState<InputCopyFeature> {
  /// Performs `_copy` logic for this form component.
  void _copy() {
    Actions.invoke(context, const TextFieldSelectAllAndCopyIntent());
  }

  @override
  Iterable<Widget> buildTrailing() sync* {
    if (feature.position == InputFeaturePosition.trailing) {
      yield IconButton.text(
        icon: feature.icon ?? const Icon(LucideIcons.copy),
        onPressed: _copy,
        density: ButtonDensity.compact,
      );
    }
  }

  @override
  Iterable<Widget> buildLeading() sync* {
    if (feature.position == InputFeaturePosition.leading) {
      yield IconButton.text(
        icon: feature.icon ?? const Icon(LucideIcons.copy),
        onPressed: _copy,
        density: ButtonDensity.compact,
      );
    }
  }
}
