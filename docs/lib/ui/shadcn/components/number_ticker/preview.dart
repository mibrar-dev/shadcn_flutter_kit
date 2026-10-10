// Named examples for the `number_ticker` component (P6-F3 preview contract).
//
// One focused demo per example; the first entry is the default. Spacing comes
// from the ambient theme, so the examples follow the selected preset and the
// site light/dark toggle.

import 'package:flutter/widgets.dart';

import '../../foundation/component_preview.dart';
import '../../foundation/gap.dart';
import '../../theme/theme.dart';
import 'number_ticker.dart';

/// A rolling ticker whose value the example changes on tap.
class _NumberTickerTicker extends StatefulWidget {
  const _NumberTickerTicker();

  @override
  State<_NumberTickerTicker> createState() => _NumberTickerTickerState();
}

class _NumberTickerTickerState extends State<_NumberTickerTicker> {
  double _value = 1234;

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          _value.toStringAsFixed(0),
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w600,
            color: theme.colors.foreground,
          ),
        ),
        Gap(theme.spacing.md),
        NumberTicker(
          number: _value,
          formatter: (num value) => value.toStringAsFixed(0),
        ),
        Gap(theme.spacing.lg),
        Wrap(
          spacing: theme.spacing.sm,
          runSpacing: theme.spacing.sm,
          children: <Widget>[
            for (final double next in const <double>[0, 1234, 987654])
              GestureDetector(
                onTap: () => setState(() => _value = next),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: theme.colors.border),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '${next.toInt()}',
                    style: TextStyle(color: theme.colors.foreground),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

/// The flip-clock form of the same value.
class _NumberTickerFlipClock extends StatefulWidget {
  const _NumberTickerFlipClock();

  @override
  State<_NumberTickerFlipClock> createState() => _NumberTickerFlipClockState();
}

class _NumberTickerFlipClockState extends State<_NumberTickerFlipClock> {
  double _value = 1234;

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        TextFlipper(
          charset: FlipperCharset.numbers,
          text: _value.toInt().toString(),
        ),
        Gap(theme.spacing.md),
        Wrap(
          spacing: theme.spacing.sm,
          children: <Widget>[
            for (final double next in const <double>[7, 1234, 987654])
              GestureDetector(
                onTap: () => setState(() => _value = next),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: theme.colors.border),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '${next.toInt()}',
                    style: TextStyle(color: theme.colors.foreground),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

Widget _numberTickerDefault(BuildContext context) =>
    const _NumberTickerTicker();

Widget _numberTickerFlip(BuildContext context) =>
    const _NumberTickerFlipClock();

/// Named docs examples for `number_ticker`; the first entry is the default.
const List<ComponentPreview> numberTickerPreviews = <ComponentPreview>[
  ComponentPreview('Default', _numberTickerDefault),
  ComponentPreview('Flip clock', _numberTickerFlip),
];
