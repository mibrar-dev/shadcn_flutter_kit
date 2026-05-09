// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/widgets.dart';

import '../../../carousel.dart';

// ═══════════════════════════════════════════════════════════
// COMPONENT THEME DEFAULTS
// Built-in defaults (never changes)
// Hard-coded widget/variant fallbacks are documented per field
// ═══════════════════════════════════════════════════════════

class CarouselThemeDefaults {
  final CarouselAlignment alignment;
  final Axis direction;
  final bool wrap;
  final bool pauseOnHover;
  final Duration? autoplaySpeed;
  final bool draggable;
  final Duration speed;
  final Curve curve;

  const CarouselThemeDefaults({
    this.alignment = CarouselAlignment.center,
    this.direction = Axis.horizontal,
    this.wrap = true,
    this.pauseOnHover = true,
    this.autoplaySpeed,
    this.draggable = true,
    this.speed = const Duration(milliseconds: 200),
    this.curve = Curves.easeInOut,
  });
}
