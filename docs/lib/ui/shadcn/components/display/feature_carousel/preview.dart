// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/material.dart' as m;

import 'feature_carousel.dart';
import '_impl/state/feature_carousel_controller.dart';
import '_impl/utils/feature_carousel_models.dart';

/// Core class used by the feature carousel component.
class FeatureCarouselPreview extends m.StatelessWidget {
  const FeatureCarouselPreview({super.key});

  @override
  m.Widget build(m.BuildContext context) {
    final items = [
      const FeatureCarouselItem(
        title: 'Add a Color Palette Selector',
        description:
            'Allow users to pick specific color palettes or dominant colors to refine their wallpaper generation.',
        icon: m.Icons.auto_awesome_rounded,
        accentColor: m.Color(0xFF7EA3FF),
      ),

      const FeatureCarouselItem(
        title: 'Add a Style Preset Picker',
        description:
            'Let users choose a curated style to guide generation with consistent aesthetics.',
        icon: m.Icons.palette_rounded,
        accentColor: m.Color(0xFF9B87FF),
      ),

      const FeatureCarouselItem(
        title: 'Add a Detail Slider',
        description:
            'Provide a slider to control complexity and sharpness without overwhelming options.',
        icon: m.Icons.tune_rounded,
        accentColor: m.Color(0xFF67D4FF),
      ),
    ];

    final controller = FeatureCarouselController(
      showCta: false,
      autoPlay: true,
      autoPlayInterval: const Duration(seconds: 4),
      cycleAnimationStyles: true,
      animationStyle: FeatureCarouselAnimationStyle.crossfadeScale,
    );

    return m.Scaffold(
      backgroundColor: const m.Color(0xFF121212),
      body: m.Center(
        child: FeatureCardCarousel(items: items, controller: controller),
      ),
    );
  }
}
