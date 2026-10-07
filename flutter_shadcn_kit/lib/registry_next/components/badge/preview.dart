// Gallery preview for the `badge` component: every variant, a pressable
// badge, the dot form and the dark palette.
// Widgets-only; the docs app embeds [BadgePreview] directly.

import 'package:flutter/widgets.dart';

import '../../foundation/gap.dart';
import '../../foundation/icons/lucide_icons.dart';
import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';
import 'badge.dart';

/// Renders the badge gallery.
class BadgePreview extends StatefulWidget {
  /// Creates the preview.
  const BadgePreview({super.key});

  @override
  State<BadgePreview> createState() => _BadgePreviewState();
}

class _BadgePreviewState extends State<BadgePreview> {
  int _presses = 0;

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
                _section(
                  'Variants',
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: <Widget>[
                      for (final BadgeVariant variant in BadgeVariant.values)
                        Badge(variant: variant, child: Text(variant.name)),
                    ],
                  ),
                ),
                const Gap(24),
                _section(
                  'Pressable',
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: <Widget>[
                      Badge(
                        onPressed: () => setState(() => _presses++),
                        leading: const Icon(LucideIcons.check, size: 12),
                        child: const Text('Pressable'),
                      ),
                      Text('pressed $_presses times'),
                    ],
                  ),
                ),
                const Gap(24),
                _section(
                  'Dot',
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: <Widget>[
                      for (final BadgeVariant variant in BadgeVariant.values)
                        Badge(
                          variant: variant,
                          showAsDot: true,
                          child: const SizedBox.shrink(),
                        ),
                    ],
                  ),
                ),
                const Gap(24),
                _section('Dark', _dark()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _dark() {
    return ShadcnTheme(
      data: const ShadcnThemeData(colors: ShadcnColors.darkFallback),
      child: ColoredBox(
        color: ShadcnColors.darkFallback.background,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: <Widget>[
              for (final BadgeVariant variant in BadgeVariant.values)
                Badge(variant: variant, child: Text(variant.name)),
            ],
          ),
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
