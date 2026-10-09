// The `input_otp` component: [InputOtp], a row of one-character slots driven
// by a single hidden `EditableText`. Ported from `components/form/input_otp/**`
// (1,381 LOC); see README.md ("Fixed bugs").

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../primitives/focus_outline.dart';
import '../../primitives/form_core/form_core.dart';
import '../../primitives/form_core/form_value.dart';
import '../../primitives/text_editing/editable_text_host.dart';
import '../../primitives/text_editing/editable_text_validation.dart';
import '../../primitives/text_editing/text_editing.dart';
import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';
import 'input_otp_style.dart';

export 'input_otp_style.dart';

/// A one-time-password / verification-code input. The code lives in one hidden
/// field; the slots are painted from the string (see README.md).
class InputOtp extends StatefulWidget {
  /// Creates an OTP input.
  const InputOtp({
    super.key,
    required this.length,
    this.controller,
    this.initialValue,
    this.onChanged,
    this.onCompleted,
    this.onSubmitted,
    this.keyboardType = TextInputType.number,
    this.obscureText = false,
    this.readOnly = false,
    this.enabled = true,
    this.autofocus = false,
    this.textCapitalization = TextCapitalization.none,
    this.autofillHints = const <String>[AutofillHints.oneTimeCode],
    this.inputFormatters,
    this.filter,
    this.separator,
    this.separatorEvery,
    this.validator,
    this.autovalidateMode = FormValidationMode.changed,
    this.theme,
  }) : assert(length > 0, 'An OTP input needs at least one slot'),
       assert(separatorEvery == null || separatorEvery > 0, 'positive');

  /// Number of slots.
  final int length;

  /// Controller for the whole code; created internally when null.
  final TextEditingController? controller;

  /// Initial code; ignored when [controller] is given.
  final String? initialValue;

  /// Called with the whole code whenever it changes.
  final ValueChanged<String>? onChanged;

  /// Called once, the first time every slot is filled.
  final ValueChanged<String>? onCompleted;

  /// Called when the field is submitted (Enter / the platform action).
  final ValueChanged<String>? onSubmitted;

  /// Keyboard type; digits by default.
  final TextInputType keyboardType;

  /// Whether each character is replaced by a dot.
  final bool obscureText;

  /// Whether the code can be edited.
  final bool readOnly;

  /// Whether the field accepts input; a disabled field is dimmed to 50%.
  final bool enabled;

  // `autofocus`, `textCapitalization`, `autofillHints` and `inputFormatters`
  // pass straight through to the hidden field; README.md lists their defaults.
  final bool autofocus;
  final TextCapitalization textCapitalization;
  final Iterable<String>? autofillHints;
  final List<TextInputFormatter>? inputFormatters;

  /// Rejects a character when it returns false. Null accepts everything.
  final bool Function(String character)? filter;

  /// Widget drawn after every [separatorEvery] slots; needs [separatorEvery].
  final Widget? separator;

  /// Slots between two separators.
  final int? separatorEvery;

  /// Validation of the whole code; a non-null result shows it below the row.
  /// Receives `null` until every slot is filled.
  final String? Function(String? code)? validator;

  /// When [validator] runs: `initial` on mount, `changed` on every change,
  /// `submitted` on submit; all three also when [validator] itself changes.
  final FormValidationMode autovalidateMode;

  /// Widget-leg theme override, merged on top of the other legs.
  final InputOtpTheme? theme;

  @override
  State<InputOtp> createState() => _InputOtpState();
}

class _InputOtpState extends State<InputOtp>
    with FormValueSupplier<String, InputOtp> {
  late EditableTextHost _host;
  late EditableTextValidation _validation;
  late InputOtpTheme _resolved;
  String _reported = '';
  bool _completed = false;

  TextEditingController get _controller => _host.controller;

  String get _code => _controller.text;

  @override
  void initState() {
    super.initState();
    _host = EditableTextHost(
      controller: widget.controller,
      initialValue: widget.initialValue,
      enabled: widget.enabled,
      onControllerChanged: _handleChanged,
      onStatesChanged: () => setState(() {}),
    );
    _completed = _isComplete;
    _reported = _code;
    _validation = EditableTextValidation(
      text: () => _code,
      validator: widget.validator,
      mode: widget.autovalidateMode,
    )..validateInitial();
    formValue = _code;
  }

  @override
  void didUpdateWidget(covariant InputOtp oldWidget) {
    super.didUpdateWidget(oldWidget);
    _host.update(
      controller: widget.controller,
      focusNode: null,
      statesController: null,
      enabled: widget.enabled,
    );
    if (widget.validator != oldWidget.validator ||
        widget.autovalidateMode != oldWidget.autovalidateMode) {
      _validation.update(
        validator: widget.validator,
        mode: widget.autovalidateMode,
      );
      // `onChanged` only fires in `changed` mode, so an `initial` mode that
      // arrives with a late validator would never run at all.
      if (widget.autovalidateMode == FormValidationMode.initial) {
        _validation.validateNow();
      }
      _validation.onChanged();
    }
    if (widget.length != oldWidget.length) {
      _clampCode();
    }
  }

  @override
  void dispose() {
    _host.dispose();
    super.dispose();
  }

  bool get _isComplete => _code.length == widget.length;

  /// Host controller listener: one call per reported change. A notification also
  /// fires for a selection-only change (focus selects offset 0).
  void _handleChanged() {
    final String code = _code;
    if (code == _reported) return;
    _reported = code;
    _clampCode();
    _validation.onChanged();
    formValue = _code;
    widget.onChanged?.call(_code);
    // The edge fires once; the old `val.every(...)` check re-fired it.
    if (_isComplete && !_completed) {
      _completed = true;
      widget.onCompleted?.call(_code);
    } else if (!_isComplete) {
      _completed = false;
    }
    setState(() {});
  }

  /// Keeps the code inside `[0, length]` and drops rejected characters.
  /// Filtering runs before truncating; the reverse order dropped valid
  /// characters behind the last rejected one.
  void _clampCode() {
    final String code = _code;
    if (code.isEmpty) return;
    String next = code;
    final bool Function(String)? filter = widget.filter;
    if (filter != null) {
      // Runes, so a surrogate pair stays one slot.
      next = String.fromCharCodes(
        next.runes.where((int rune) => filter(String.fromCharCode(rune))),
      );
    }
    if (next.length > widget.length) {
      next = next.substring(0, widget.length);
    }
    if (next != code) {
      _controller.value = TextEditingValue(
        text: next,
        selection: TextSelection.collapsed(offset: next.length),
      );
    }
  }

  /// A form asked for a different value: it must reach the slots.
  @override
  void didReplaceFormValue(String value) {
    // `_reported` is left alone: the listener must see a fresh change.
    _controller.text = value;
  }

  /// The real field: transparent, single line, on top of the painted row. It has
  /// no `onChanged`: the host listener already reports every edit once.
  Widget _hiddenField(ShadcnThemeData theme) => Positioned.fill(
    child: Opacity(
      opacity: 0,
      child: EditableText(
        key: _host.editableTextKey,
        controller: _controller,
        focusNode: _host.focusNode,
        readOnly: widget.readOnly || !widget.enabled,
        autofocus: widget.autofocus,
        keyboardType: widget.keyboardType,
        textCapitalization: widget.textCapitalization,
        autofillHints: widget.autofillHints,
        maxLines: 1,
        showCursor: true,
        cursorColor:
            _resolved.cursorColor?.resolve(theme.colors) ?? theme.colors.ring,
        backgroundCursorColor: theme.colors.border,
        // Never painted: this field sits inside an `Opacity(0)`.
        style: const TextStyle(height: 0.01),
        inputFormatters: widget.inputFormatters,
        selectionControls: ShadcnSelectionControls(),
        contextMenuBuilder: defaultShadcnContextMenuBuilder,
        onSubmitted: _submit,
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    _resolved = resolveComponentStyle<InputOtpTheme, InputOtpTheme>(
      context,
      widget: widget.theme,
      select: (t) => t,
      defaults: inputOtpDefaults,
    );
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    final double box = _resolved.boxSize ?? 36;
    final double gap = _resolved.spacing ?? theme.density.baseGap;
    final int caret =
        _host.focusNode.hasFocus && _host.controller.selection.isValid
        ? _host.controller.selection.baseOffset.clamp(0, widget.length)
        : -1;

    final List<int> runes = _code.runes.toList();
    final int every = widget.separatorEvery ?? 0;
    final Widget? separator = widget.separator;
    final bool obscure = widget.obscureText;
    final List<Widget> children = <Widget>[];
    for (int i = 0; i < widget.length; i++) {
      if (i > 0) {
        children.add(
          separator != null && every > 0 && i % every == 0
              ? _separator(theme, gap)
              : SizedBox(width: gap),
        );
      }
      final String character = i < runes.length
          ? String.fromCharCode(runes[i])
          : '';
      children.add(
        _slot(
          context,
          size: box,
          character: obscure && character.isNotEmpty ? '•' : character,
          focused: caret == i,
          enabled: widget.enabled,
          theme: _resolved,
        ),
      );
    }

    final Widget field = Stack(
      clipBehavior: Clip.none,
      children: <Widget>[
        Row(mainAxisSize: MainAxisSize.min, children: children),
        _hiddenField(theme),
      ],
    );

    final Widget row = Semantics(
      enabled: widget.enabled,
      child: Opacity(
        opacity: widget.enabled ? 1 : 0.5,
        child: IgnorePointer(ignoring: !widget.enabled, child: field),
      ),
    );
    final String? error = _isComplete ? _validation.errorText : null;
    return error == null ? row : _withError(row, error, theme);
  }

  Widget _withError(Widget row, String error, ShadcnThemeData theme) => Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      row,
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

  void _submit(String value) {
    widget.onSubmitted?.call(value);
    // `submitted` has no other trigger.
    if (widget.autovalidateMode == FormValidationMode.submitted) {
      _validation.validateNow();
      setState(() {});
    }
    _host.focusNode.unfocus();
  }

  Widget _separator(ShadcnThemeData theme, double gap) => Padding(
    padding: EdgeInsets.symmetric(horizontal: gap / 2),
    child: Text(
      '-',
      style: _resolved.separatorTextStyle ?? theme.typography.base,
    ),
  );
}

Widget _slot(
  BuildContext context, {
  required double size,
  required String character,
  required bool focused,
  required bool enabled,
  required InputOtpTheme theme,
}) {
  final ShadcnThemeData appTheme = ShadcnTheme.of(context);
  final Set<WidgetState> states = <WidgetState>{
    if (focused) WidgetState.focused,
    if (!enabled) WidgetState.disabled,
  };
  Color? colorFor(StateValue<ThemedColor>? value) =>
      value?.resolve(states)?.resolve(appTheme.colors);
  final Color? border = colorFor(theme.borderColor);
  final BorderRadius radius = (theme.borderRadius ?? appTheme.borderRadiusMd)
      .resolve(Directionality.of(context));
  final Border? box = border == null
      ? null
      : Border.all(color: border, width: theme.borderWidth ?? 1);
  return FocusOutline(
    focused: focused,
    borderRadius: radius,
    child: Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      padding: theme.padding,
      decoration: BoxDecoration(
        color: colorFor(theme.background),
        border: box,
        borderRadius: radius,
      ),
      child: Text(
        character,
        style: (theme.textStyle ?? const TextStyle()).copyWith(
          color: appTheme.colors.foreground,
        ),
      ),
    ),
  );
}
