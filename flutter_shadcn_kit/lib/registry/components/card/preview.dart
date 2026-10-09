// Gallery preview for the `card` component: the full shadcn slot composition,
// a bare surface, the clipped variant and the dark palette.
// Widgets-only; the docs app embeds [CardPreview] directly.

import 'package:flutter/widgets.dart';

import '../../foundation/gap.dart';
import '../../foundation/icons/lucide_icons.dart';
import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';
import '../button/button.dart';
import 'card.dart';

/// Renders the card gallery.
class CardPreview extends StatelessWidget {
  /// Creates the preview.
  const CardPreview({super.key});

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return Directionality(
      textDirection: TextDirection.ltr,
      child: DefaultTextStyle(
        style: TextStyle(color: theme.colors.foreground, fontSize: 13),
        child: ColoredBox(
          color: theme.colors.background,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _section('Composition', _composed()),
                const Gap(24),
                _section('Bare surface', _bare()),
                const Gap(24),
                _section('Clipped media', _clipped()),
                const Gap(24),
                _section('Dark', _dark()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _composed() {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const CardHeader(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CardTitle(child: Text('Deployments')),
                Gap(4),
                CardDescription(child: Text('Ship a new build to production.')),
              ],
            ),
          ),
          const Gap(16),
          const CardContent(
            child: Text(
              'Every deploy is immutable; roll back from the history tab.',
            ),
          ),
          const Gap(16),
          CardFooter(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Button(
                  size: ButtonSize.sm,
                  variant: ButtonVariant.ghost,
                  onPressed: () {},
                  child: const Text('Cancel'),
                ),
                const Gap(8),
                Button(
                  size: ButtonSize.sm,
                  onPressed: () {},
                  child: const Text('Deploy'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _bare() {
    return const Card(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(LucideIcons.circle, size: 16),
          Gap(8),
          Text('Bare card, default padding'),
        ],
      ),
    );
  }

  Widget _clipped() {
    return const SizedBox(
      width: 220,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
              height: 72,
              child: ColoredBox(
                color: Color(0xFF334155),
                child: Center(
                  child: Icon(
                    LucideIcons.star,
                    size: 24,
                    color: Color(0xFFCBD5E1),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Text('Media clipped to the card radius'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dark() {
    return ShadcnTheme(
      data: const ShadcnThemeData(colors: ShadcnColors.darkFallback),
      child: const Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            CardTitle(child: Text('Dark card')),
            Gap(4),
            CardDescription(child: Text('card / cardForeground tokens.')),
          ],
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
