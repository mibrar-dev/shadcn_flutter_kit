// Gallery preview for the `number_ticker` component: formatted tickers,
// custom builders and flip-clock text, light and dark. Widgets-only (the
// compact demo formats with `intl`, an app dependency); the docs app embeds
// [NumberTickerPreview] directly.

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart' as intl;

import '../../foundation/gap.dart';
import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';
import 'number_ticker.dart';

/// Renders the number ticker gallery.
class NumberTickerPreview extends StatefulWidget {
  /// Creates the preview.
  const NumberTickerPreview({super.key});

  @override
  State<NumberTickerPreview> createState() => _NumberTickerPreviewState();
}

class _NumberTickerPreviewState extends State<NumberTickerPreview> {
  double _value = 1234;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: DefaultTextStyle(
        style: const TextStyle(fontSize: 20),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _section(
                'Formatted',
                NumberTicker(
                  number: _value,
                  formatter: (value) =>
                      intl.NumberFormat.compact().format(value),
                ),
              ),
              const Gap(24),
              _section(
                'Custom builder',
                NumberTicker.builder(
                  number: _value,
                  builder: (context, value, _) => Text(
                    '${value.toStringAsFixed(1)} pts',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const Gap(24),
              _section(
                'Flip clock',
                TextFlipper(
                  charset: FlipperCharset.numbers,
                  text: _value.toInt().toString(),
                ),
              ),
              const Gap(24),
              _section(
                'Dark',
                ShadcnTheme(
                  data: const ShadcnThemeData(
                    colors: ShadcnColors.darkFallback,
                  ),
                  child: NumberTicker(
                    number: _value,
                    formatter: (value) => value.toStringAsFixed(0),
                  ),
                ),
              ),
              const Gap(24),
              Wrap(
                spacing: 8,
                children: <Widget>[
                  for (final double next in <double>[0, 1234, 987654])
                    GestureDetector(
                      onTap: () => setState(() => _value = next),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFF888888)),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text('$next'),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _section(String title, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const Gap(8),
        child,
      ],
    );
  }
}
