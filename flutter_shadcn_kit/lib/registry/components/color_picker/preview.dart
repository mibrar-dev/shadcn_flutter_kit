// Gallery preview for the `color_picker` component: vertical/horizontal
// layouts, every mode, alpha, history and a dark palette. Widgets-only.

import 'package:flutter/widgets.dart';

import '../../foundation/gap.dart';
import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';
import '../color/color.dart';
import '../eye_dropper/eye_dropper.dart';
import '../history/history.dart';
import 'color_picker.dart';

/// Renders the colour-picker gallery.
class ColorPickerPreview extends StatefulWidget {
  /// Creates the preview.
  const ColorPickerPreview({super.key});

  @override
  State<ColorPickerPreview> createState() => _ColorPickerPreviewState();
}

class _ColorPickerPreviewState extends State<ColorPickerPreview> {
  ColorDerivative _value = ColorDerivative.fromColor(const Color(0xFF2563EB));

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
                _label(theme, 'Vertical, RGB + alpha, history'),
                ColorPicker(
                  value: _value,
                  showAlpha: true,
                  initialMode: ColorPickerMode.rgb,
                  onChanging: (value) => setState(() => _value = value),
                  onChanged: (value) => setState(() => _value = value),
                ),
                const Gap(24),
                _label(theme, 'Horizontal, HSL'),
                ColorPicker(
                  value: _value,
                  initialMode: ColorPickerMode.hsl,
                  showHistoryButton: false,
                  onChanged: (value) => setState(() => _value = value),
                ),
                const Gap(24),
                _label(theme, 'HSV with alpha'),
                ColorPicker(
                  value: _value,
                  initialMode: ColorPickerMode.hsv,
                  showAlpha: true,
                  showHistoryButton: false,
                  onChanged: (value) => setState(() => _value = value),
                ),
                const Gap(24),
                _label(theme, 'HEX'),
                ColorPicker(
                  value: _value,
                  initialMode: ColorPickerMode.hex,
                  showHistoryButton: false,
                  onChanged: (value) => setState(() => _value = value),
                ),
                const Gap(24),
                _label(theme, 'Dark palette'),
                ShadcnTheme(
                  data: const ShadcnThemeData(
                    colors: ShadcnColors.darkFallback,
                  ),
                  child: ColorPicker(
                    value: _value,
                    showAlpha: true,
                    showHistoryButton: false,
                    onChanged: (value) => setState(() => _value = value),
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
