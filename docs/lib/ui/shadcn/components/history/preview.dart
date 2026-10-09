// Gallery preview for the `history` component: the recent-colours grid
// fed by a RecentColorsScope, light and dark.

import 'package:flutter/widgets.dart';

import '../../theme/theme.dart';
import 'history.dart';

/// Renders the history gallery.
class HistoryPreview extends StatelessWidget {
  /// Creates the preview.
  const HistoryPreview({super.key});

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
            child: RecentColorsScope(
              initialRecentColors: const <Color>[
                Color(0xFF2196F3),
                Color(0xFF9C27B0),
                Color(0x80FF5722),
              ],
              child: Builder(
                builder: (context) {
                  return ColorHistoryGrid(
                    storage: ColorHistoryStorage.of(context),
                    selectedColor: const Color(0xFF2196F3),
                    crossAxisCount: 5,
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
