part of '../../text_field.dart';

/// _InputClearFeatureState stores and manages mutable widget state.
class _InputClearFeatureState extends InputFeatureState<InputClearFeature> {
  /// Performs `_clear` logic for this form component.
  void _clear() {
    controller.text = '';
  }

  @override
  Iterable<Widget> buildTrailing() sync* {
    if (feature.position == InputFeaturePosition.trailing) {
      yield IconButton.text(
        icon: feature.icon ?? const Icon(LucideIcons.x),
        onPressed: _clear,
        density: ButtonDensity.compact,
      );
    }
  }

  @override
  Iterable<Widget> buildLeading() sync* {
    if (feature.position == InputFeaturePosition.leading) {
      yield IconButton.text(
        icon: feature.icon ?? const Icon(LucideIcons.x),
        onPressed: _clear,
        density: ButtonDensity.compact,
      );
    }
  }
}
