// Named examples for the `color_picker` component (P6-F3 preview contract).
//
// One focused demo per example; the first entry is the default. Spacing comes
// from the ambient theme, so the examples follow the selected preset and the
// site light/dark toggle.
//
// The picker runs inside its own [SingleChildScrollView] (it is taller than
// the 420px stage when the alpha row and the mode row are both shown) and
// inside the scopes it needs in the docs stage.

import 'package:flutter/widgets.dart';

import '../../foundation/component_preview.dart';
import '../color/color.dart';
import '../eye_dropper/eye_dropper.dart';
import '../history/history.dart';
import 'color_picker.dart';

/// The colour every example starts from.
const Color _colorPickerInitial = Color(0xFF2563EB);

/// Recent colours the history button replays.
const List<Color> _colorPickerRecent = <Color>[
  Color(0xFF2563EB),
  Color(0xFF22C55E),
  Color(0xFFE11D48),
];

/// One picker; owns the value it edits.
class _ColorPickerPicker extends StatefulWidget {
  const _ColorPickerPicker({
    this.showAlpha = false,
    this.showHistoryButton = false,
    this.initialMode = ColorPickerMode.rgb,
  });

  final bool showAlpha;
  final bool showHistoryButton;
  final ColorPickerMode initialMode;

  @override
  State<_ColorPickerPicker> createState() => _ColorPickerPickerState();
}

class _ColorPickerPickerState extends State<_ColorPickerPicker> {
  ColorDerivative _value = ColorDerivative.fromColor(_colorPickerInitial);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        width: 280,
        child: EyeDropperLayer(
          child: RecentColorsScope(
            initialRecentColors: _colorPickerRecent,
            child: ColorPicker(
              value: _value,
              showAlpha: widget.showAlpha,
              showHistoryButton: widget.showHistoryButton,
              initialMode: widget.initialMode,
              onChanging: (ColorDerivative value) =>
                  setState(() => _value = value),
              onChanged: (ColorDerivative value) =>
                  setState(() => _value = value),
            ),
          ),
        ),
      ),
    );
  }
}

/// The default vertical picker in RGB mode.
Widget _colorPickerDefault(BuildContext context) => const _ColorPickerPicker();

/// The picker with the alpha row shown.
Widget _colorPickerAlpha(BuildContext context) =>
    const _ColorPickerPicker(showAlpha: true);

/// HSL mode with the recent-colour history.
Widget _colorPickerHsl(BuildContext context) => const _ColorPickerPicker(
  initialMode: ColorPickerMode.hsl,
  showHistoryButton: true,
);

/// HSV mode.
Widget _colorPickerHsv(BuildContext context) =>
    const _ColorPickerPicker(initialMode: ColorPickerMode.hsv);

/// HEX mode.
Widget _colorPickerHex(BuildContext context) =>
    const _ColorPickerPicker(initialMode: ColorPickerMode.hex);

/// Named docs examples for `color_picker`; the first entry is the default.
const List<ComponentPreview> colorPickerPreviews = <ComponentPreview>[
  ComponentPreview('Default', _colorPickerDefault),
  ComponentPreview('With alpha', _colorPickerAlpha),
  ComponentPreview('HSL', _colorPickerHsl),
  ComponentPreview('HSV', _colorPickerHsv),
  ComponentPreview('HEX', _colorPickerHex),
];
