part of '../../text_field.dart';

/// _TextFieldSelectionGestureDetectorBuilder represents a form-related type in the registry.
class _TextFieldSelectionGestureDetectorBuilder
    extends TextSelectionGestureDetectorBuilder {
  _TextFieldSelectionGestureDetectorBuilder({required TextFieldState state})
    : _state = state,
      super(delegate: state);

  final TextFieldState _state;

  /// Performs `onSingleTapUp` logic for this form component.
  @override
  void onSingleTapUp(TapDragUpDetails details) {
    // Because TextSelectionGestureDetector listens to taps that happen on
    // widgets in front of it, tapping the clear button will also trigger
    // this handler. If the clear button widget recognizes the up event,
    // then do not handle it.
    if (_state._clearGlobalKey.currentContext != null) {
      final RenderBox renderBox =
          _state._clearGlobalKey.currentContext!.findRenderObject()!
              as RenderBox;
      final Offset localOffset = renderBox.globalToLocal(
        details.globalPosition,
      );
      if (renderBox.hitTest(BoxHitTestResult(), position: localOffset)) {
        return;
      }
    }
    super.onSingleTapUp(details);
    _state.widget.onTap?.call();
  }

  /// Performs `onDragSelectionEnd` logic for this form component.
  @override
  void onDragSelectionEnd(TapDragEndDetails details) {
    _state._requestKeyboard();
    super.onDragSelectionEnd(details);
  }
}
