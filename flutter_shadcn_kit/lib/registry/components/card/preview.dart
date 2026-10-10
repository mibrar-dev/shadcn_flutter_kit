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
                _section(context, 'Composition', _composed(context)),
                Gap(theme.spacing.xl),
                _section(context, 'Bare surface', _bare(context)),
                Gap(theme.spacing.xl),
                _section(context, 'Clipped media', _clipped(context)),
                Gap(theme.spacing.xl),
                _section(context, 'Dark', _dark(context)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _composed(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          CardHeader(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CardTitle(child: Text('Deployments')),
                Gap(ShadcnTheme.of(context).spacing.xs),
                CardDescription(child: Text('Ship a new build to production.')),
              ],
            ),
          ),
          Gap(ShadcnTheme.of(context).spacing.lg),
          const CardContent(
            child: Text(
              'Every deploy is immutable; roll back from the history tab.',
            ),
          ),
          Gap(ShadcnTheme.of(context).spacing.lg),
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
                Gap(ShadcnTheme.of(context).spacing.sm),
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

  Widget _bare(BuildContext context) {
    return Card(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(LucideIcons.circle, size: 16),
          Gap(ShadcnTheme.of(context).spacing.sm),
          Text('Bare card, default padding'),
        ],
      ),
    );
  }

  Widget _clipped(BuildContext context) {
    return SizedBox(
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
              padding: EdgeInsets.all(ShadcnTheme.of(context).spacing.lg),
              child: Text('Media clipped to the card radius'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dark(BuildContext context) {
    return ShadcnTheme(
      data: const ShadcnThemeData(colors: ShadcnColors.darkFallback),
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            CardTitle(child: Text('Dark card')),
            Gap(ShadcnTheme.of(context).spacing.xs),
            CardDescription(child: Text('card / cardForeground tokens.')),
          ],
        ),
      ),
    );
  }

  Widget _section(BuildContext context, String title, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        Gap(ShadcnTheme.of(context).spacing.sm),
        child,
      ],
    );
  }
}
