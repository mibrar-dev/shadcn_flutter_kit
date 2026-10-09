// Gallery preview for the `alpha` component: the checkerboard behind a
// translucent colour well, in light and dark.

import 'package:flutter/widgets.dart';

import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';
import 'alpha.dart';

/// Renders the alpha gallery.
class AlphaPreview extends StatelessWidget {
  /// Creates the preview.
  const AlphaPreview({super.key});

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return Directionality(
      textDirection: TextDirection.ltr,
      child: DefaultTextStyle(
        style: TextStyle(color: theme.colors.foreground, fontSize: 13),
        child: ColoredBox(
          color: theme.colors.background,
          child: Center(
            child: SizedBox(
              width: 220,
              height: 48,
              child: Stack(
                children: <Widget>[
                  const Positioned.fill(
                    child: CustomPaint(painter: AlphaPainter()),
                  ),
                  Container(color: theme.colors.primary.withValues(alpha: 0.5)),
                  const Center(child: Text('Alpha grid')),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
