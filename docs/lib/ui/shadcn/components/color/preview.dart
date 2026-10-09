// Gallery preview for the `color` component: the ColorDerivative round
// trip shown as swatches, light and dark.

import 'package:flutter/widgets.dart';

import '../../foundation/gap.dart';
import '../../theme/color_tokens.dart';
import '../../theme/color_utils.dart';
import '../../theme/theme.dart';
import 'color.dart';

/// Renders the color-model gallery.
class ColorPreview extends StatelessWidget {
  /// Creates the preview.
  const ColorPreview({super.key});

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    const base = Color(0xFF0080FF);
    final derivative = ColorDerivative.fromColor(base);
    final muted = derivative.changeToHSVSaturation(0.5);
    final shifted = derivative.changeToHSLHue(280);
    return Directionality(
      textDirection: TextDirection.ltr,
      child: DefaultTextStyle(
        style: TextStyle(color: theme.colors.foreground, fontSize: 13),
        child: ColoredBox(
          color: theme.colors.background,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                _Swatch(
                  label: colorToHex(derivative.toColor()),
                  color: derivative.toColor(),
                ),
                const Gap(12),
                _Swatch(
                  label: colorToHex(muted.toColor()),
                  color: muted.toColor(),
                ),
                const Gap(12),
                _Swatch(
                  label: colorToHex(shifted.toColor()),
                  color: shifted.toColor(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Swatch extends StatelessWidget {
  const _Swatch({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(width: 48, height: 48, color: color),
        const Gap(4),
        Text(label),
      ],
    );
  }
}
