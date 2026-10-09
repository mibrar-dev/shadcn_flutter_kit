// The `formatted_input` component: a masked/segmented field (phone number,
// date, card number) built from static separators and small editable parts.
//
// Ported from `components/form/formatted_input` (2,084 LOC, 23 files). The old
// tree used `part` files, a `text_field` field per segment, a hand-rolled
// cross-part selection coordinator with dead drag code and `FormKey`-per-part
// form wiring; see README.md "Fixed bugs". The segment machinery now lives in
// `primitives/text_editing/segmented_editing.dart`.

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../primitives/focus_outline.dart';
import '../../primitives/form_core/form_core.dart';
import '../../primitives/form_core/form_value.dart';
import '../../primitives/text_editing/editable_text_validation.dart';
import '../../primitives/text_editing/segmented_editing.dart';
import '../../primitives/text_editing/segmented_value.dart';
import '../../primitives/text_editing/text_editing.dart';
import '../../theme/theme.dart';
import 'formatted_input_style.dart';

export '../../primitives/text_editing/segmented_value.dart'
    show SegmentPart, SegmentedValue;
export 'formatted_input_style.dart';

/// Holds the value of a controller-driven [FormattedInput].
class FormattedInputController extends ValueNotifier<SegmentedValue> {
  /// Creates a controller, empty by default.
  FormattedInputController([super.value = const SegmentedValue()]);
}

/// A field made of static separators and small editable segments.
///
/// Two modes, like `Toggle`: uncontrolled with a [FormattedInputController],
/// or controlled with [value] + [onChanged].
///
/// ```dart
/// FormattedInput(
///   initialValue: const SegmentedValue([
///     SegmentPart.editable(length: 3, width: 28),
///     SegmentPart.separator(') '),
///     SegmentPart.editable(length: 4, width: 36),
///   ]),
/// );
/// ```
class FormattedInput extends StatefulWidget {
  /// Creates a formatted input.
  const FormattedInput({
    super.key,
    this.controller,
    this.initialValue,
    this.value,
    this.onChanged,
    this.leading,
    this.trailing,
    this.enabled = true,
    this.validator,
    this.autovalidateMode = FormValidationMode.changed,
    this.theme,
  }) : assert(
         controller == null || (value == null && onChanged == null),
         'A controller-driven FormattedInput must not also receive value/onChanged',
       );

  /// Uncontrolled mode: the controller owns the value.
  final FormattedInputController? controller;

  /// Initial value; ignored in controlled mode.
  final SegmentedValue? initialValue;

  /// Controlled mode: the current value.
  final SegmentedValue? value;

  /// Controlled mode: called with the next value.
  final ValueChanged<SegmentedValue>? onChanged;

  /// Widget before the parts.
  final Widget? leading;

  /// Widget after the parts.
  final Widget? trailing;

  /// Whether the field accepts input; a disabled field is dimmed to 50%.
  final bool enabled;

  /// Validation of the joined text; a non-null result shows below the field.
  final String? Function(String? text)? validator;

  /// When [validator] runs: `initial`, `changed` (default) or `submitted`.
  final FormValidationMode autovalidateMode;

  /// Widget-leg theme override, merged on top of the other legs.
  final FormattedInputTheme? theme;

  @override
  State<FormattedInput> createState() => _FormattedInputState();
}

class _FormattedInputState extends State<FormattedInput>
    with FormValueSupplier<SegmentedValue, FormattedInput> {
  late SegmentedTextController _segments;
  late EditableTextValidation _validation;
  late SegmentedValue _value;
  List<SegmentPart> _structure = const <SegmentPart>[];
  String? _errorText;
  bool _focused = false;

  /// The value the widget is currently driven by.
  ///
  /// The seed chain includes [FormattedInput.controller] in every mode: reading
  /// only `value`/`initialValue` left the mirror empty in controller mode and
  /// dropped every keystroke.
  SegmentedValue get _source =>
      widget.value ?? widget.controller?.value ?? _value;

  /// The parts the widget is currently declared with. An uncontrolled widget
  /// can swap [FormattedInput.initialValue] to change the shape, which rebuilds
  /// the segments.
  List<SegmentPart> get _incomingParts =>
      widget.value?.parts ??
      widget.controller?.value.parts ??
      widget.initialValue?.parts ??
      _structure;

  SegmentedTextController _createSegments() {
    final List<SegmentPart> editable = _structure
        .where((SegmentPart part) => part.holdsValue)
        .toList();
    final SegmentedTextController segments = SegmentedTextController(
      segments: <TextSegment>[
        for (final SegmentPart part in editable) part.segment,
      ],
      values: <String>[for (final SegmentPart part in editable) part.value],
    );
    for (final FocusNode node in segments.focusNodes) {
      node.addListener(() {
        final bool focused = _segments.focusNodes.any(
          (FocusNode focus) => focus.hasFocus,
        );
        if (focused != _focused && mounted) {
          setState(() => _focused = focused);
        }
      });
    }
    return segments;
  }

  @override
  void initState() {
    super.initState();
    _value =
        widget.value ??
        widget.initialValue ??
        widget.controller?.value ??
        const SegmentedValue();
    _structure = _value.parts;
    _segments = _createSegments();
    _validation = EditableTextValidation(
      text: () => _value.text,
      validator: widget.validator,
      mode: widget.autovalidateMode,
    )..validateInitial();
    _errorText = _validation.errorText;
    widget.controller?.addListener(_handleControllerChanged);
    formValue = _value;
  }

  @override
  void didUpdateWidget(covariant FormattedInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_handleControllerChanged);
      widget.controller?.addListener(_handleControllerChanged);
    }
    final List<SegmentPart> incoming = _incomingParts;
    // Only a shape change rebuilds the segment controllers; a value swap flows
    // through `_setValue` so typing keeps its focus, caret and formatting.
    if (!_value.hasShape(incoming)) {
      _structure = incoming;
      _segments.dispose();
      _segments = _createSegments();
      _value = SegmentedValue(incoming);
      formValue = _value;
      _revalidate();
    }
    final SegmentedValue source = _source;
    if (source != _value) {
      _setValue(source, report: false);
    }
    if (widget.validator != oldWidget.validator ||
        widget.autovalidateMode != oldWidget.autovalidateMode) {
      _validation.update(
        validator: widget.validator,
        mode: widget.autovalidateMode,
      );
      _validation.onChanged();
      if (_errorText != null) {
        _validation.validateNow();
      }
      _errorText = _validation.errorText;
    }
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_handleControllerChanged);
    _segments.dispose();
    super.dispose();
  }

  /// A form asked for a different value.
  @override
  void didReplaceFormValue(SegmentedValue value) => _setValue(value);

  /// Re-runs the validator after a value change.
  ///
  /// [FormValidationMode.changed] revalidates on every keystroke. The other
  /// modes only validate once, which would leave a visible error stuck on
  /// screen while the user fixes the field, so a shown error stays live.
  void _revalidate() {
    _validation.onChanged();
    if (_errorText != null && _validation.mode != FormValidationMode.changed) {
      _validation.validateNow();
    }
    _errorText = _validation.errorText;
  }

  void _setValue(SegmentedValue value, {bool report = true}) {
    if (value == _value) {
      return;
    }
    _value = value;
    _segments.setValues(<String>[
      for (final SegmentPart part in value.values) part.value,
    ], notify: false);
    _revalidate();
    formValue = _value;
    if (report) {
      widget.onChanged?.call(_value);
    }
    setState(() {});
  }

  void _handleChanged(int index, String text) {
    final SegmentedValue next = _value.withValue(index, text);
    if (widget.controller != null) {
      widget.controller!.value = next;
    } else {
      _setValue(next);
    }
  }

  void _handleControllerChanged() {
    final FormattedInputController? controller = widget.controller;
    if (controller != null) {
      _setValue(controller.value, report: false);
    }
  }

  KeyEventResult _handleKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) {
      return KeyEventResult.ignored;
    }
    // The callback runs on the wrapping `Focus` node, so the focused segment is
    // found by focus rather than by node identity.
    final int index = _segments.focusNodes.indexWhere(
      (FocusNode focus) => focus.hasFocus,
    );
    final int delta = switch (event.logicalKey) {
      LogicalKeyboardKey.backspace ||
      LogicalKeyboardKey.arrowLeft => _segments.atStart(index) ? -1 : 0,
      LogicalKeyboardKey.arrowRight => _segments.atEnd(index) ? 1 : 0,
      _ => 0,
    };
    return delta == 0 || !_segments.moveFocus(index, delta)
        ? KeyEventResult.ignored
        : KeyEventResult.handled;
  }

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    final FormattedInputSurface surface = resolveFormattedInputSurface(
      context,
      widgetTheme: widget.theme,
    );
    final List<Widget> children = <Widget>[];
    int segment = 0;
    for (int i = 0; i < _structure.length; i++) {
      final SegmentPart part = _structure[i];
      if (i > 0 && surface.partGap > 0) {
        children.add(SizedBox(width: surface.partGap));
      }
      children.add(
        part.holdsValue
            ? SizedBox(
                width: part.width,
                child: _segment(surface, part, segment++),
              )
            : Text(part.separator ?? '', style: surface.separatorStyle),
      );
    }
    final Widget field = Focus(
      onKeyEvent: _handleKey,
      child: FocusOutline(
        focused: _focused,
        borderRadius: surface.borderRadius,
        child: Container(
          height: surface.height,
          decoration: surface.decoration,
          child: Padding(
            padding: surface.padding,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                if (widget.leading != null) ...<Widget>[
                  widget.leading!,
                  SizedBox(width: surface.leadingGap),
                ],
                ...children,
                if (widget.trailing != null) ...<Widget>[
                  SizedBox(width: surface.leadingGap),
                  widget.trailing!,
                ],
              ],
            ),
          ),
        ),
      ),
    );
    final Widget body = Semantics(
      enabled: widget.enabled,
      child: Opacity(
        opacity: widget.enabled ? 1 : 0.5,
        child: IgnorePointer(ignoring: !widget.enabled, child: field),
      ),
    );
    final String? error = _errorText;
    if (error == null) {
      return body;
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        body,
        Padding(
          padding: EdgeInsets.only(top: theme.spacing.xs),
          child: Text(
            error,
            style: theme.typography.xSmall.copyWith(
              color: theme.colors.destructive,
            ),
          ),
        ),
      ],
    );
  }

  Widget _segment(FormattedInputSurface surface, SegmentPart part, int index) {
    final TextEditingController controller = _segments.controllers[index];
    return Stack(
      alignment: AlignmentDirectional.centerStart,
      children: <Widget>[
        if (controller.text.isEmpty && part.placeholder != null)
          IgnorePointer(
            child: DefaultTextStyle.merge(
              style: surface.placeholderStyle,
              textAlign: TextAlign.center,
              child: part.placeholder!,
            ),
          ),
        EditableText(
          controller: controller,
          focusNode: _segments.focusNodes[index],
          readOnly: !widget.enabled,
          maxLines: 1,
          textAlign: TextAlign.center,
          obscureText: part.obscureText,
          backgroundCursorColor: surface.cursorColor.withValues(alpha: 0.2),
          inputFormatters: part.segment.formatters(),
          style: surface.textStyle,
          cursorColor: surface.cursorColor,
          selectionControls: ShadcnSelectionControls(),
          contextMenuBuilder: defaultShadcnContextMenuBuilder,
          onChanged: (String text) {
            _handleChanged(index, text);
            // A full segment hands over to the next one.
            if (_segments.isFull(index)) {
              _segments.moveFocus(index, 1);
            }
          },
          onSubmitted: (String _) => _segments.moveFocus(index, 1),
        ),
      ],
    );
  }
}
