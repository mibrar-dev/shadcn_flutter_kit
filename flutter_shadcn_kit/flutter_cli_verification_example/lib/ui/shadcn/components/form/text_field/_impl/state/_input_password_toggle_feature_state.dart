part of '../../text_field.dart';

/// _InputPasswordToggleFeatureState stores and manages mutable widget state.
class _InputPasswordToggleFeatureState
    extends InputFeatureState<InputPasswordToggleFeature> {
  bool? _obscureText = true;

  /// Performs `_toggleObscureText` logic for this form component.
  void _toggleObscureText() {
    /// Triggers a rebuild after mutating local state.
    setState(() {
      if (_obscureText == null) {
        _obscureText = true;
      } else {
        _obscureText = null;
      }
    });
  }

  @override
  Iterable<Widget> buildTrailing() sync* {
    if (feature.position == InputFeaturePosition.trailing) {
      yield _buildIconButton();
    }
  }

  @override
  Iterable<Widget> buildLeading() sync* {
    if (feature.position == InputFeaturePosition.leading) {
      yield _buildIconButton();
    }
  }

  /// Performs `_buildIcon` logic for this form component.
  Widget _buildIcon() {
    if (_obscureText == true || input.obscureText) {
      return feature.icon ?? const Icon(LucideIcons.eye);
    }
    return feature.iconShow ?? const Icon(LucideIcons.eyeOff);
  }

  /// Performs `_buildIconButton` logic for this form component.
  Widget _buildIconButton() {
    if (feature.mode == PasswordPeekMode.hold) {
      return IconButton.text(
        icon: _buildIcon(),
        onTapDown: (_) {
          /// Triggers a rebuild after mutating local state.
          setState(() {
            _obscureText = null;
          });
        },
        onTapUp: (_) {
          /// Triggers a rebuild after mutating local state.
          setState(() {
            _obscureText = true;
          });
        },
        enabled: true,
        density: ButtonDensity.compact,
      );
    }
    return IconButton.text(
      icon: _buildIcon(),
      onPressed: _toggleObscureText,
      density: ButtonDensity.compact,
    );
  }

  /// Performs `interceptInput` logic for this form component.
  @override
  TextField interceptInput(TextField input) {
    return input.copyWith(obscureText: () => _obscureText ?? false);
  }
}
