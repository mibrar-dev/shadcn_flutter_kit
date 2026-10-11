// Named examples for the `overflow_marquee` component (P6-F3 preview contract).
//
// One focused demo per example; the first entry is the default. Spacing comes
// from the ambient theme, so the examples follow the selected preset and the
// site light/dark toggle. Each marquee carries its own bounded box because
// the ticker measures the overflow against its constraints.

import 'package:flutter/widgets.dart';

import '../../foundation/component_preview.dart';
import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';
import 'overflow_marquee.dart';

/// Long enough to overflow a narrow container and keep scrolling.
const String _line =
    'The quick brown fox jumps over the lazy dog — long enough to overflow '
    'a narrow container and keep scrolling.';

/// A horizontal ticker in a bordered band.
Widget _horizontal(BuildContext context) {
  final ShadcnColors colors = ShadcnTheme.of(context).colors;
  return SizedBox(
    width: 320,
    child: DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: colors.border),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: EdgeInsets.all(ShadcnTheme.of(context).spacing.sm),
        child: const OverflowMarquee(
          duration: Duration(seconds: 6),
          child: Text(_line),
        ),
      ),
    ),
  );
}

/// A vertical ticker in a short viewport.
Widget _vertical(BuildContext context) {
  return const SizedBox(
    width: 200,
    height: 120,
    child: OverflowMarquee(
      direction: Axis.vertical,
      duration: Duration(seconds: 3),
      child: SizedBox(height: 160, child: Text(_line)),
    ),
  );
}

/// Named docs examples for `overflow_marquee`; the first entry is the default.
const List<ComponentPreview> overflowMarqueePreviews = <ComponentPreview>[
  ComponentPreview('Horizontal', _horizontal),
  ComponentPreview('Vertical', _vertical),
];
