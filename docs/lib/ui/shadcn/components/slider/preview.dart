// Named examples for the `slider` component (P6-F3 preview contract).
//
// One focused demo per example; the first entry is the default. Each slider
// carries its own bounded width because the track measures its extent, and
// its own state: the old gallery looped every variant through one value.
// Spacing comes from the ambient theme.

import 'package:flutter/widgets.dart';

import '../../foundation/component_preview.dart';
import '../../primitives/slider_value.dart';
import 'slider.dart';

/// A single-value slider; the value lives in this example's state.
class _SingleSlider extends StatefulWidget {
  const _SingleSlider();

  @override
  State<_SingleSlider> createState() => _SingleSliderState();
}

class _SingleSliderState extends State<_SingleSlider> {
  double _value = 0.4;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320,
      child: Slider(
        value: _value,
        onChanged: (double value) => setState(() => _value = value),
        semanticLabel: 'Single',
      ),
    );
  }
}

/// A ranged slider; the range lives in this example's state.
class _RangeSlider extends StatefulWidget {
  const _RangeSlider();

  @override
  State<_RangeSlider> createState() => _RangeSliderState();
}

class _RangeSliderState extends State<_RangeSlider> {
  SliderValue _range = const SliderValue.ranged(0.2, 0.7);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320,
      child: Slider.range(
        value: _range,
        onRangeChanged: (SliderValue value) => setState(() => _range = value),
        semanticLabel: 'Range',
      ),
    );
  }
}

/// A stepped slider with dot marks; the value lives in this example's state.
class _StepsSlider extends StatefulWidget {
  const _StepsSlider();

  @override
  State<_StepsSlider> createState() => _StepsSliderState();
}

class _StepsSliderState extends State<_StepsSlider> {
  double _value = 2;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320,
      child: Slider(
        value: _value,
        min: 0,
        max: 4,
        snap: const SliderSnap.steps(4),
        variant: SliderVariant.dots,
        onChanged: (double value) => setState(() => _value = value),
        semanticLabel: 'Steps',
      ),
    );
  }
}

Widget _default(BuildContext context) => const _SingleSlider();

Widget _range(BuildContext context) => const _RangeSlider();

Widget _steps(BuildContext context) => const _StepsSlider();

/// Named docs examples for `slider`; the first entry is the default.
const List<ComponentPreview> sliderPreviews = <ComponentPreview>[
  ComponentPreview('Default', _default),
  ComponentPreview('Range', _range),
  ComponentPreview('Steps', _steps),
];
