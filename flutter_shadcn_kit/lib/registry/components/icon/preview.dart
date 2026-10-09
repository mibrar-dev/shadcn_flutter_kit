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
            const SizedBox(width: 24),
            const Icon(LucideIcons.star).iconXSmall(),
            const SizedBox(width: 24),
            const Icon(LucideIcons.star).iconSmall(),
            const SizedBox(width: 24),
            const Icon(LucideIcons.star).iconMedium(),
            const SizedBox(width: 24),
            const Icon(LucideIcons.star).iconLarge(),
            const SizedBox(width: 24),
            const Icon(LucideIcons.star).iconSmall().iconMutedForeground(),
            const SizedBox(width: 24),
            const IconContainer(icon: Icon(LucideIcons.check)),
            const SizedBox(width: 24),
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
