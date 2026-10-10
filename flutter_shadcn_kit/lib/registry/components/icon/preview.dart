// Gallery preview for the `icon` component.
//
// Widgets-only, like the component itself. Shows every surviving modifier,
// the icon container, a scoped theme leg and dark tokens.

import 'package:flutter/widgets.dart';

import '../../foundation/icons/lucide_icons.dart';
import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';
import 'icon.dart';

/// Preview entry point used by the docs gallery.
class IconPreview extends StatelessWidget {
  /// Creates the preview.
  const IconPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return const ShadcnTheme(
      data: ShadcnThemeData(),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: _IconPreviewBody(),
      ),
    );
  }
}

class _IconPreviewBody extends StatelessWidget {
  const _IconPreviewBody();

  @override
  Widget build(BuildContext context) {
    final ShadcnColors colors = ShadcnTheme.of(context).colors;
    return ColoredBox(
      color: colors.background,
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(LucideIcons.star).iconX3Small(),
            SizedBox(width: ShadcnTheme.of(context).spacing.xl),
            const Icon(LucideIcons.star).iconXSmall(),
            SizedBox(width: ShadcnTheme.of(context).spacing.xl),
            const Icon(LucideIcons.star).iconSmall(),
            SizedBox(width: ShadcnTheme.of(context).spacing.xl),
            const Icon(LucideIcons.star).iconMedium(),
            SizedBox(width: ShadcnTheme.of(context).spacing.xl),
            const Icon(LucideIcons.star).iconLarge(),
            SizedBox(width: ShadcnTheme.of(context).spacing.xl),
            const Icon(LucideIcons.star).iconSmall().iconMutedForeground(),
            SizedBox(width: ShadcnTheme.of(context).spacing.xl),
            const IconContainer(icon: Icon(LucideIcons.check)),
            SizedBox(width: ShadcnTheme.of(context).spacing.xl),
            ComponentTheme<IconContainerTheme>(
              data: const IconContainerTheme(
                backgroundColor: ThemedColor.ref(ColorRef.secondary),
                iconColor: ThemedColor.ref(ColorRef.secondaryForeground),
              ),
              child: const IconContainer(icon: Icon(LucideIcons.check)),
            ),
          ],
        ),
      ),
    );
  }
}
