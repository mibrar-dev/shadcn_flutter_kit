// Named examples for the `color_input` component (P6-F3 preview contract).
//
// One focused demo per example; the first entry is the default. Spacing comes
// from the ambient theme, so the examples follow the selected preset and the
// site light/dark toggle.
//
// The trigger is wrapped in the colour scopes it needs to work in the docs
// stage: `EyeDropperLayer` and `RecentColorsScope`.

import 'package:flutter/widgets.dart';

import '../../foundation/component_preview.dart';
import '../../primitives/form_core/object_form_field.dart';
import '../color/color.dart';
import '../eye_dropper/eye_dropper.dart';
import '../history/history.dart';
import 'color_input.dart';

/// One trigger, with the scopes the colour machinery needs.
class _ColorInputColorInputExample extends StatefulWidget {
  const _ColorInputColorInputExample({
    this.mode,
    this.dialogTitle,
    this.showAlpha = false,
    this.showHistory = false,
    this.enabled = true,
  });

  final PromptMode? mode;
  final Widget? dialogTitle;
  final bool showAlpha;
  final bool showHistory;
  final bool enabled;

  @override
  State<_ColorInputColorInputExample> createState() =>
      _ColorInputColorInputExampleState();
}

class _ColorInputColorInputExampleState
    extends State<_ColorInputColorInputExample> {
  ColorDerivative _value = ColorDerivative.fromColor(const Color(0xFF2563EB));

  @override
  Widget build(BuildContext context) {
    return EyeDropperLayer(
      child: RecentColorsScope(
        initialRecentColors: const <Color>[
          Color(0xFF2563EB),
          Color(0xFF22C55E),
          Color(0xFFE11D48),
        ],
        child: SizedBox(
          width: 240,
          child: ColorInput(
            value: _value,
            mode: widget.mode,
            dialogTitle: widget.dialogTitle,
            showAlpha: widget.showAlpha,
            showHistory: widget.showHistory,
            enabled: widget.enabled,
            onChanged: (ColorDerivative next) => setState(() => _value = next),
          ),
        ),
      ),
    );
  }
}

/// The default trigger, with the popover prompt.
Widget _colorInputDefault(BuildContext context) =>
    const _ColorInputColorInputExample();

/// The dialog prompt with a title.
Widget _colorInputDialog(BuildContext context) =>
    const _ColorInputColorInputExample(
      mode: PromptMode.dialog,
      dialogTitle: Text('Select a colour'),
    );

/// Alpha plus the recent-colour history.
Widget _colorInputAlphaHistory(BuildContext context) =>
    const _ColorInputColorInputExample(showAlpha: true, showHistory: true);

/// The disabled trigger.
Widget _colorInputDisabled(BuildContext context) =>
    const _ColorInputColorInputExample(enabled: false);

/// Named docs examples for `color_input`; the first entry is the default.
const List<ComponentPreview> colorInputPreviews = <ComponentPreview>[
  ComponentPreview('Default', _colorInputDefault),
  ComponentPreview('Dialog prompt', _colorInputDialog),
  ComponentPreview('Alpha + history', _colorInputAlphaHistory),
  ComponentPreview('Disabled', _colorInputDisabled),
];
