// Gallery preview for the `color_input` component: the trigger in light and
// dark, popover and dialog prompts, alpha/history, disabled and themed rows.
// Widgets-only.

import 'package:flutter/widgets.dart';

import '../../foundation/gap.dart';
import '../../primitives/form_core/object_form_field.dart';
import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';
import '../color/color.dart';
import '../eye_dropper/eye_dropper.dart';
import '../history/history.dart';
import 'color_input.dart';

/// Renders the colour-input gallery.
class ColorInputPreview extends StatefulWidget {
  /// Creates the preview.
  const ColorInputPreview({super.key});

  @override
  State<ColorInputPreview> createState() => _ColorInputPreviewState();
}

class _ColorInputPreviewState extends State<ColorInputPreview> {
  ColorDerivative _value = ColorDerivative.fromColor(const Color(0xFF2563EB));

  void _set(ColorDerivative next) => setState(() => _value = next);

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return ColoredBox(
      color: theme.colors.background,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: EyeDropperLayer(
          child: RecentColorsScope(
            initialRecentColors: const <Color>[
              Color(0xFF2563EB),
              Color(0xFF22C55E),
              Color(0xFFE11D48),
            ],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _label(theme, 'Basic (popover on desktop widths)'),
                SizedBox(
                  width: 240,
                  child: ColorInput(value: _value, onChanged: _set),
                ),
                Gap(theme.spacing.xl),
                _label(theme, 'Dialog prompt with a title'),
                SizedBox(
                  width: 240,
                  child: ColorInput(
                    value: _value,
                    mode: PromptMode.dialog,
                    dialogTitle: const Text('Select a colour'),
                    onChanged: _set,
                  ),
                ),
                Gap(theme.spacing.xl),
                _label(theme, 'Alpha + history'),
                SizedBox(
                  width: 240,
                  child: ColorInput(
                    value: _value,
                    showAlpha: true,
                    showHistory: true,
                    onChanged: _set,
                  ),
                ),
                Gap(theme.spacing.xl),
                _label(theme, 'Disabled'),
                SizedBox(width: 240, child: ColorInput(value: _value)),
                Gap(theme.spacing.xl),
                _label(theme, 'Dark palette'),
                ShadcnTheme(
                  data: const ShadcnThemeData(
                    colors: ShadcnColors.darkFallback,
                  ),
                  child: SizedBox(
                    width: 240,
                    child: ColorInput(value: _value, onChanged: _set),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _label(ShadcnThemeData theme, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: theme.colors.foreground,
        ),
      ),
    );
  }
}
