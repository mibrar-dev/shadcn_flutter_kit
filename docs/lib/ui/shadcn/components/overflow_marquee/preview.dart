// Gallery preview for the `overflow_marquee` component.
//
// Widgets-only: an overflowing horizontal ticker, a vertical one, a
// non-overflowing (static) child and a scoped theme leg.

import 'package:flutter/widgets.dart';

import '../../foundation/gap.dart';
import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';
import 'overflow_marquee.dart';

/// Preview entry point used by the docs gallery.
class OverflowMarqueePreview extends StatelessWidget {
  /// Creates the preview.
  const OverflowMarqueePreview({super.key});

  @override
  Widget build(BuildContext context) {
    return const ShadcnTheme(
      data: ShadcnThemeData(),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: _OverflowMarqueePreviewBody(),
      ),
    );
  }
}

class _OverflowMarqueePreviewBody extends StatelessWidget {
  const _OverflowMarqueePreviewBody();

  static const String _line =
      'The quick brown fox jumps over the lazy dog — long enough to overflow '
      'a narrow container and keep scrolling.';

  @override
  Widget build(BuildContext context) {
    final ShadcnColors colors = ShadcnTheme.of(context).colors;
    return ColoredBox(
      color: colors.background,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(color: colors.border),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(8),
                  child: OverflowMarquee(
                    duration: Duration(seconds: 6),
                    child: Text(_line),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: ComponentTheme<OverflowMarqueeTheme>(
                      data: const OverflowMarqueeTheme(
                        duration: Duration(seconds: 3),
                        fadePortion: 0.2,
                      ),
                      child: const OverflowMarquee(
                        direction: Axis.vertical,
                        child: SizedBox(height: 96, child: Text(_line)),
                      ),
                    ),
                  ),
                  const Gap(16),
                  // Fits: the render object never starts a scroll.
                  const OverflowMarquee(child: Text('fits')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
