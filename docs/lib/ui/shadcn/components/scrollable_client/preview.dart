// Gallery preview for the `scrollable_client` component: a two-axis tile
// canvas translated by the builder offset.
// Widgets-only; the docs app embeds [ScrollableClientPreview] directly.

import 'package:flutter/widgets.dart';

import '../../foundation/gap.dart';
import '../../theme/theme.dart';
import 'scrollable_client.dart';

/// Renders the scrollable client gallery.
class ScrollableClientPreview extends StatelessWidget {
  /// Creates the preview.
  const ScrollableClientPreview({super.key});

  static const List<Color> _tileColors = <Color>[
    Color(0xFFBFDBFE),
    Color(0xFFA7F3D0),
    Color(0xFFFDE68A),
    Color(0xFFFECACA),
    Color(0xFFE9D5FF),
    Color(0xFFBAE6FD),
  ];

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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  width: 280,
                  height: 200,
                  child: ScrollableClient(
                    builder: (context, offset, viewportSize, child) {
                      // The render object already translates the content by
                      // the offset; the builder receives it for extra effects
                      // (parallax, zoom, virtualisation).
                      return child!;
                    },
                    child: SizedBox(
                      width: 640,
                      height: 420,
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: <Widget>[
                          for (int index = 0; index < 24; index++)
                            SizedBox(
                              width: 88,
                              height: 64,
                              child: ColoredBox(
                                color: _tileColors[index % _tileColors.length],
                                child: Center(child: Text('Tile ${index + 1}')),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                const Gap(12),
                const Text('Drag on either axis'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
