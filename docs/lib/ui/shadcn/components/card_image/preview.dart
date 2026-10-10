// Named examples for the `card_image` component (P6-F3 preview contract).
//
// One focused demo per example; the first entry is the default. Spacing comes
// from the ambient theme, so the examples follow the selected preset and the
// site light/dark toggle.

import 'package:flutter/widgets.dart';

import '../../foundation/component_preview.dart';
import '../../foundation/gap.dart';
import '../../foundation/icons/lucide_icons.dart';
import '../../theme/theme.dart';
import 'card_image.dart';

/// A palette-derived thumbnail, so the demo follows the selected theme.
Widget _cardImageThumb(BuildContext context, double height) {
  final theme = ShadcnTheme.of(context);
  return SizedBox(
    height: height,
    child: ColoredBox(
      color: theme.colors.muted,
      child: Center(
        child: Icon(
          LucideIcons.image,
          size: 28,
          color: theme.colors.mutedForeground,
        ),
      ),
    ),
  );
}

/// Vertical composition: media above the text block.
Widget _cardImageVertical(BuildContext context) {
  return SizedBox(
    width: 220,
    child: CardImage(
      image: _cardImageThumb(context, 120),
      title: const Text('Sunset'),
      subtitle: const Text('18:42 - Lisbon'),
      onPressed: () {},
    ),
  );
}

/// Horizontal composition: media beside the text block.
Widget _cardImageHorizontal(BuildContext context) {
  return SizedBox(
    width: 320,
    child: CardImage(
      theme: const CardImageTheme(direction: Axis.horizontal, gap: 12),
      image: SizedBox(width: 96, child: _cardImageThumb(context, 120)),
      title: const Text('Track'),
      subtitle: const Text('3:21 - Ambient'),
      onPressed: () {},
    ),
  );
}

/// The disabled card (no `onPressed`).
Widget _cardImageDisabled(BuildContext context) {
  final spacing = ShadcnTheme.of(context).spacing;
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      SizedBox(
        width: 220,
        child: CardImage(
          image: _cardImageThumb(context, 120),
          title: const Text('Disabled'),
          subtitle: const Text('onPressed is null'),
        ),
      ),
      Gap(spacing.lg),
      SizedBox(
        width: 220,
        child: CardImage(
          image: _cardImageThumb(context, 120),
          title: const Text('Compact'),
          subtitle: const Text('denser padding'),
          onPressed: () {},
        ),
      ),
    ],
  );
}

/// Named docs examples for `card_image`; the first entry is the default.
const List<ComponentPreview> cardImagePreviews = <ComponentPreview>[
  ComponentPreview('Vertical', _cardImageVertical),
  ComponentPreview('Horizontal', _cardImageHorizontal),
  ComponentPreview('Disabled', _cardImageDisabled),
];
