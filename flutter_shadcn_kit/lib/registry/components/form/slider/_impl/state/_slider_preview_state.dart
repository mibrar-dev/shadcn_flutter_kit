// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../preview.dart';

/// _SliderPreviewState stores and manages mutable widget state.
class _SliderPreviewState extends State<SliderPreview> {
  double _brightness = 0.64;
  double _stepped = 5;
  double _wave = 0.35;
  double _price = 97;
  ShadRangeValue _range = const ShadRangeValue(3, 8, minRange: 0);
  ShadRangeValue _priceRange = const ShadRangeValue(220, 1250, minRange: 80);

  late final List<double> _amps = List.generate(80, (index) {
    final t = index / 79.0;
    return (sin(t * pi) * (0.35 + 0.65 * sin(t * pi * 3).abs())).clamp(
      0.05,
      1.0,
    );
  });

  late final List<double> _priceBars = List.generate(44, (index) {
    final t = index / 43.0;
    final center = exp(-pow((t - 0.52) / 0.22, 2));
    final ripple = 0.25 * sin(t * pi * 8).abs();
    final edgeMask = (1 - (t - 0.5).abs() * 2).clamp(0.0, 1.0);
    final value = (center * 0.78 + ripple * 0.22) * pow(edgeMask, 0.34);
    return value.clamp(0.03, 1.0).toDouble();
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scaling = theme.scaling;
    final width = MediaQuery.of(context).size.width;
    final columns = width >= 1500
        ? 4
        : width >= 1100
        ? 3
        : width >= 760
        ? 2
        : 1;
    final spacing = 24 * scaling;
    final horizontalPadding = 24 * scaling;
    final cardWidth =
        (width - horizontalPadding * 2 - spacing * (columns - 1)) / columns;

    return Scaffold(
      backgroundColor: const Color(0xFFEFEFEF),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(horizontalPadding),
        child: Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            SizedBox(
              width: cardWidth,
              child: _PreviewCard(
                title: 'Adjust brightness',
                trailing: '${(_brightness * 100).round()}%',
                child: Slider.single(
                  min: 0,
                  max: 1,
                  value: _brightness,
                  thumbSize: const Size(10, 25),
                  trackHeight: 30,
                  thumbEdgeOffsetPx: 0,
                  joinGapPx: 2,
                  fillEdgeBiasPx: 0,
                  fillStopsAtThumbCenter: false,
                  preset: 'brightness',
                  thumbBuilder: ShadSliderDefaults.barThumb(insideOffsetPx: 8),
                  onChanged: (v) =>
                      setState(() => _brightness = v >= 0.999 ? 1.0 : v),
                ),
              ),
            ),
            SizedBox(
              width: cardWidth,
              child: _PreviewCard(
                title: 'Range selector (ring thumb)',
                child: RangeSoftSlider(
                  min: 0,
                  max: 10,
                  rangeValue: _range,
                  onChanged: (value) => setState(() => _range = value),
                  thumbBuilder: ShadSliderDefaults.circleThumb,
                ),
              ),
            ),
            SizedBox(
              width: cardWidth,
              child: _PreviewCard(
                title: 'Steps + dots',
                child: StepsDotsSlider(
                  min: 0,
                  max: 10,
                  value: _stepped,
                  steps: 10,
                  dragPopoverBuilder: ShadSliderDefaults.valuePopover(
                    formatter: (value) => 'Step - ${value.toStringAsFixed(2)}',
                  ),
                  onChanged: (value) => setState(() => _stepped = value),
                ),
              ),
            ),
            SizedBox(
              width: cardWidth,
              child: _PreviewCard(
                title: 'Waveform preset',
                child: WaveformSlider(
                  min: 0,
                  max: 1,
                  value: _wave,
                  onChanged: (value) => setState(() => _wave = value),
                  ticksBuilder: (context, state) =>
                      _waveformTicks(context, state, _amps),
                  thumbBuilder: ShadSliderDefaults.circleThumb,
                  dragPopoverBuilder: ShadSliderDefaults.valuePopover(
                    formatter: (value) =>
                        '\$${(value * 120).toStringAsFixed(2)}',
                  ),
                ),
              ),
            ),
            SizedBox(
              width: cardWidth,
              child: _PreviewCard(
                title: 'Wave slider variant',
                trailing: '\$${_price.toStringAsFixed(0)}',
                child: WaveSlider.domain(
                  min: 90,
                  max: 120,
                  value: _price,
                  onChanged: (value) => setState(() => _price = value),
                  samples: _amps,
                  popoverVisibility: ShadPopoverVisibility.always,
                  popoverBuilder: ShadSliderDefaults.valuePopover(
                    formatter: (value) => '\$${value.toStringAsFixed(0)}',
                    shape: ShadPopoverShape.rounded,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: cardWidth,
              child: _PreviewCard(
                title: 'Airbnb-style price range',
                trailing:
                    '\$${_priceRange.start.round()} - \$${_priceRange.end.round()}',
                child: _airbnbPriceRangeExample(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _airbnbPriceRangeExample(BuildContext context) {
    final accent = const Color(0xFFD9366E);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Trip price, includes all fees',
          style: TextStyle(color: Colors.black.withOpacity(0.68), fontSize: 13),
        ),
        const SizedBox(height: 14),
        RangeSoftSlider(
          min: 40,
          max: 1600,
          rangeValue: _priceRange,
          onChanged: (value) => setState(() => _priceRange = value),
          trackHeight: 1,
          trackRadius: 999,
          joinGapPx: 0,
          thumbSize: const Size(34, 34),
          trackBuilder: (context, state) {
            return Positioned(
              left: 0,
              right: 0,
              top: state.trackRect.top,
              child: Container(
                height: state.trackRect.height,
                decoration: BoxDecoration(
                  color: accent.withOpacity(0.26),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            );
          },
          fillBuilder: (context, state) {
            final selected = state.rangeRect ?? Rect.zero;
            return Stack(
              children: [
                Positioned.fromRect(
                  rect: selected,
                  child: Container(
                    decoration: BoxDecoration(
                      color: accent,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
              ],
            );
          },
          ticksBuilder: (context, state) =>
              _priceHistogramTicks(context, state, _priceBars, accent),
          thumbBuilder: _priceRangeThumb,
          dragPopoverBuilder: ShadSliderDefaults.valuePopoverPill(
            formatter: (value) => '\$${value.round()}',
          ),
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: _priceChip(label: 'Minimum', value: _priceRange.start),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _priceChip(label: 'Maximum', value: _priceRange.end),
            ),
          ],
        ),
      ],
    );
  }

  Widget _priceChip({required String label, required double value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.black.withOpacity(0.58), fontSize: 12),
        ),
        const SizedBox(height: 6),
        Container(
          height: 36,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: const Color(0xFFD9D9D9)),
          ),
          child: Text(
            '\$${value.round()}',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}

class _PreviewCard extends StatelessWidget {
  const _PreviewCard({required this.title, this.trailing, required this.child});

  final String title;
  final String? trailing;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            blurRadius: 26,
            color: Colors.black12,
            offset: Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(title)),
              if (trailing != null) Text(trailing!),
            ],
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.topCenter,
            child: SizedBox(width: 420, child: child),
          ),
        ],
      ),
    );
  }
}

Widget _waveformTicks(
  BuildContext context,
  ShadSliderStateView state,
  List<double> amplitudes,
) {
  final width = state.trackRect.width;
  final height = state.trackRect.height;
  final barCount = amplitudes.length;
  final barWidth = width / barCount;
  final maxBarHeight = height * 0.78;
  final activeT = state.t ?? 0;
  final activeX = width * activeT;
  final activeColor = Theme.of(context).colorScheme.primary;
  final inactiveColor = Theme.of(
    context,
  ).colorScheme.mutedForeground.withOpacity(0.16);

  return Positioned.fromRect(
    rect: state.trackRect,
    child: IgnorePointer(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(state.trackRadius),
        child: SizedBox(
          width: width,
          height: height,
          child: Stack(
            children: [
              for (int index = 0; index < barCount; index++)
                Positioned(
                  left: index * barWidth,
                  top: (height - (amplitudes[index] * maxBarHeight)) / 2,
                  child: Container(
                    width: max(1, barWidth * 0.55),
                    height: amplitudes[index] * maxBarHeight,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(999),
                      color: (index * barWidth) <= activeX
                          ? activeColor
                          : inactiveColor,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget _priceRangeThumb(BuildContext context, ShadThumbStateView t) {
  return IgnorePointer(
    ignoring: true,
    child: Container(
      width: t.size.width,
      height: t.size.height,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        border: Border.all(color: const Color(0xFFD6D6D6), width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
    ),
  );
}

Widget _priceHistogramTicks(
  BuildContext context,
  ShadSliderStateView state,
  List<double> bars,
  Color accent,
) {
  final width = state.trackRect.width;
  final lineTop = state.trackRect.top;
  final maxHeight = 34.0;
  final count = bars.length;
  final step = width / count;
  final barW = max(2.0, step * 0.72);
  final range = state.rangeValue;
  final min = state.min;
  final maxV = state.max;
  final inv = (maxV - min).abs() < 0.0001 ? 1.0 : (maxV - min);
  final tStart = ((range?.start ?? min) - min) / inv;
  final tEnd = ((range?.end ?? min) - min) / inv;

  return IgnorePointer(
    child: Stack(
      clipBehavior: Clip.none,
      children: [
        for (int i = 0; i < count; i++)
          Positioned(
            left: i * step + (step - barW) / 2,
            top: lineTop - (maxHeight * bars[i]) - 4,
            child: Container(
              width: barW,
              height: maxHeight * bars[i],
              decoration: BoxDecoration(
                color: (() {
                  final t = i / (count - 1);
                  final selected = t >= tStart && t <= tEnd;
                  return selected ? accent : accent.withOpacity(0.32);
                })(),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
      ],
    ),
  );
}
