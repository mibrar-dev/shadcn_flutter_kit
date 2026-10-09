// Gallery preview for the `swiper` component: drag a pane towards the panel
// edge to reveal a drawer or a sheet. Widgets-only; the docs app embeds
// [SwiperPreview] inside a `Navigator`.

import 'package:flutter/widgets.dart';

import '../../foundation/gap.dart';
import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';
import 'swiper.dart';

/// Renders the swiper gallery.
class SwiperPreview extends StatelessWidget {
  /// Creates the preview.
  const SwiperPreview({super.key});

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return Directionality(
      textDirection: TextDirection.ltr,
      child: DefaultTextStyle(
        style: TextStyle(color: theme.colors.foreground, fontSize: 13),
        child: ColoredBox(
          color: theme.colors.background,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                _label('Drawer — swipe right'),
                const Gap(8),
                Expanded(
                  child: Swiper(
                    position: OverlayPosition.left,
                    builder: (BuildContext context) => _Panel(
                      title: 'Drawer',
                      hint: 'Swipe it away to dismiss',
                    ),
                    child: _SwipeSurface('Swipe right for a drawer'),
                  ),
                ),
                const Gap(16),
                _label('Sheet — swipe up'),
                const Gap(8),
                Expanded(
                  child: Swiper(
                    position: OverlayPosition.bottom,
                    variant: SwiperVariant.sheet,
                    builder: (BuildContext context) =>
                        _Panel(title: 'Sheet', hint: 'Drag down to dismiss'),
                    child: _SwipeSurface('Swipe up for a sheet'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
    );
  }
}

/// A tappable-looking surface that carries the swipe hint.
class _SwipeSurface extends StatelessWidget {
  const _SwipeSurface(this.hint);

  final String hint;

  @override
  Widget build(BuildContext context) {
    final ShadcnColors colors = ShadcnTheme.of(context).colors;
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: colors.muted,
        border: Border.all(color: colors.border),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(hint, style: TextStyle(color: colors.mutedForeground)),
    );
  }
}

/// The overlay body used by both variants.
class _Panel extends StatelessWidget {
  const _Panel({required this.title, required this.hint});

  final String title;
  final String hint;

  @override
  Widget build(BuildContext context) {
    final ShadcnColors colors = ShadcnTheme.of(context).colors;
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const Gap(8),
          Text(hint, style: TextStyle(color: colors.mutedForeground)),
        ],
      ),
    );
  }
}
