// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

// ═══════════════════════════════════════════════════════════
// COMPONENT THEME TOKENS
// User customization layer (replace this file from website output)
// ═══════════════════════════════════════════════════════════

class SwiperThemeTokens {
  const SwiperThemeTokens({
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
    this.ignoreGlobalScaling = false,
    this.ignoreGlobalRadius = false,
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
  final bool ignoreGlobalScaling;
  final bool ignoreGlobalRadius;
}

const swiperThemeTokens = SwiperThemeTokens();
