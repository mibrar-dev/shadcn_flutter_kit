// Gallery preview for the `triple_dots` component.
//
// Widgets-only, like the component itself. Shows counts, directions, sizes,
// colours, a scoped theme leg and dark tokens.

import 'package:flutter/widgets.dart';

import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';
import 'triple_dots.dart';

/// Preview entry point used by the docs gallery.
class TripleDotsPreview extends StatelessWidget {
  /// Creates the preview.
  const TripleDotsPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return const ShadcnTheme(
      data: ShadcnThemeData(),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: _TripleDotsPreviewBody(),
      ),
    );
  }
}

class _TripleDotsPreviewBody extends StatelessWidget {
  const _TripleDotsPreviewBody();

  @override
  Widget build(BuildContext context) {
    final ShadcnColors colors = ShadcnTheme.of(context).colors;
    return ColoredBox(
      color: colors.background,
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const TripleDots(),
            const SizedBox(width: 32),
            const TripleDots(count: 4, spacing: 4),
            const SizedBox(width: 32),
            const TripleDots(size: 6, color: Color(0xFFE7000B)),
            const SizedBox(width: 32),
            const TripleDots(direction: Axis.vertical),
            const SizedBox(width: 32),
            ComponentTheme<TripleDotsTheme>(
              data: const TripleDotsTheme(
                color: ThemedColor.ref(ColorRef.foreground),
                size: 5,
              ),
              child: const TripleDots(),
            ),
          ],
        ),
      ),
    );
  }
}
