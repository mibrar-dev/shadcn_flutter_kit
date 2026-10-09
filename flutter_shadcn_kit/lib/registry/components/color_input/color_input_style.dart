// Registry-owned theme data for the `color_input` component: the
// [ColorInputTheme] container, the token-derived `colorInputDefaults` and the
// private hex field widget the trigger uses (the flat-folder rule keeps widget
// helpers in the style file, mirroring `color_picker_style.dart`).
//
// User-owned overrides live in `color_input_theme.dart`; CLI updates may
// replace this file. Colours come from global tokens; the picker itself is the
// accepted `color_picker` component, so no picker style is re-declared here.

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../foundation/gap.dart';
import '../../primitives/clickable.dart';
import '../../primitives/form_core/object_form_field.dart';
import '../../primitives/localizations/localizations.dart';
import '../../theme/color_tokens.dart';
import '../../theme/color_utils.dart';
import '../../theme/theme.dart';
import '../color/color.dart';
import '../color_picker/color_picker.dart';
import '../input/input.dart';

/// Behaviour and trigger styling for the `color_input` component.
///
/// Every field is nullable: an override leg sets only what it changes and
/// [merge] keeps the lower leg's remaining fields.
class ColorInputTheme extends ComponentThemeData
    implements Mergeable<ColorInputTheme> {
  /// Creates a colour-input theme.
  const ColorInputTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.mode,
    this.pickerMode,
    this.showAlpha,
    this.enableEyeDropper,
    this.showHistory,
    this.popoverAlignment,
    this.popoverAnchorAlignment,
    this.popoverPadding,
    this.gap,
    this.swatchSize,
    this.swatchBorderRadius,
    this.swatchBorderColor,
  });

  /// Prompt presentation; null resolves popover at 768 px and wider, dialog
  /// below.
  final PromptMode? mode;

  /// Channel mode the picker opens in; null resolves `rgb`.
  final ColorPickerMode? pickerMode;

  /// Whether the picker edits alpha; null resolves true.
  final bool? showAlpha;

  /// Whether the picker offers screen sampling; null resolves true.
  final bool? enableEyeDropper;

  /// Whether the picker's history toggle is shown; null resolves true.
  final bool? showHistory;

  /// Popover placement relative to the trigger; null resolves top-left.
  final AlignmentGeometry? popoverAlignment;

  /// Anchor edge in popover mode; null resolves bottom-left.
  final AlignmentGeometry? popoverAnchorAlignment;

  /// Padding inside the popover surface; null resolves the primitive's 16.
  final EdgeInsetsGeometry? popoverPadding;

  /// Gap between the colour well and the hex field; null resolves 8.
  final double? gap;

  /// Edge length of the colour well; null resolves 36 (shadcn h-9).
  final double? swatchSize;

  /// Corner radius of the well; null resolves the ambient `radiusMd`.
  final BorderRadiusGeometry? swatchBorderRadius;

  /// Well border colour; null resolves the `border` token.
  final ThemedColor? swatchBorderColor;

  /// Returns a copy with the given fields replaced.
  ColorInputTheme copyWith({
    ValueGetter<PromptMode?>? mode,
    ValueGetter<ColorPickerMode?>? pickerMode,
    ValueGetter<bool?>? showAlpha,
    ValueGetter<bool?>? enableEyeDropper,
    ValueGetter<bool?>? showHistory,
    ValueGetter<AlignmentGeometry?>? popoverAlignment,
    ValueGetter<AlignmentGeometry?>? popoverAnchorAlignment,
    ValueGetter<EdgeInsetsGeometry?>? popoverPadding,
    ValueGetter<double?>? gap,
    ValueGetter<double?>? swatchSize,
    ValueGetter<BorderRadiusGeometry?>? swatchBorderRadius,
    ValueGetter<ThemedColor?>? swatchBorderColor,
  }) {
    return ColorInputTheme(
      themeDensity: themeDensity,
      themeSpacing: themeSpacing,
      themeShadows: themeShadows,
      mode: mode == null ? this.mode : mode(),
      pickerMode: pickerMode == null ? this.pickerMode : pickerMode(),
      showAlpha: showAlpha == null ? this.showAlpha : showAlpha(),
      enableEyeDropper: enableEyeDropper == null
          ? this.enableEyeDropper
          : enableEyeDropper(),
      showHistory: showHistory == null ? this.showHistory : showHistory(),
      popoverAlignment: popoverAlignment == null
          ? this.popoverAlignment
          : popoverAlignment(),
      popoverAnchorAlignment: popoverAnchorAlignment == null
          ? this.popoverAnchorAlignment
          : popoverAnchorAlignment(),
      popoverPadding: popoverPadding == null
          ? this.popoverPadding
          : popoverPadding(),
      gap: gap == null ? this.gap : gap(),
      swatchSize: swatchSize == null ? this.swatchSize : swatchSize(),
      swatchBorderRadius: swatchBorderRadius == null
          ? this.swatchBorderRadius
          : swatchBorderRadius(),
      swatchBorderColor: swatchBorderColor == null
          ? this.swatchBorderColor
          : swatchBorderColor(),
    );
  }

  /// First-non-null-wins merge; the receiver (higher-priority leg) wins.
  @override
  ColorInputTheme merge(ColorInputTheme? fallback) {
    if (fallback == null) {
      return this;
    }
    return ColorInputTheme(
      themeDensity: themeDensity ?? fallback.themeDensity,
      themeSpacing: themeSpacing ?? fallback.themeSpacing,
      themeShadows: themeShadows ?? fallback.themeShadows,
      mode: mode ?? fallback.mode,
      pickerMode: pickerMode ?? fallback.pickerMode,
      showAlpha: showAlpha ?? fallback.showAlpha,
      enableEyeDropper: enableEyeDropper ?? fallback.enableEyeDropper,
      showHistory: showHistory ?? fallback.showHistory,
      popoverAlignment: popoverAlignment ?? fallback.popoverAlignment,
      popoverAnchorAlignment:
          popoverAnchorAlignment ?? fallback.popoverAnchorAlignment,
      popoverPadding: popoverPadding ?? fallback.popoverPadding,
      gap: gap ?? fallback.gap,
      swatchSize: swatchSize ?? fallback.swatchSize,
      swatchBorderRadius: swatchBorderRadius ?? fallback.swatchBorderRadius,
      swatchBorderColor: swatchBorderColor ?? fallback.swatchBorderColor,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is ColorInputTheme &&
        other.themeDensity == themeDensity &&
        other.themeSpacing == themeSpacing &&
        other.themeShadows == themeShadows &&
        other.mode == mode &&
        other.pickerMode == pickerMode &&
        other.showAlpha == showAlpha &&
        other.enableEyeDropper == enableEyeDropper &&
        other.showHistory == showHistory &&
        other.popoverAlignment == popoverAlignment &&
        other.popoverAnchorAlignment == popoverAnchorAlignment &&
        other.popoverPadding == popoverPadding &&
        other.gap == gap &&
        other.swatchSize == swatchSize &&
        other.swatchBorderRadius == swatchBorderRadius &&
        other.swatchBorderColor == swatchBorderColor;
  }

  @override
  int get hashCode => Object.hash(
    themeDensity,
    themeSpacing,
    themeShadows,
    mode,
    pickerMode,
    showAlpha,
    enableEyeDropper,
    showHistory,
    popoverAlignment,
    popoverAnchorAlignment,
    popoverPadding,
    gap,
    swatchSize,
    swatchBorderRadius,
    swatchBorderColor,
  );
}

/// Token-derived baseline; every unset override field falls through here.
///
/// The trigger is swatch + hex field, so no `showLabel` row exists: the old
/// flag (swatch-only vs swatch+text) is gone with the trigger redesign.
const ColorInputTheme colorInputDefaults = ColorInputTheme(
  pickerMode: ColorPickerMode.rgb,
  showAlpha: true,
  enableEyeDropper: true,
  showHistory: true,
  popoverAlignment: Alignment.topLeft,
  popoverAnchorAlignment: Alignment.bottomLeft,
  gap: 8,
  swatchSize: 36,
  swatchBorderColor: ThemedColor.ref(ColorRef.border),
);

/// The trigger row of a `ColorInput`: a colour well plus the hex text field.
///
/// Public because the flat component folder has one widget file and
/// [ColorInput] (in `color_input.dart`) composes it — the same split as
/// `colorPickerFields()`; not normally called directly.
Widget colorInputTrigger(
  BuildContext context, {
  required ColorDerivative value,
  required ColorInputTheme style,
  required bool enabled,
  required VoidCallback onPressed,
  required ValueChanged<String> onHexChanged,
}) {
  final ShadcnThemeData theme = ShadcnTheme.of(context);
  final ShadcnLocalizations l10n = ShadcnLocalizations.of(context);
  final double size = style.swatchSize ?? colorInputDefaults.swatchSize!;
  final BorderRadiusGeometry radius =
      style.swatchBorderRadius ?? theme.borderRadiusMd;
  final Color border =
      (style.swatchBorderColor ?? colorInputDefaults.swatchBorderColor!)
          .resolve(theme.colors);
  final bool showAlpha = style.showAlpha ?? colorInputDefaults.showAlpha!;
  return Opacity(
    opacity: enabled ? 1 : 0.5,
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Semantics(
          label: l10n.placeholderColorPicker,
          // The decoration's 1 px border insets its child, so the sized box
          // sits outside the Clickable and the outer edge stays [size].
          child: SizedBox(
            width: size,
            height: size,
            child: Clickable(
              enabled: enabled,
              onPressed: enabled ? onPressed : null,
              mouseCursor: const StateValue<MouseCursor>(
                rest: SystemMouseCursors.click,
                disabled: SystemMouseCursors.basic,
              ),
              decoration: WidgetStateProperty.resolveWith<Decoration?>((
                Set<WidgetState> states,
              ) {
                final bool active =
                    states.contains(WidgetState.hovered) ||
                    states.contains(WidgetState.pressed);
                return BoxDecoration(
                  color: value.toColor(),
                  border: Border.all(
                    color: active ? theme.colors.ring : border,
                  ),
                  borderRadius: radius,
                );
              }),
              child: const SizedBox.expand(),
            ),
          ),
        ),
        Gap(style.gap ?? colorInputDefaults.gap!),
        Expanded(
          child: _HexField(
            value: colorToHex(value.toColor(), showAlpha),
            enabled: enabled,
            onChanged: onHexChanged,
          ),
        ),
      ],
    ),
  );
}

/// The trigger's hex field: an [Input] that accepts only hex characters.
///
/// External updates apply only while it is not focused, so the picker cannot
/// clobber typing; on blur it snaps back to the canonical [value] (the
/// `_ColorChannelField` rule from `color_picker_style.dart`).
class _HexField extends StatefulWidget {
  /// Creates a hex field.
  const _HexField({
    required this.value,
    required this.enabled,
    required this.onChanged,
  });

  /// Canonical hex text for the current colour.
  final String value;

  /// Whether the field accepts input.
  final bool enabled;

  /// Called with the raw text on every edit.
  final ValueChanged<String> onChanged;

  @override
  State<_HexField> createState() => _HexFieldState();
}

class _HexFieldState extends State<_HexField> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focus = FocusNode(debugLabel: 'ColorInputHex');

  @override
  void initState() {
    super.initState();
    _controller.text = widget.value;
    _focus.addListener(_onFocusChanged);
  }

  @override
  void didUpdateWidget(covariant _HexField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_focus.hasFocus && _controller.text != widget.value) {
      _controller.text = widget.value;
    }
  }

  @override
  void dispose() {
    _focus.removeListener(_onFocusChanged);
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _onFocusChanged() {
    if (!_focus.hasFocus && _controller.text != widget.value) {
      setState(() => _controller.text = widget.value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Input(
      controller: _controller,
      focusNode: _focus,
      enabled: widget.enabled,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp('[0-9a-fA-F#]')),
      ],
      onChanged: widget.onChanged,
    );
  }
}
