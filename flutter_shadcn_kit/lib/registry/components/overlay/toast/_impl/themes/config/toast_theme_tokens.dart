// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/widgets.dart';

import '../../../toast.dart';

// ═══════════════════════════════════════════════════════════
// COMPONENT THEME TOKENS
// User customization layer (replace this file from website output)
// ═══════════════════════════════════════════════════════════

class ToastThemeTokens {
  const ToastThemeTokens({
    this.padding,
    this.margin = 8.0,
    this.duration = const Duration(seconds: 3),
    this.animationDuration = const Duration(milliseconds: 250),
    this.animationCurve = Curves.easeOut,
    this.width,
    this.borderRadius = 12.0,
    this.backgroundColor,
    this.pauseOnHover = false,
    this.dismissDirections,
    this.dismissDragThreshold = 72.0,
    this.overlapStackWhenMultiple,
    this.overlapStackOffset,
    this.pauseAutoDismissWhenMultiple,
    this.stackAnimationDuration,
    this.stackAnimationCurve,
    this.maxVisibleCount,
    this.dismissWholeStackWhenMultiple,
    this.ignoreGlobalScaling = false,
    this.ignoreGlobalRadius = false,
  });

  final EdgeInsetsGeometry? padding;
  final double margin;
  final Duration duration;
  final Duration animationDuration;
  final Curve animationCurve;
  final double? width;
  final double borderRadius;
  final Color? backgroundColor;
  final bool pauseOnHover;
  final Set<ToastSwipeDirection>? dismissDirections;
  final double dismissDragThreshold;
  final bool? overlapStackWhenMultiple;
  final double? overlapStackOffset;
  final bool? pauseAutoDismissWhenMultiple;
  final Duration? stackAnimationDuration;
  final Curve? stackAnimationCurve;
  final int? maxVisibleCount;
  final bool? dismissWholeStackWhenMultiple;
  final bool ignoreGlobalScaling;
  final bool ignoreGlobalRadius;
}

const toastThemeTokens = ToastThemeTokens();
