// Gallery preview for the `slider` component: single and range sliders in
// every variant, plus snap and disabled states, in light and dark.
// Widgets-only; the docs app embeds [SliderPreview] directly.

import 'package:flutter/widgets.dart';

import '../../primitives/slider_value.dart';
import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';
import 'slider.dart';

/// Renders the slider gallery.
class SliderPreview extends StatefulWidget {
  /// Creates the preview.
  const SliderPreview({super.key});

  @override
  State<SliderPreview> createState() => _SliderPreviewState();
}

class _SliderPreviewState extends State<SliderPreview> {
  double _single = 0.4;
  double _steps = 2;
  SliderValue _range = const SliderValue.ranged(0.2, 0.7);

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
                const Text('Single'),
                const SizedBox(height: 8),
                Slider(
                  value: _single,
                  onChanged: (v) => setState(() => _single = v),
                  semanticLabel: 'Single',
                ),
                const SizedBox(height: 16),
                const Text('Variants'),
                const SizedBox(height: 8),
                for (final variant in SliderVariant.values)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Slider(
                      value: _single,
                      variant: variant,
                      onChanged: (v) => setState(() => _single = v),
                      semanticLabel: variant.name,
                    ),
                  ),
                const Text('Range'),
                const SizedBox(height: 8),
                Slider.range(
                  value: _range,
                  onRangeChanged: (v) => setState(() => _range = v),
                  semanticLabel: 'Range',
                ),
                const SizedBox(height: 16),
                const Text('Steps (0..4)'),
                const SizedBox(height: 8),
                Slider(
                  value: _steps,
                  min: 0,
                  max: 4,
                  snap: const SliderSnap.steps(4),
                  variant: SliderVariant.dots,
                  onChanged: (v) => setState(() => _steps = v),
                  semanticLabel: 'Steps',
                ),
                const SizedBox(height: 16),
                const Text('Wave'),
                const SizedBox(height: 8),
                Slider(
                  value: _single,
                  variant: SliderVariant.wave,
                  snap: const SliderSnap.steps(24),
                  onChanged: (v) => setState(() => _single = v),
                  semanticLabel: 'Wave',
                ),
                const SizedBox(height: 16),
                const Text('Disabled'),
                const SizedBox(height: 8),
                const Slider(
                  value: 0.6,
                  enabled: false,
                  onChanged: null,
                  semanticLabel: 'Disabled',
                ),
                const SizedBox(height: 16),
                const Text('Dark'),
                const SizedBox(height: 8),
                ShadcnTheme(
                  data: ShadcnThemeData(colors: ShadcnColors.darkFallback),
                  child: Slider(
                    value: 0.5,
                    onChanged: null,
                    semanticLabel: 'Dark',
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
