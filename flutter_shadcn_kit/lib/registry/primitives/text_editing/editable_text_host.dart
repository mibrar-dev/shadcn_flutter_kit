// Reusable EditableText machinery shared by text-entry components.
//
// [EditableTextHost] owns the controller/focus/state objects, listener wiring
// and the widgets-only gesture detector; [EditableTextShell] paints the
// standard field surface; [EditableTextFieldRow] lays out leading/trailing
// adornments around the editable text. Nothing here knows about any component
// theme, so `text_area`, `number_input`, `formatted_input` and `autocomplete`
// can reuse it.

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../foundation/gap.dart';
import '../focus_outline.dart';

/// Owns the controller/focus/state objects and gesture wiring for one
/// EditableText wrapper.
///
/// External [controller]/[focusNode]/[statesController] are used as-is;
/// otherwise the host creates and disposes its own. Call [update] on every
/// `didUpdateWidget` to apply new widget values.
class EditableTextHost implements TextSelectionGestureDetectorBuilderDelegate {
  /// Creates a host.
  ///
  /// [initialValue] seeds the internally created controller only.
  EditableTextHost({
    TextEditingController? controller,
    String? initialValue,
    FocusNode? focusNode,
    WidgetStatesController? statesController,
    bool enabled = true,
    this.onControllerChanged,
    this.onStatesChanged,
  }) : _externalController = controller,
       _externalFocusNode = focusNode,
       _externalStatesController = statesController,
       _enabled = enabled {
    if (controller == null) {
      _ownedController = TextEditingController(text: initialValue);
    }
    if (focusNode == null) {
      _ownedFocusNode = FocusNode(debugLabel: 'EditableTextHost');
    }
    if (statesController == null) {
      _ownedStatesController = WidgetStatesController();
    }
    this.controller.addListener(_handleControllerChanged);
    this.focusNode
      ..addListener(_handleFocusChanged)
      ..canRequestFocus = enabled;
    states
      ..addListener(_handleStatesChanged)
      ..update(WidgetState.disabled, !enabled)
      ..update(WidgetState.focused, this.focusNode.hasFocus);
  }

  /// Called after the effective controller changes (user edits or swaps).
  final VoidCallback? onControllerChanged;

  /// Called after the widget-state set changes (hover/focus/disabled).
  final VoidCallback? onStatesChanged;

  TextEditingController? _externalController;
  TextEditingController? _ownedController;
  FocusNode? _externalFocusNode;
  FocusNode? _ownedFocusNode;
  WidgetStatesController? _externalStatesController;
  WidgetStatesController? _ownedStatesController;
  bool _enabled;

  final GlobalKey<EditableTextState> _editableTextKey =
      GlobalKey<EditableTextState>();

  /// Gesture builder wired to this host; call `buildGestureDetector` from the
  /// field's build.
  late final TextSelectionGestureDetectorBuilder gestureBuilder =
      TextSelectionGestureDetectorBuilder(delegate: this);

  /// The effective text controller.
  TextEditingController get controller =>
      _externalController ?? _ownedController!;

  /// The effective focus node.
  FocusNode get focusNode => _externalFocusNode ?? _ownedFocusNode!;

  /// The effective widget-state controller.
  WidgetStatesController get states =>
      _externalStatesController ?? _ownedStatesController!;

  @override
  GlobalKey<EditableTextState> get editableTextKey => _editableTextKey;

  @override
  bool get forcePressEnabled => false;

  @override
  bool get selectionEnabled => _enabled;

  /// Applies the current widget values, swapping owned/external objects and
  /// updating the disabled state.
  void update({
    required TextEditingController? controller,
    required FocusNode? focusNode,
    required WidgetStatesController? statesController,
    required bool enabled,
  }) {
    _updateController(controller);
    _updateFocusNode(focusNode);
    _updateStatesController(statesController);
    if (_enabled != enabled) {
      _enabled = enabled;
      this.focusNode.canRequestFocus = enabled;
      states.update(WidgetState.disabled, !enabled);
    }
  }

  /// Releases listeners and any objects this host owns.
  void dispose() {
    controller.removeListener(_handleControllerChanged);
    focusNode.removeListener(_handleFocusChanged);
    states.removeListener(_handleStatesChanged);
    _ownedController?.dispose();
    _ownedFocusNode?.dispose();
    _ownedStatesController?.dispose();
  }

  /// Input formatters including the effective `maxLength` limiter.
  List<TextInputFormatter> formatters({
    List<TextInputFormatter>? inputFormatters,
    int? maxLength,
    MaxLengthEnforcement? maxLengthEnforcement,
  }) {
    return <TextInputFormatter>[
      ...?inputFormatters,
      if (maxLength != null)
        LengthLimitingTextInputFormatter(
          maxLength,
          maxLengthEnforcement: maxLengthEnforcement,
        ),
    ];
  }

  /// Appends [value] at the end and moves the caret after it.
  void appendText(String value) {
    final text = controller.text + value;
    controller.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }

  /// Selects everything and copies it to the clipboard.
  void selectAllAndCopy() {
    final text = controller.text;
    controller.selection = TextSelection(
      baseOffset: 0,
      extentOffset: text.length,
    );
    if (text.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: text));
    }
  }

  /// Clears the field text.
  void clear() => controller.clear();

  void _updateController(TextEditingController? next) {
    if (identical(next, _externalController)) {
      return;
    }
    final previous = controller;
    previous.removeListener(_handleControllerChanged);
    _externalController = next;
    if (next != null && _ownedController != null) {
      _ownedController!.dispose();
      _ownedController = null;
    }
    if (next == null && _ownedController == null) {
      _ownedController = TextEditingController(text: previous.text);
    }
    controller.addListener(_handleControllerChanged);
    _handleControllerChanged();
  }

  void _updateFocusNode(FocusNode? next) {
    if (identical(next, _externalFocusNode)) {
      return;
    }
    focusNode.removeListener(_handleFocusChanged);
    _externalFocusNode = next;
    if (next != null && _ownedFocusNode != null) {
      _ownedFocusNode!.dispose();
      _ownedFocusNode = null;
    }
    if (next == null && _ownedFocusNode == null) {
      _ownedFocusNode = FocusNode(debugLabel: 'EditableTextHost');
    }
    focusNode.addListener(_handleFocusChanged);
    focusNode.canRequestFocus = _enabled;
    states.update(WidgetState.focused, focusNode.hasFocus);
  }

  void _updateStatesController(WidgetStatesController? next) {
    if (identical(next, _externalStatesController)) {
      return;
    }
    states.removeListener(_handleStatesChanged);
    _externalStatesController = next;
    if (next != null && _ownedStatesController != null) {
      _ownedStatesController!.dispose();
      _ownedStatesController = null;
    }
    if (next == null && _ownedStatesController == null) {
      _ownedStatesController = WidgetStatesController();
    }
    states.addListener(_handleStatesChanged);
  }

  void _handleControllerChanged() => onControllerChanged?.call();

  void _handleFocusChanged() {
    states.update(WidgetState.focused, focusNode.hasFocus);
  }

  void _handleStatesChanged() => onStatesChanged?.call();
}
