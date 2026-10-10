// Gallery preview for the `color_field` component: HSV and HSL fields, a hue
// strip, an alpha ramp and a dark palette. Widgets-only.

import 'package:flutter/widgets.dart';

import '../../foundation/gap.dart';
import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';
import 'color_field.dart';

/// Renders the colour-field gallery.
class ColorFieldPreview extends StatelessWidget {
  /// Creates the preview.
  const ColorFieldPreview({super.key});

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return ColoredBox(
      color: theme.colors.background,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _label(theme, 'HSV field and hue strip'),
            SizedBox(
              width: 240,
              height: 140,
              child: ColorField(
                color: const Color(0xFF2563EB),
                saturationAxis: ColorFieldAxis.horizontal,
                valueAxis: ColorFieldAxis.vertical,
              ),
            ),
            Gap(theme.spacing.md),
            SizedBox(
              width: 240,
              height: theme.spacing.xl,
              child: ColorField(
                color: Color(0xFF2563EB),
                hueAxis: ColorFieldAxis.horizontal,
              ),
            ),
            Gap(theme.spacing.xl),
            _label(theme, 'HSL field and alpha ramp'),
            const SizedBox(
              width: 240,
              height: 140,
              child: ColorField(
                color: Color(0x8022C55E),
                mode: ColorFieldMode.hsl,
                saturationAxis: ColorFieldAxis.horizontal,
                lightnessAxis: ColorFieldAxis.vertical,
              ),
            ),
            Gap(theme.spacing.md),
            SizedBox(
              width: 240,
              height: theme.spacing.xl,
              child: ColorField(
                color: Color(0xFF2563EB),
                alphaAxis: ColorFieldAxis.horizontal,
              ),
            ),
            Gap(theme.spacing.xl),
            _label(theme, 'Dark palette'),
            ShadcnTheme(
              data: const ShadcnThemeData(colors: ShadcnColors.darkFallback),
              child: const SizedBox(
                width: 240,
                height: 80,
                child: ColorField(
                  color: Color(0xFF22C55E),
                  hueAxis: ColorFieldAxis.horizontal,
                  saturationAxis: ColorFieldAxis.vertical,
                ),
              ),
            ),
          ],
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
