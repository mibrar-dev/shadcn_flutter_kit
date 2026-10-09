// Gallery preview for the `spinner` component.
//
// Widgets-only, like the component itself. Shows sizes, strokes, colours, a
// scoped theme leg and dark tokens.

import 'package:flutter/widgets.dart';

import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';
import 'spinner.dart';

/// Preview entry point used by the docs gallery.
class SpinnerPreview extends StatelessWidget {
  /// Creates the preview.
  const SpinnerPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return const ShadcnTheme(
      data: ShadcnThemeData(),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: _SpinnerPreviewBody(),
      ),
    );
  }
}

class _SpinnerPreviewBody extends StatelessWidget {
  const _SpinnerPreviewBody();

  @override
  Widget build(BuildContext context) {
    final ShadcnColors colors = ShadcnTheme.of(context).colors;
    return ColoredBox(
      color: colors.background,
      child: Center(
        child: Wrap(
          spacing: 32,
          runSpacing: 32,
          alignment: WrapAlignment.center,
          children: <Widget>[
            const Spinner(),
            const Spinner(size: 16),
            const Spinner(size: 32),
            const Spinner(size: 48),
            const Spinner(strokeWidth: 2),
            const Spinner(strokeWidth: 6),
            const Spinner(color: Color(0xFF16A34A)),
            const Spinner(color: Color(0xFFE7000B)),
            ComponentTheme<SpinnerTheme>(
              data: const SpinnerTheme(
                color: ThemedColor.ref(ColorRef.mutedForeground),
              ),
              child: const Spinner(),
            ),
          ],
        ),
      ),
    );
  }
}
