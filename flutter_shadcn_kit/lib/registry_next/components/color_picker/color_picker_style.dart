// Registry-owned logic for the `color_picker` component: the
// [ColorPickerMode] enum, [ColorPickerTheme]/`colorPickerDefaults` and the
// [ColorPickerControls] row (mode dropdown, fields, buttons).
//
// The flat-folder rule puts the old `color_controls.dart` +
// `_color_value_input.dart` machinery here; `color_picker.dart` owns the pad
// and bars. User-owned overrides live in `color_picker_theme.dart`.

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../primitives/localizations/localizations.dart';
import '../../theme/color_tokens.dart';
import '../../theme/color_utils.dart';
import '../../theme/theme.dart';
import '../color/color.dart';
import '../formatter/formatter.dart';
import '../input/input.dart';

/// Which colour space the picker's numeric fields and pad use: `hsl` drives
/// an HSL saturation/lightness pad, the others the HSV saturation/value pad.
enum ColorPickerMode { rgb, hsl, hsv, hex }

/// Theme data for the `color_picker` component.
///
/// Every field is nullable: an override leg sets only what it changes and
/// [merge] keeps the lower leg's remaining fields. Like `stepper`/`calendar`,
/// there is no `copyWith`/`lerp`: nothing calls them.
class ColorPickerTheme extends ComponentThemeData
    implements Mergeable<ColorPickerTheme> {
  const ColorPickerTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.spacing,
    this.controlSpacing,
    this.orientation,
    this.enableEyeDropper,
    this.sliderSize,
  });

  /// Gap between the picker's major sections (pad/history, controls).
  final double? spacing;

  /// Gap between individual controls (sliders, inputs, buttons).
  final double? controlSpacing;

  /// Stack direction; vertical puts the pad above the fields.
  final Axis? orientation;

  /// Whether the eye-dropper button is shown. The default callback samples
  /// the screen through the nearest `EyeDropperLayer`.
  final bool? enableEyeDropper;

  /// Thickness of the hue and alpha sliders.
  final double? sliderSize;

  /// First-non-null-wins merge; the receiver (higher-priority leg) wins.
  @override
  ColorPickerTheme merge(ColorPickerTheme? fallback) {
    if (fallback == null) {
      return this;
    }
    return ColorPickerTheme(
      themeDensity: themeDensity ?? fallback.themeDensity,
      themeSpacing: themeSpacing ?? fallback.themeSpacing,
      themeShadows: themeShadows ?? fallback.themeShadows,
      spacing: spacing ?? fallback.spacing,
      controlSpacing: controlSpacing ?? fallback.controlSpacing,
      orientation: orientation ?? fallback.orientation,
      enableEyeDropper: enableEyeDropper ?? fallback.enableEyeDropper,
      sliderSize: sliderSize ?? fallback.sliderSize,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is ColorPickerTheme &&
        other.themeDensity == themeDensity &&
        other.themeSpacing == themeSpacing &&
        other.themeShadows == themeShadows &&
        other.spacing == spacing &&
        other.controlSpacing == controlSpacing &&
        other.orientation == orientation &&
        other.enableEyeDropper == enableEyeDropper &&
        other.sliderSize == sliderSize;
  }

  @override
  int get hashCode => Object.hash(
    themeDensity,
    themeSpacing,
    themeShadows,
    spacing,
    controlSpacing,
    orientation,
    enableEyeDropper,
    sliderSize,
  );
}

/// Token-derived defaults (the shadcn look): 12px section gap, 8px control
/// gap, vertical stack, eye dropper on, 24px sliders.
const ColorPickerTheme colorPickerDefaults = ColorPickerTheme(
  spacing: 12,
  controlSpacing: 8,
  orientation: Axis.vertical,
  enableEyeDropper: true,
  sliderSize: 24,
);

/// Builds the live channel fields for [mode]: RGB or HSL/HSV triplets, or a
/// hex field, plus the alpha field when [showAlpha] is set.
///
/// Public because the component folder has a single widget file and
/// `ColorPickerControls` (in `color_picker.dart`) composes the returned rows.
List<Widget> colorPickerFields(
  BuildContext context, {
  required ColorDerivative value,
  required ColorPickerMode mode,
  required bool showAlpha,
  required ValueChanged<ColorDerivative> onChanged,
}) {
  final ShadcnLocalizations l10n = ShadcnLocalizations.of(context);
  if (mode == ColorPickerMode.hex) {
    return <Widget>[
      _ColorChannelField(
        value: colorToHex(value.toColor()),
        placeholder: Text(l10n.colorPickerTabHEX),
        width: 88,
        onChanged: (String next) {
          final ColorDerivative? parsed = ColorDerivative.fromHex(next);
          if (parsed != null) {
            // Keep the current alpha: the old field reset it to opaque.
            onChanged(
              value
                  .changeToColor(parsed.toColor())
                  .changeToOpacity(value.opacity),
            );
          }
        },
      ),
      if (showAlpha) _alphaField(l10n, value, onChanged),
    ];
  }
  if (mode == ColorPickerMode.rgb) {
    return <Widget>[
      _numberField(
        l10n.colorRed,
        value.red.clamp(0, 255).toString(),
        255,
        (double next) => onChanged(value.changeToColorRed(next)),
      ),
      _numberField(
        l10n.colorGreen,
        value.green.clamp(0, 255).toString(),
        255,
        (double next) => onChanged(value.changeToColorGreen(next)),
      ),
      _numberField(
        l10n.colorBlue,
        value.blue.clamp(0, 255).toString(),
        255,
        (double next) => onChanged(value.changeToColorBlue(next)),
      ),
      if (showAlpha) _alphaField(l10n, value, onChanged),
    ];
  }
  final bool hsl = mode == ColorPickerMode.hsl;
  return <Widget>[
    _numberField(
      l10n.colorHue,
      (hsl ? value.hslHue : value.hsvHue).round().toString(),
      360,
      (double next) => onChanged(
        hsl ? value.changeToHSLHue(next) : value.changeToHSVHue(next),
      ),
    ),
    _numberField(
      l10n.colorSaturation,
      ((hsl ? value.hslSat : value.hsvSat) * 100).round().toString(),
      100,
      (double next) => onChanged(
        hsl
            ? value.changeToHSLSaturation(next / 100)
            : value.changeToHSVSaturation(next / 100),
      ),
    ),
    _numberField(
      hsl ? l10n.colorLightness : l10n.colorValue,
      ((hsl ? value.hslVal : value.hsvVal) * 100).round().toString(),
      100,
      (double next) => onChanged(
        hsl
            ? value.changeToHSLLightness(next / 100)
            : value.changeToHSVValue(next / 100),
      ),
    ),
    if (showAlpha) _alphaField(l10n, value, onChanged),
  ];
}

/// One integer channel row with a 0..[max] formatter.
Widget _numberField(
  String label,
  String text,
  int max,
  ValueChanged<double> apply,
) {
  return _ColorChannelField(
    value: text,
    placeholder: Text(label),
    min: 0,
    max: max,
    onChanged: (String next) {
      final double? parsed = double.tryParse(next);
      if (parsed != null) apply(parsed);
    },
  );
}

/// The alpha row; 0-100 in every mode (old RGB/HEX used 0-255).
Widget _alphaField(
  ShadcnLocalizations l10n,
  ColorDerivative value,
  ValueChanged<ColorDerivative> onChanged,
) {
  return _numberField(
    l10n.colorAlpha,
    (value.opacity * 100).round().toString(),
    100,
    (double next) => onChanged(value.changeToOpacity(next / 100)),
  );
}

/// A compact numeric/hex field for one colour channel; external updates are
/// applied only while it is not focused, so a slider drag cannot clobber
/// typing (the old tree gated the sync the same way).
class _ColorChannelField extends StatefulWidget {
  const _ColorChannelField({
    required this.value,
    required this.onChanged,
    required this.placeholder,
    this.min,
    this.max,
    this.width = 64,
  });

  final String value;
  final ValueChanged<String> onChanged;
  final Widget placeholder;
  final int? min;
  final int? max;
  final double width;

  @override
  State<_ColorChannelField> createState() => _ColorChannelFieldState();
}

class _ColorChannelFieldState extends State<_ColorChannelField> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller.text = widget.value;
  }

  @override
  void didUpdateWidget(covariant _ColorChannelField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_focus.hasFocus && _controller.text != widget.value) {
      _controller.text = widget.value;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool numeric = widget.min != null;
    return SizedBox(
      width: widget.width,
      child: Input(
        controller: _controller,
        focusNode: _focus,
        placeholder: widget.placeholder,
        keyboardType: numeric ? TextInputType.number : TextInputType.text,
        inputFormatters: <TextInputFormatter>[
          if (numeric)
            TextInputFormatters.integerOnly(min: widget.min, max: widget.max)
          else
            TextInputFormatters.hex(hashPrefix: true),
        ],
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        onChanged: widget.onChanged,
      ),
    );
  }
}
