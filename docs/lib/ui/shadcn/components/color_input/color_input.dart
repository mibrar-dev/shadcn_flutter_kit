// The `color_input` component: a compact colour field — a colour well plus a
// hex `Input` — that opens the accepted `ColorPicker` in a popover (desktop)
// or a dialog (small screens).
//
// Reuses `color_picker` (pad, bars, controls, fields, history grid, eye
// dropper), `input` (hex field), `history` (recent colours) and `eye_dropper`
// (screen sampling); the prompt shells are the `form_core` object-field
// presentations. Old bugs fixed, not ported:
//  * committing threw without a `RecentColorsScope` (the old
//    `ColorHistoryStorage.of` lookup) — history is optional now;
//  * the dialog eye-dropper action wrote through the same throwing lookup and
//    the embedded picker's pipette was disabled — one screen-pick path closes
//    the prompt, samples from the trigger context and commits;
//  * the state's `_showHistoryNotifier` was never disposed — the picker owns
//    its history toggle now;
//  * the `placeholder` argument was dead (`value` is required non-null);
//  * `showLabel` is gone: the trigger always shows the well and the hex field.

import 'package:flutter/widgets.dart';

import '../../foundation/captured_wrapper.dart';
import '../../foundation/data.dart';
import '../../primitives/form_core/form_value.dart';
import '../../primitives/form_core/object_form_field.dart';
import '../../primitives/form_core/object_form_prompt.dart';
import '../../primitives/localizations/localizations.dart';
import '../../primitives/overlay.dart';
import '../../primitives/popover_controller.dart';
import '../../theme/theme.dart';
import '../color/color.dart';
import '../color_picker/color_picker.dart';
import '../eye_dropper/eye_dropper.dart';
import '../history/history.dart';
import 'color_input_style.dart';

export 'color_input_style.dart';

/// A compact colour field: a colour well and an editable hex text field.
///
/// Tapping the well (or Enter/Space while it is focused) opens a full
/// [ColorPicker] — in a popover on desktop widths, in a dialog below 768 px —
/// and the hex field edits the value directly. The widget is controlled:
/// [value] is the source of truth and every edit reports through [onChanged]
/// (live drag previews through [onChanging]). It participates in forms as a
/// `ColorDerivative` field.
///
/// ```dart
/// ColorInput(
///   value: ColorDerivative.fromColor(const Color(0xFF2563EB)),
///   showAlpha: true,
///   onChanged: (value) => setState(() => _color = value),
/// )
/// ```
class ColorInput extends StatefulWidget {
  /// Creates a colour input.
  const ColorInput({
    super.key,
    required this.value,
    this.onChanged,
    this.onChanging,
    this.showAlpha,
    this.initialMode,
    this.enableEyeDropper,
    this.showHistory,
    this.mode,
    this.popoverAlignment,
    this.popoverAnchorAlignment,
    this.popoverPadding,
    this.dialogTitle,
    this.enabled,
    this.theme,
  });

  /// The current colour.
  final ColorDerivative value;

  /// Called with every committed colour.
  final ValueChanged<ColorDerivative>? onChanged;

  /// Called while a picker drag is in flight (live preview).
  final ValueChanged<ColorDerivative>? onChanging;

  /// Whether the picker edits alpha; null resolves true.
  final bool? showAlpha;

  /// Channel mode the picker opens in; null resolves `rgb`.
  final ColorPickerMode? initialMode;

  /// Whether the picker offers screen sampling; null resolves true.
  final bool? enableEyeDropper;

  /// Whether the picker's history toggle is shown; null resolves true.
  final bool? showHistory;

  /// Prompt presentation; null resolves popover at 768 px and wider, dialog
  /// below.
  final PromptMode? mode;

  /// Popover placement relative to the trigger; null resolves top-start.
  final AlignmentGeometry? popoverAlignment;

  /// Anchor edge in popover mode; null resolves bottom-start.
  final AlignmentGeometry? popoverAnchorAlignment;

  /// Padding inside the popover surface; null resolves the primitive's 16.
  final EdgeInsetsGeometry? popoverPadding;

  /// Optional heading above the picker in dialog mode.
  final Widget? dialogTitle;

  /// Overrides the enabled state; null means `onChanged != null`.
  final bool? enabled;

  /// Widget-leg style override, merged on top of the component/app/defaults.
  final ColorInputTheme? theme;

  @override
  State<ColorInput> createState() => _ColorInputState();
}

class _ColorInputState extends State<ColorInput>
    with FormValueSupplier<ColorDerivative, ColorInput> {
  final PopoverController _popovers = PopoverController();

  /// Last resolved style; prompt callbacks read it without a context lookup.
  ColorInputTheme _style = colorInputDefaults;

  ColorHistoryStorage? _history;

  bool get _enabled => widget.enabled ?? (widget.onChanged != null);

  @override
  void dispose() {
    _popovers.dispose();
    super.dispose();
  }

  /// Commits [next]: reports to the caller and the form, then to history.
  void _commitColor(ColorDerivative next) {
    widget.onChanged?.call(next);
    formValue = next;
    _history?.addHistory(next.toColor());
  }

  @override
  void didReplaceFormValue(ColorDerivative value) => _commitColor(value);

  /// Applies hex [text]: 3/6 digits keep the current alpha, 8 digits carry
  /// their own (the old field always reset alpha to opaque).
  void _applyHexText(String text) {
    final ColorDerivative? parsed = ColorDerivative.fromHex(text);
    if (parsed == null) {
      return;
    }
    final String digits = text.startsWith('#') ? text.substring(1) : text;
    final ColorDerivative next = widget.value.changeToColor(parsed.toColor());
    _commitColor(
      digits.length == 8 ? next : next.changeToOpacity(widget.value.opacity),
    );
  }

  void _openColorPrompt([ColorDerivative? initial]) {
    if (!_enabled) {
      return;
    }
    final ColorDerivative value = initial ?? widget.value;
    final PromptMode mode =
        _style.mode ??
        ((MediaQuery.maybeSizeOf(context)?.width ?? 0) >= 768
            ? PromptMode.popover
            : PromptMode.dialog);
    if (mode == PromptMode.popover) {
      _presentPopover(value);
    } else {
      _presentDialog(value);
    }
  }

  void _presentPopover(ColorDerivative value) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    _popovers.show<void>(
      context: context,
      alignment:
          _style.popoverAlignment ?? colorInputDefaults.popoverAlignment!,
      anchorAlignment:
          _style.popoverAnchorAlignment ??
          colorInputDefaults.popoverAnchorAlignment!,
      offset: Offset(0, theme.spacing.xs),
      modal: true,
      overlayBarrier: OverlayBarrier(borderRadius: theme.borderRadiusLg),
      builder: (BuildContext context) => ObjectFormPromptPopup<ColorDerivative>(
        initialValue: value,
        popoverPadding: _style.popoverPadding,
        onPrompt: _openColorPrompt,
        onChanged: (ColorDerivative? next) {
          if (next != null) {
            _commitColor(next);
          }
        },
        editorBuilder: _buildEditor,
      ),
    );
  }

  void _presentDialog(ColorDerivative value) {
    final NavigatorState navigator = Navigator.of(context, rootNavigator: true);
    final CapturedThemes themes = InheritedTheme.capture(
      from: context,
      to: navigator.context,
    );
    final CapturedData data = Data.capture(
      from: context,
      to: navigator.context,
    );
    showGeneralDialog<ObjectFormFieldDialogResult<ColorDerivative>>(
      context: context,
      barrierDismissible: true,
      barrierLabel: ShadcnLocalizations.of(context).dialogDismiss,
      barrierColor: const Color(0x80000000),
      transitionDuration: const Duration(milliseconds: 150),
      pageBuilder:
          (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) {
            return CapturedWrapper(
              themes: themes,
              data: data,
              child: ObjectFormPromptDialog<ColorDerivative>(
                initialValue: value,
                dialogTitle: widget.dialogTitle,
                onPrompt: _openColorPrompt,
                // Committed from the dialog result on Save, not per edit.
                onChanged: (ColorDerivative? _) {},
                editorBuilder: _buildEditor,
              ),
            );
          },
      transitionBuilder:
          (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) {
            final Animation<double> curved = CurvedAnimation(
              parent: animation,
              curve: Curves.easeOut,
              reverseCurve: Curves.easeIn,
            );
            return FadeTransition(
              opacity: curved,
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.7, end: 1).animate(curved),
                child: child,
              ),
            );
          },
    ).then((ObjectFormFieldDialogResult<ColorDerivative>? result) {
      final ColorDerivative? committed = result?.value;
      if (mounted && committed != null) {
        _commitColor(committed);
      }
    });
  }

  /// Closes the prompt, samples the screen through the nearest
  /// `EyeDropperLayer`, commits the pick and reopens the prompt with it (the
  /// old dialog flow, now one path for both presentations).
  Future<void> _pickScreenColor(
    ObjectFormHandler<ColorDerivative> handler,
  ) async {
    await handler.close();
    if (!mounted) {
      return;
    }
    final Color? picked = await pickColorFromScreen(context);
    if (!mounted || picked == null) {
      return;
    }
    final ColorDerivative next = widget.value.changeToColor(picked);
    _commitColor(next);
    _openColorPrompt(next);
  }

  /// The picker behind both prompts: the accepted `color_picker` with the
  /// trigger's resolved options.
  ///
  /// The picker's controls row reflows at narrow widths (see `color_picker`),
  /// so the dialog needs no scaling wrapper.
  Widget _buildEditor(
    BuildContext context,
    ObjectFormHandler<ColorDerivative> handler,
  ) {
    return ColorPicker(
      value: handler.value ?? widget.value,
      initialMode: _style.pickerMode ?? colorInputDefaults.pickerMode!,
      showAlpha: _style.showAlpha ?? colorInputDefaults.showAlpha!,
      enableEyeDropper:
          _style.enableEyeDropper ?? colorInputDefaults.enableEyeDropper!,
      showHistoryButton: _style.showHistory ?? colorInputDefaults.showHistory!,
      onEyeDropperRequested: () => _pickScreenColor(handler),
      onChanging: widget.onChanging,
      onChanged: (ColorDerivative next) => handler.value = next,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Report the current value to the nearest form; a no-op without one.
    formValue = widget.value;
    _history = Data.maybeFind<ColorHistoryStorage>(context);
    // Per-widget arguments sit above the `theme` argument (both are widget
    // legs): args > widget theme > tree > app > defaults.
    final ColorInputTheme widgetLeg = ColorInputTheme(
      mode: widget.mode,
      pickerMode: widget.initialMode,
      showAlpha: widget.showAlpha,
      enableEyeDropper: widget.enableEyeDropper,
      showHistory: widget.showHistory,
      popoverAlignment: widget.popoverAlignment,
      popoverAnchorAlignment: widget.popoverAnchorAlignment,
      popoverPadding: widget.popoverPadding,
    );
    final ColorInputTheme style =
        resolveComponentStyle<ColorInputTheme, ColorInputTheme>(
          context,
          widget: widgetLeg.merge(widget.theme),
          select: (t) => t,
          defaults: colorInputDefaults,
        );
    _style = style;
    final bool enabled = _enabled;
    return colorInputTrigger(
      context,
      value: widget.value,
      style: style,
      enabled: enabled,
      onPressed: _openColorPrompt,
      onHexChanged: _applyHexText,
    );
  }
}
