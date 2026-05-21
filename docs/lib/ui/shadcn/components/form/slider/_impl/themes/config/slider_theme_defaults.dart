// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/widgets.dart';

import '../../core/shad_slider_models.dart';
import '../../core/shad_slider_renderers.dart';

// ═══════════════════════════════════════════════════════════
// COMPONENT THEME DEFAULTS
// Built-in defaults (never changes)
// Hard-coded widget/variant fallbacks are documented per field
// ═══════════════════════════════════════════════════════════

class SliderThemeDefaults {
  const SliderThemeDefaults({
    this.trackHeight = 28.0,
    this.trackRadius = 8.0,
    this.thumbInset = 10.0,
    this.thumbSize,
    this.thumbRadius,
    this.thumbEdgeOffsetPx,
    this.thumbVerticalOffsetPx = 0.0,
    this.joinGapPx = 2.0,
    this.fillStopsAtThumbCenter = true,
    this.fillEdgeBiasPx = 0.0,
    this.preset = 'brightness',
    this.trackBuilder,
    this.fillBuilder,
    this.thumbBuilder,
    this.ticksBuilder,
    this.overlayBuilder,
    this.segmentLayout,
    this.trackRenderer,
    this.dragPopoverBuilder,
    this.dragPopoverOffset = const Offset(0, -12),
    this.dragPopoverVisibility = ShadPopoverVisibility.whileDragging,
    this.popoverShape = ShadPopoverShape.rounded,
    this.popoverBackgroundColor = const Color(0xFF171717),
    this.popoverForegroundColor = const Color(0xFFFFFFFF),
    this.guideColor = const Color(0x0F0A0A0A),
    this.fillActiveColor = const Color(0xFF171717),
    this.fillInactiveColor = const Color(0xFFF5F5F5),
    this.thumbFillColor = const Color(0xFFFFFFFF),
    this.thumbBorderColor = const Color(0x1A0A0A0A),
    this.dotsActiveColor = const Color(0x2E0A0A0A),
    this.dotsInactiveColor = const Color(0x140A0A0A),
    this.waveformTicksActiveColor = const Color(0x85FFFFFF),
    this.waveformTicksInactiveColor,
    this.waveHeight = 44.0,
    this.wavePadding = const EdgeInsets.symmetric(horizontal: 8.0),
    this.waveBarWidth = 4.0,
    this.waveBarGap = 2.0,
    this.waveMinBarHeight = 6.0,
    this.waveMaxBarHeight = 40.0,
    this.waveCornerRadius = 8.0,
    this.waveActiveColor = const Color(0xFF171717),
    this.waveInactiveColor = const Color(0xBFF5F5F5),
    this.waveDisabledOpacity = 0.45,
    this.waveShowThumb = true,
    this.waveThumbRadius = 10.0,
    this.waveThumbColor = const Color(0xFFFFFFFF),
    this.waveThumbBorderColor = const Color(0x2E0A0A0A),
    this.waveThumbBorderWidth = 2.0,
    this.waveHitSlop = 8.0,
    this.waveEnabled = true,
    this.wavePopoverBuilder,
    this.wavePopoverOffset = const Offset(0, -12),
    this.wavePopoverVisibility = ShadPopoverVisibility.whileDragging,
  });

  final double trackHeight;
  final double trackRadius;
  final double thumbInset;
  final Size? thumbSize;
  final double? thumbRadius;
  final double? thumbEdgeOffsetPx;
  final double thumbVerticalOffsetPx;
  final double joinGapPx;
  final bool fillStopsAtThumbCenter;
  final double fillEdgeBiasPx;
  final String preset;
  final ShadTrackBuilder? trackBuilder;
  final ShadFillBuilder? fillBuilder;
  final ShadThumbBuilder? thumbBuilder;
  final ShadTicksBuilder? ticksBuilder;
  final ShadOverlayBuilder? overlayBuilder;
  final ShadSegmentLayout? segmentLayout;
  final ShadTrackRenderer? trackRenderer;
  final ShadPopoverBuilder? dragPopoverBuilder;
  final Offset dragPopoverOffset;
  final ShadPopoverVisibility dragPopoverVisibility;
  final ShadPopoverShape popoverShape;
  final Color popoverBackgroundColor;
  final Color popoverForegroundColor;
  final Color guideColor;
  final Color fillActiveColor;
  final Color fillInactiveColor;
  final Color thumbFillColor;
  final Color thumbBorderColor;
  final Color dotsActiveColor;
  final Color dotsInactiveColor;
  final Color waveformTicksActiveColor;
  final Color? waveformTicksInactiveColor;
  final double waveHeight;
  final EdgeInsets wavePadding;
  final double waveBarWidth;
  final double waveBarGap;
  final double waveMinBarHeight;
  final double waveMaxBarHeight;
  final double waveCornerRadius;
  final Color waveActiveColor;
  final Color waveInactiveColor;
  final double waveDisabledOpacity;
  final bool waveShowThumb;
  final double waveThumbRadius;
  final Color waveThumbColor;
  final Color waveThumbBorderColor;
  final double waveThumbBorderWidth;
  final double waveHitSlop;
  final bool waveEnabled;
  final ShadPopoverBuilder? wavePopoverBuilder;
  final Offset wavePopoverOffset;
  final ShadPopoverVisibility wavePopoverVisibility;
}
