// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

// ═══════════════════════════════════════════════════════════
// COMPONENT THEME DEFAULTS
// Built-in defaults (never changes)
// Hard-coded widget/variant fallbacks are documented per field
// ═══════════════════════════════════════════════════════════

class SwiperThemeDefaults {
  const SwiperThemeDefaults({
    this.expands,
    this.draggable,
    this.barrierDismissible,
    this.backdropBuilder,
    this.useSafeArea,
    this.showDragHandle,
    this.borderRadius,
    this.dragHandleSize,
    this.transformBackdrop,
    this.surfaceOpacity,
    this.surfaceBlur,
    this.barrierColor,
    this.behavior = HitTestBehavior.translucent,
  });

  final bool? expands;
  final bool? draggable;
  final bool? barrierDismissible;
  final WidgetBuilder? backdropBuilder;
  final bool? useSafeArea;
  final bool? showDragHandle;
  final BorderRadiusGeometry? borderRadius;
  final Size? dragHandleSize;
  final bool? transformBackdrop;
  final double? surfaceOpacity;
  final double? surfaceBlur;
  final Color? barrierColor;
  final HitTestBehavior behavior;
}
