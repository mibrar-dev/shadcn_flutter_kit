// Gallery preview for the `card_image` component: vertical and horizontal
// compositions, a scoped theme leg, a disabled card and the dark palette.
// Widgets-only.

import 'package:flutter/widgets.dart';

import '../../foundation/gap.dart';
import '../../foundation/icons/lucide_icons.dart';
import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';
import 'card_image.dart';

/// Renders the card image gallery.
class CardImagePreview extends StatelessWidget {
  /// Creates the preview.
  const CardImagePreview({super.key});

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
                _section('Vertical', _vertical()),
                const Gap(24),
                _section('Horizontal', _horizontal()),
                const Gap(24),
                _section('Disabled', _disabled()),
                const Gap(24),
                _section('Dark', _dark()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _vertical() {
    return SizedBox(
      width: 220,
      child: CardImage(
        image: _thumb(const Color(0xFF334155), const Color(0xFF94A3B8)),
        title: const Text('Sunset'),
        subtitle: const Text('18:42 · Lisbon'),
        onPressed: () {},
      ),
    );
  }

  Widget _horizontal() {
    return CardImage(
      theme: const CardImageTheme(direction: Axis.horizontal, gap: 12),
      image: SizedBox(
        width: 96,
        child: _thumb(const Color(0xFF1D4ED8), const Color(0xFFFFFFFF)),
      ),
      title: const Text('Track'),
      subtitle: const Text('3:21 · Ambient'),
      onPressed: () {},
    );
  }

  Widget _disabled() {
    return SizedBox(
      width: 220,
      child: CardImage(
        image: _thumb(const Color(0xFF475569), const Color(0xFFCBD5E1)),
        title: const Text('Disabled'),
        subtitle: const Text('onPressed is null'),
      ),
    );
  }

  Widget _dark() {
    return ShadcnTheme(
      data: const ShadcnThemeData(colors: ShadcnColors.darkFallback),
      child: SizedBox(
        width: 220,
        child: CardImage(
          image: _thumb(const Color(0xFF1E293B), const Color(0xFF64748B)),
          title: const Text('Dark'),
          subtitle: const Text('card / cardForeground tokens'),
          onPressed: () {},
        ),
      ),
    );
  }

  Widget _thumb(Color background, Color foreground) {
    return SizedBox(
      height: 120,
      child: ColoredBox(
        color: background,
        child: Center(
          child: Icon(LucideIcons.image, color: foreground, size: 28),
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
