// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/widgets.dart';

import '../../../carousel.dart';

// ═══════════════════════════════════════════════════════════
// COMPONENT THEME TOKENS
// User customization layer (replace this file from website output)
// ═══════════════════════════════════════════════════════════

class CarouselThemeTokens {
  final CarouselAlignment alignment;
  final Axis direction;
  final bool wrap;
  final bool pauseOnHover;
  final Duration? autoplaySpeed;
  final bool draggable;
  final Duration speed;
  final Curve curve;
  final bool ignoreGlobalScaling;
  final bool ignoreGlobalRadius;

  const CarouselThemeTokens({
    this.alignment = CarouselAlignment.center,
    this.direction = Axis.horizontal,
    this.wrap = true,
    this.pauseOnHover = true,
    this.autoplaySpeed,
    this.draggable = true,
    this.speed = const Duration(milliseconds: 200),
    this.curve = Curves.easeInOut,
    this.ignoreGlobalScaling = false,
    this.ignoreGlobalRadius = false,
  });
}

const carouselThemeTokens = CarouselThemeTokens();
