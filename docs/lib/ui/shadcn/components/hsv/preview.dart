// Gallery preview for the `hsv` component: the 1D channel sliders, the 2D
// channel pad, reversed axes and a disabled control, light and dark.

import 'package:flutter/widgets.dart';

import '../../foundation/gap.dart';
import '../../theme/theme.dart';
import 'hsv.dart';

/// Renders the HSV slider gallery.
class HSVPreview extends StatefulWidget {
  /// Creates the preview.
  const HSVPreview({super.key});

  @override
  State<HSVPreview> createState() => _HSVPreviewState();
}

class _HSVPreviewState extends State<HSVPreview> {
  HSVColor _hue = HSVColor.fromAHSV(1, 200, 0.6, 0.5);
  HSVColor _pad = HSVColor.fromAHSV(1, 120, 0.8, 0.5);
  HSVColor _alpha = HSVColor.fromAHSV(0.6, 280, 0.5, 0.5);

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
                  child: HSVColorSlider(
                    color: _hue,
                    sliderType: HSVColorSliderType.hue,
                    onChanged: (c) => setState(() => _hue = c),
                  ),
                ),
                const Gap(16),
                const Text('Hue × Saturation'),
                const Gap(8),
                SizedBox(
                  width: 160,
                  height: 160,
                  child: HSVColorSlider(
                    color: _pad,
                    sliderType: HSVColorSliderType.hueSat,
                    onChanged: (c) => setState(() => _pad = c),
                  ),
                ),
                const Gap(16),
                const Text('Alpha'),
                const Gap(8),
                SizedBox(
                  width: 240,
                  height: 24,
                  child: HSVColorSlider(
                    color: _alpha,
                    sliderType: HSVColorSliderType.alpha,
                    onChanged: (c) => setState(() => _alpha = c),
                  ),
                ),
                const Gap(16),
                const Text('Disabled hue (vertical bar)'),
                const Gap(8),
                SizedBox(
                  width: 240,
                  height: 24,
                  child: HSVColorSlider(
                    color: _hue,
                    sliderType: HSVColorSliderType.hue,
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
                  child: HSVColorSlider(
                    color: _pad,
                    sliderType: HSVColorSliderType.hueSat,
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
