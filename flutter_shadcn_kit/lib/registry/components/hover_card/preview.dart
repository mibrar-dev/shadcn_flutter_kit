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
          child: SingleChildScrollView(
            padding: EdgeInsets.all(ShadcnTheme.of(context).spacing.xl),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Hover the name (500 ms delay)'),
                SizedBox(height: ShadcnTheme.of(context).spacing.sm),
                HoverCard(hoverBuilder: _card, child: Text('@shadcn')),
                SizedBox(height: ShadcnTheme.of(context).spacing.xl),
                Text('Instant card'),
                SizedBox(height: ShadcnTheme.of(context).spacing.sm),
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
  return Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text('@shadcn'),
      SizedBox(height: ShadcnTheme.of(context).spacing.xs),
      Text('Beautifully designed components.'),
    ],
  );
}
