// The landing collage card shell (spec §2.1).
//
// Split in P6-P1: this file keeps [CollageCard] + [collageNoop] only; the
// concrete cards live in `collage_cards_forms.dart` and
// `collage_cards_info.dart` to keep every file under the ~400-line rule.

import 'package:flutter/widgets.dart';

import '../ui/shadcn/components/card/card.dart';
import '../ui/shadcn/foundation/gap.dart';
import '../ui/shadcn/theme/color_tokens.dart';
import '../ui/shadcn/theme/theme.dart';
import 'docs_tokens.dart';

/// Base card: 24 px radius, card fill, `shadow-sm` + 5 % foreground ring.
/// The shared collage card shell (24 px radius, card fill, soft ring).
class CollageCard extends StatelessWidget {
  const CollageCard({
    super.key,
    this.title,
    this.subtitle,
    this.trailing,
    required this.children,
  });

  final String? title;
  final String? subtitle;

  /// Optional widget at the end of the header row (actions, icons, counts).
  final Widget? trailing;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return Card(
      padding: const EdgeInsets.all(20),
      background: ThemedColor.ref(ColorRef.card),
      borderColor: ThemedColor.value(
        theme.colors.foreground.withValues(alpha: 0.05),
      ),
      borderWidth: 1,
      borderRadius: BorderRadius.circular(24),
      shadows: theme.tokens.shadows.shadowSm,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (title != null)
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Text(
                    title!,
                    style: docsText(
                      context,
                      size: 16,
                      weight: FontWeight.w600,
                      color: theme.colors.cardForeground,
                    ),
                  ),
                ),
                if (trailing != null) ...<Widget>[const Gap(8), trailing!],
              ],
            ),
          if (subtitle != null) ...<Widget>[
            const Gap(4),
            Text(
              subtitle!,
              style: docsText(
                context,
                size: 14,
                height: 1.4,
                color: theme.colors.mutedForeground,
              ),
            ),
          ],
          if (title != null || subtitle != null) const Gap(12),
          ...children,
        ],
      ),
    );
  }
}

/// No-op callback for showcase buttons that must render enabled.
void collageNoop() {}
