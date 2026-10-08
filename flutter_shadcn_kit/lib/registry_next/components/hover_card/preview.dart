// Widgets-only preview gallery for the `hover_card` component.

import 'package:flutter/widgets.dart';

import '../../theme/theme.dart';
import 'hover_card.dart';

/// Preview entry point used by the docs gallery.
class HoverCardPreview extends StatelessWidget {
  /// Creates the preview.
  const HoverCardPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return ShadcnTheme(
      data: const ShadcnThemeData(),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: ColoredBox(
          color: const ShadcnThemeData().colors.background,
          child: const SingleChildScrollView(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Hover the name (500 ms delay)'),
                SizedBox(height: 8),
                HoverCard(hoverBuilder: _card, child: Text('@shadcn')),
                SizedBox(height: 24),
                Text('Instant card'),
                SizedBox(height: 8),
                HoverCard(
                  wait: Duration.zero,
                  hoverBuilder: _card,
                  child: Text('@fast'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Sample card content.
Widget _card(BuildContext context) {
  return const Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text('@shadcn'),
      SizedBox(height: 4),
      Text('Beautifully designed components.'),
    ],
  );
}
