// The `input` component: a widgets-only text field built on `EditableText`.
//
// The reusable machinery lives in `primitives/text_editing/` (host, shell,
// gesture detector, validation) and `primitives/input_features/` (feature
// framework and concrete features); this file is only the public widget and
// its state wiring. `input` never imports `autocomplete`: suggestions go
// through the generic feature slot.

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../primitives/form_core/form_core.dart';
import '../../primitives/form_core/form_value.dart';
import '../../primitives/input_features/adornment_features.dart';
import '../../primitives/input_features/feature_layout.dart';
import '../../primitives/input_features/input_feature_host.dart';
import '../../primitives/input_features/input_features.dart';
import '../../primitives/text_editing/editable_text_host.dart';
import '../../primitives/text_editing/editable_text_shell.dart';
import '../../primitives/text_editing/editable_text_validation.dart';
import '../../primitives/text_editing/text_editing.dart';
import 'input_style.dart';

export 'input_style.dart';

/// A single-line (or multi-line) text field.
///
/// ```dart
/// Input(
///   hintText: 'Email',
///   features: const <InputFeature>[InputClearFeature()],
/// );
/// ```
class Input extends StatefulWidget {
  /// Creates an input.
  ///
  /// [initialValue] and [controller] are mutually exclusive. [validator] runs
  /// per [autovalidateMode]; a non-null result paints a destructive border and
  /// shows the message below the field.
  const Input({
    super.key,
    this.controller,
    this.initialValue,
    this.focusNode,
    this.undoController,
    this.statesController,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.style,
    this.placeholder,
    this.hintText,
    this.textAlign = TextAlign.start,
    this.maxLines = 1,
    this.minLines,
    this.expands = false,
    this.maxLength,
    this.maxLengthEnforcement,
    this.obscureText = false,
    this.obscuringCharacter = '•',
    this.readOnly = false,
    this.enabled = true,
    this.autofocus = false,
    this.autocorrect = true,
    this.enableSuggestions = true,
    this.inputFormatters,
    this.autofillHints,
    this.cursorColor,
    this.cursorWidth = 2.0,
    this.cursorHeight,
    this.cursorRadius,
    this.scrollPadding = const EdgeInsets.all(20),
    this.onChanged,
    this.onEditingComplete,
    this.onSubmitted,
    this.onTapOutside,
    this.selectionControls,
    this.contextMenuBuilder,
    this.decoration,
    this.border,
    this.borderRadius,
    this.filled,
    this.padding,
    this.features = const <InputFeature>[],
    this.validator,
    this.autovalidateMode = FormValidationMode.changed,
    this.groupId = EditableText,
    this.theme,
  });

  final TextEditingController? controller;
  final String? initialValue;
  final FocusNode? focusNode;
  final UndoHistoryController? undoController;
  final WidgetStatesController? statesController;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final TextStyle? style;
  final Widget? placeholder;
  final String? hintText;
  final TextAlign textAlign;
  final int? maxLines;
  final int? minLines;
  final bool expands;
  final int? maxLength;
  final MaxLengthEnforcement? maxLengthEnforcement;
  final bool obscureText;
  final String obscuringCharacter;
  final bool readOnly;
  final bool enabled;
  final bool autofocus;
  final bool autocorrect;
  final bool enableSuggestions;
  final List<TextInputFormatter>? inputFormatters;
  final Iterable<String>? autofillHints;
  final Color? cursorColor;
  final double cursorWidth;
  final double? cursorHeight;
  final Radius? cursorRadius;
  final EdgeInsets scrollPadding;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onSubmitted;
  final TapRegionCallback? onTapOutside;
  final TextSelectionControls? selectionControls;
  final EditableTextContextMenuBuilder? contextMenuBuilder;
  final BoxDecoration? decoration;
  final Border? border;
  final BorderRadiusGeometry? borderRadius;
  final bool? filled;
  final EdgeInsetsGeometry? padding;
  final List<InputFeature> features;
  final String? Function(String? value)? validator;
  final FormValidationMode autovalidateMode;
  final Object groupId;
  final InputTheme? theme;

  @override
  State<Input> createState() => _InputState();
}

class _InputState extends State<Input>
    with FormValueSupplier<String, Input>, InputFeatureHostState<Input> {
  late final EditableTextHost _host;
  late final EditableTextValidation _validation;
  final InputFeatureSlots _slots = InputFeatureSlots();

  String _lastText = '';
  bool? _obscureOverride;

  TextEditingController get _controller => _host.controller;
  FocusNode get _focusNode => _host.focusNode;
  WidgetStatesController get _states => _host.states;

  @override
  EditableTextHost get editingHost => _host;

  @override
  InputFeatureSlots get featureSlots => _slots;

  @override
  bool? get obscureOverride => _obscureOverride;

  @override
  void setObscureOverride(bool? value) =>
      setState(() => _obscureOverride = value);

  @override
  bool get widgetObscureText => widget.obscureText;

  @override
  void validateNow() => setState(_validation.validateNow);

  @override
  void initState() {
    super.initState();
    assert(
      !(widget.controller != null && widget.initialValue != null),
      'Input cannot have both a controller and an initialValue',
    );
    _host = EditableTextHost(
      controller: widget.controller,
      initialValue: widget.initialValue,
      focusNode: widget.focusNode,
      statesController: widget.statesController,
      enabled: widget.enabled,
      onControllerChanged: _handleControllerChanged,
      onStatesChanged: () => setState(() {}),
    );
    _validation = EditableTextValidation(
      text: () => _controller.text,
      validator: widget.validator,
      mode: widget.autovalidateMode,
    )..validateInitial();
    _lastText = _controller.text;
    formValue = _lastText.isEmpty ? null : _lastText;
  }

  @override
  void didUpdateWidget(covariant Input oldWidget) {
    super.didUpdateWidget(oldWidget);
    _host.update(
      controller: widget.controller,
      focusNode: widget.focusNode,
      statesController: widget.statesController,
      enabled: widget.enabled,
    );
    if (widget.obscureText != oldWidget.obscureText) {
      _obscureOverride = null;
    }
    _slots.sync(
      state: this,
      oldFeatures: oldWidget.features,
      newFeatures: widget.features,
    );
    if (widget.validator != oldWidget.validator ||
        widget.autovalidateMode != oldWidget.autovalidateMode) {
      _validation.update(
        validator: widget.validator,
        mode: widget.autovalidateMode,
      );
      _validation.onChanged();
    }
  }

  @override
  void dispose() {
    for (final feature in widget.features) {
      feature.dispose(this);
    }
    _host.dispose();
    super.dispose();
  }

  void _handleControllerChanged() {
    final value = _controller.value;
    if (value.text != _lastText) {
      _applyTextChange(value.text);
    }
    setState(() {});
  }

  void _handleTextChanged(String value) {
    if (value != _lastText) {
      _applyTextChange(value);
    }
    widget.onChanged?.call(value);
    setState(() {});
  }

  void _applyTextChange(String text) {
    _lastText = text;
    formValue = text.isEmpty ? null : text;
    _validation.onChanged();
    for (final feature in widget.features) {
      feature.onTextChanged(this, text);
    }
  }

  @override
  void didReplaceFormValue(String value) {
    _controller.text = value;
    widget.onChanged?.call(value);
  }

  @override
  Widget build(BuildContext context) {
    final bool enabled = widget.enabled;
    final bool focused = _focusNode.hasFocus;
    final String? errorText = _validation.errorText;
    final InputSurface surface = resolveInputSurface(
      context,
      widgetTheme: widget.theme,
      errorText: errorText,
      states: _states.value,
      style: widget.style,
      cursorColor: widget.cursorColor,
      decoration: widget.decoration,
      border: widget.border,
      borderRadius: widget.borderRadius,
      filled: widget.filled,
      padding: widget.padding,
    );
    final InputFeatureLayout layout = collectInputFeatures(
      state: this,
      context: context,
      features: widget.features,
    );
    final actions = buildInputActions(_host)..addAll(layout.actions);
    final editable = EditableText(
      key: _host.editableTextKey,
      controller: _controller,
      undoController: widget.undoController,
      focusNode: _focusNode,
      readOnly: widget.readOnly || !enabled,
      obscureText: _obscureOverride ?? widget.obscureText,
      obscuringCharacter: widget.obscuringCharacter,
      autocorrect: widget.autocorrect,
      enableSuggestions: widget.enableSuggestions,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      textCapitalization: widget.textCapitalization,
      textAlign: widget.textAlign,
      maxLines: widget.maxLines,
      minLines: widget.minLines,
      expands: widget.expands,
      autofocus: widget.autofocus,
      autofillHints: widget.autofillHints,
      inputFormatters: _host.formatters(
        inputFormatters: widget.inputFormatters,
        maxLength: widget.maxLength,
        maxLengthEnforcement: widget.maxLengthEnforcement,
      ),
      style: surface.textStyle,
      cursorColor: surface.cursorColor,
      cursorWidth: widget.cursorWidth,
      cursorHeight: widget.cursorHeight,
      cursorRadius: widget.cursorRadius,
      backgroundCursorColor: surface.backgroundCursorColor,
      scrollPadding: widget.scrollPadding,
      selectionColor: focused ? surface.selectionColor : null,
      selectionControls: widget.selectionControls ?? ShadcnSelectionControls(),
      contextMenuBuilder:
          widget.contextMenuBuilder ?? defaultShadcnContextMenuBuilder,
      onChanged: _handleTextChanged,
      onEditingComplete: () {
        widget.onEditingComplete?.call();
        _validation.validateNow();
      },
      onSubmitted: (value) {
        widget.onSubmitted?.call(value);
        _validation.validateNow();
      },
      onTapOutside: widget.onTapOutside,
      groupId: widget.groupId,
      // Taps/selection are handled by the gesture detector in the shell.
      rendererIgnoresPointer: true,
    );

    Widget field = EditableTextShell(
      decoration: surface.decoration,
      borderRadius: surface.borderRadius,
      padding: surface.padding,
      gestureBuilder: _host.gestureBuilder,
      focused: focused,
      enabled: enabled,
      minHeight: surface.minHeight,
      errorText: errorText,
      errorStyle: surface.errorStyle,
      gap: surface.gap,
      onHover: (hovered) => _states.update(WidgetState.hovered, hovered),
      child: EditableTextFieldRow(
        editable: editable,
        showPlaceholder: _controller.text.isEmpty,
        placeholder: widget.placeholder,
        hintText: widget.hintText,
        hintStyle: surface.hintStyle,
        textAlign: widget.textAlign,
        maxLines: widget.maxLines,
        leading: layout.leading,
        trailing: layout.trailing,
        gap: surface.gap,
      ),
    );

    for (final feature in widget.features) {
      if (!feature.visibility.canShow(this)) {
        continue;
      }
      field = feature.wrap(this, field);
    }

    return Actions(
      actions: actions,
      child: Shortcuts(shortcuts: layout.shortcuts, child: field),
    );
  }
}
