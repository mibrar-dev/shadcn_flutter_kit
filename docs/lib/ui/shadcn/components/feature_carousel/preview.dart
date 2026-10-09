// Gallery preview for the `feature_carousel` component: the default carousel,
// a scoped theme leg, an arrows/CTA-off variant and the dark palette.
// Widgets-only; the docs app embeds [FeatureCarouselPreview] directly.

import 'package:flutter/widgets.dart';

import '../../foundation/gap.dart';
import '../../foundation/icons/lucide_icons.dart';
import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';
import 'feature_carousel.dart';

/// Renders the feature carousel gallery.
class FeatureCarouselPreview extends StatefulWidget {
  /// Creates the preview.
  const FeatureCarouselPreview({super.key});

  @override
  State<FeatureCarouselPreview> createState() => _FeatureCarouselPreviewState();
}

class _FeatureCarouselPreviewState extends State<FeatureCarouselPreview> {
  late final FeatureCarouselController _controller = FeatureCarouselController(
    autoPlay: false,
    primaryActionLabel: 'Get started',
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
                _section('Default', _default()),
                const Gap(24),
                _section('Scoped theme', _scoped()),
                const Gap(24),
                _section('Cards only', _plain()),
                const Gap(24),
                _section('Dark', _dark()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _default() {
    return SizedBox(
      width: 420,
      child: FeatureCarousel(
        controller: _controller,
        items: const <FeatureCarouselItem>[
          FeatureCarouselItem(
            title: 'Fast',
            description: 'Ship a build in seconds.',
            icon: LucideIcons.zap,
          ),
          FeatureCarouselItem(
            title: 'Safe',
            description: 'Every deploy is immutable.',
            icon: LucideIcons.shield,
          ),
          FeatureCarouselItem(
            title: 'Insightful',
            description: 'Metrics for every release.',
            icon: LucideIcons.chartLine,
          ),
        ],
      ),
    );
  }

  Widget _scoped() {
    return SizedBox(
      width: 420,
      child: ComponentTheme<FeatureCarouselTheme>(
        data: const FeatureCarouselTheme(
          accentColor: ThemedColor.ref(ColorRef.chart2),
          cardFill: ThemedColor.ref(ColorRef.popover),
          radius: 20,
        ),
        child: FeatureCarousel(
          items: const <FeatureCarouselItem>[
            FeatureCarouselItem(title: 'Themed', icon: LucideIcons.sparkles),
            FeatureCarouselItem(title: 'Accent', icon: LucideIcons.star),
          ],
        ),
      ),
    );
  }

  Widget _plain() {
    return SizedBox(
      width: 420,
      child: FeatureCarousel(
        controller: FeatureCarouselController(
          autoPlay: false,
          showCta: false,
          showNavArrows: false,
        ),
        items: const <FeatureCarouselItem>[
          FeatureCarouselItem(title: 'Cards only', icon: LucideIcons.image),
          FeatureCarouselItem(title: 'No chrome', icon: LucideIcons.circle),
        ],
      ),
    );
  }

  Widget _dark() {
    return ShadcnTheme(
      data: const ShadcnThemeData(colors: ShadcnColors.darkFallback),
      child: SizedBox(
        width: 420,
        child: FeatureCarousel(
          items: const <FeatureCarouselItem>[
            FeatureCarouselItem(
              title: 'Dark',
              description: 'card / border tokens.',
              icon: LucideIcons.moon,
            ),
            FeatureCarouselItem(title: 'Second', icon: LucideIcons.sun),
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
