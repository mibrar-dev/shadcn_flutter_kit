// Gallery preview for the `hsl` component: the 1D channel sliders, the 2D
// channel pad, reversed axes and a disabled control, light and dark.

import 'package:flutter/widgets.dart';

import '../../foundation/gap.dart';
import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';
import 'hsl.dart';

/// Renders the HSL slider gallery.
class HSLPreview extends StatefulWidget {
  /// Creates the preview.
  const HSLPreview({super.key});

  @override
  State<HSLPreview> createState() => _HSLPreviewState();
}

class _HSLPreviewState extends State<HSLPreview> {
  HSLColor _hue = HSLColor.fromAHSL(1, 200, 0.6, 0.5);
  HSLColor _pad = HSLColor.fromAHSL(1, 120, 0.8, 0.5);
  HSLColor _alpha = HSLColor.fromAHSL(0.6, 280, 0.5, 0.5);

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return Directionality(
      textDirection: TextDirection.ltr,
      child: DefaultTextStyle(
        style: TextStyle(color: theme.colors.foreground, fontSize: 13),
        child: ColoredBox(
          color: theme.colors.background,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text('Hue'),
                const Gap(8),
                SizedBox(
                  width: 240,
                  height: 24,
                  child: HSLColorSlider(
                    color: _hue,
                    sliderType: HSLColorSliderType.hue,
                    onChanged: (c) => setState(() => _hue = c),
                  ),
                ),
                const Gap(16),
                const Text('Hue × Saturation'),
                const Gap(8),
                SizedBox(
                  width: 160,
                  height: 160,
                  child: HSLColorSlider(
                    color: _pad,
                    sliderType: HSLColorSliderType.hueSat,
                    onChanged: (c) => setState(() => _pad = c),
                  ),
                ),
                const Gap(16),
                const Text('Alpha'),
                const Gap(8),
                SizedBox(
                  width: 240,
                  height: 24,
                  child: HSLColorSlider(
                    color: _alpha,
                    sliderType: HSLColorSliderType.alpha,
                    onChanged: (c) => setState(() => _alpha = c),
                  ),
                ),
                const Gap(16),
                const Text('Disabled hue (vertical bar)'),
                const Gap(8),
                SizedBox(
                  width: 240,
                  height: 24,
                  child: HSLColorSlider(
                    color: _hue,
                    sliderType: HSLColorSliderType.hue,
                    enabled: false,
                    onChanged: (_) {},
                  ),
                ),
                const Gap(16),
                const Text('Reversed, with radius'),
                const Gap(8),
                SizedBox(
                  width: 160,
                  height: 160,
                  child: HSLColorSlider(
                    color: _pad,
                    sliderType: HSLColorSliderType.hueSat,
                    reverse: true,
                    radius: const Radius.circular(8),
                    onChanged: (c) => setState(() => _pad = c),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
