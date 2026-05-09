// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/widgets.dart';

import '../../../gooey_toast.dart';

// ═══════════════════════════════════════════════════════════
// COMPONENT THEME TOKENS
// User customization layer (replace this file from website output)
// ═══════════════════════════════════════════════════════════

class GooeyToastThemeTokens {
  const GooeyToastThemeTokens({
    this.width = GooeyToastDefaults.toastWidth,
    this.fill = GooeyToastDefaults.fill,
    this.roundness = GooeyToastDefaults.roundness,
    this.titleStyle,
    this.descriptionStyle,
    this.pauseOnHover = GooeyToastDefaults.pauseOnHover,
    this.swipeToDismiss = GooeyToastDefaults.swipeToDismiss,
    this.dismissDirections,
    this.dismissDragThreshold = GooeyToastDefaults.dismissDragThreshold,
    this.spacing = GooeyToastDefaults.spacing,
    this.overlapStackWhenMultiple,
    this.overlapStackOffset,
    this.pauseAutoDismissWhenMultiple,
    this.stackAnimationDuration,
    this.stackAnimationCurve,
    this.maxVisibleCount,
    this.dismissWholeStackWhenMultiple,
    this.animationStyle = GooeyToastDefaults.animationStyle,
    this.shapeStyle = GooeyToastDefaults.shapeStyle,
    this.bodyAnimationStyle = GooeyToastDefaults.bodyAnimationStyle,
    this.enableGooeyBlur = GooeyToastDefaults.enableGooeyBlur,
    this.successTone = GooeyToastDefaults.successTone,
    this.loadingTone = GooeyToastDefaults.loadingTone,
    this.errorTone = GooeyToastDefaults.errorTone,
    this.warningTone = GooeyToastDefaults.warningTone,
    this.infoTone = GooeyToastDefaults.infoTone,
    this.actionTone = GooeyToastDefaults.actionTone,
    this.ignoreGlobalScaling = false,
    this.ignoreGlobalRadius = false,
  });

  final double width;
  final Color fill;
  final double roundness;
  final TextStyle? titleStyle;
  final TextStyle? descriptionStyle;
  final bool pauseOnHover;
  final bool swipeToDismiss;
  final Set<GooeyToastSwipeDirection>? dismissDirections;
  final double dismissDragThreshold;
  final double spacing;
  final bool? overlapStackWhenMultiple;
  final double? overlapStackOffset;
  final bool? pauseAutoDismissWhenMultiple;
  final Duration? stackAnimationDuration;
  final Curve? stackAnimationCurve;
  final int? maxVisibleCount;
  final bool? dismissWholeStackWhenMultiple;
  final GooeyToastAnimationStyle animationStyle;
  final GooeyToastShapeStyle shapeStyle;
  final GooeyToastBodyAnimationStyle bodyAnimationStyle;
  final bool enableGooeyBlur;
  final Color successTone;
  final Color loadingTone;
  final Color errorTone;
  final Color warningTone;
  final Color infoTone;
  final Color actionTone;
  final bool ignoreGlobalScaling;
  final bool ignoreGlobalRadius;
}

const gooeyToastThemeTokens = GooeyToastThemeTokens();
