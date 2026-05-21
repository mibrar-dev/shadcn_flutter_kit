// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/widgets.dart';

import '../../../../../../shared/theme/theme.dart';
import '../../core/shad_slider_renderers.dart';
import '../../core/shad_slider_models.dart';

/// Theme data for [Slider] and [WaveSlider].
class SliderTheme extends ComponentThemeData {
  /// Track height in logical pixels.
  final double? trackHeight;

  /// Track radius in logical pixels. Clamped by runtime to half track height.
  final double? trackRadius;

  /// Base horizontal inset used for value-to-position mapping.
  final double? thumbInset;

  /// Thumb layout size used for paint and hit calculations.
  final Size? thumbSize;

  /// Optional corner radius for default bar thumb.
  final double? thumbRadius;

  /// Horizontal thumb edge offset.
  ///
  /// - `0`: inside track
  /// - positive: moves toward/outside edges
  /// - negative: moves further inside
  final double? thumbEdgeOffsetPx;

  /// Vertical thumb offset from track center.
  ///
  /// - positive: down
  /// - negative: up
  final double? thumbVerticalOffsetPx;

  /// Gap between active and remaining segments around thumb centers.
  final double? joinGapPx;

  /// Whether fill computations align to thumb centers.
  final bool? fillStopsAtThumbCenter;

  /// Extra fill edge bias in logical pixels.
  final double? fillEdgeBiasPx;

  /// Preset name (`brightness`, `rangeSoft`, `stepsDots`, `waveform`).
  final String? preset;

  /// Optional custom track builder.
  final ShadTrackBuilder? trackBuilder;

  /// Optional custom fill builder.
  final ShadFillBuilder? fillBuilder;

  /// Optional custom thumb builder.
  final ShadThumbBuilder? thumbBuilder;

  /// Optional custom ticks builder.
  final ShadTicksBuilder? ticksBuilder;

  /// Optional custom overlay builder.
  final ShadOverlayBuilder? overlayBuilder;

  /// Optional segment geometry strategy.
  final ShadSegmentLayout? segmentLayout;

  /// Optional unified track renderer.
  final ShadTrackRenderer? trackRenderer;

  /// Optional drag popover builder shown for active thumb while dragging.
  final ShadPopoverBuilder? dragPopoverBuilder;

  /// Popover anchor offset in logical pixels.
  final Offset? dragPopoverOffset;

  /// Visibility behavior for slider popovers.
  final ShadPopoverVisibility? dragPopoverVisibility;

  /// Popover shape used by built-in popover helpers.
  final ShadPopoverShape? popoverShape;

  /// Popover background color used by built-in popover helpers.
  final Color? popoverBackgroundColor;

  /// Popover foreground color used by built-in popover helpers.
  final Color? popoverForegroundColor;

  /// Guide line color used by default track builder.
  final Color? guideColor;

  /// Active fill color used by default fill builder.
  final Color? fillActiveColor;

  /// Remaining fill color used by default fill builder.
  final Color? fillInactiveColor;

  /// Default thumb fill color (applies to bar/square/circle helpers).
  final Color? thumbFillColor;

  /// Default thumb border color (applies to bar/square/circle helpers).
  final Color? thumbBorderColor;

  /// Active color for default dots ticks.
  final Color? dotsActiveColor;

  /// Inactive color for default dots ticks.
  final Color? dotsInactiveColor;

  /// Active inner-bar color for default waveform ticks.
  final Color? waveformTicksActiveColor;

  /// Inactive inner-bar color for default waveform ticks.
  final Color? waveformTicksInactiveColor;

  /// Wave variant height in logical pixels.
  final double? waveHeight;

  /// Wave variant content padding.
  final EdgeInsets? wavePadding;

  /// Wave bar width in logical pixels.
  final double? waveBarWidth;

  /// Wave bar gap in logical pixels.
  final double? waveBarGap;

  /// Wave minimum bar height in logical pixels.
  final double? waveMinBarHeight;

  /// Wave maximum bar height in logical pixels.
  final double? waveMaxBarHeight;

  /// Wave bar corner radius.
  final double? waveCornerRadius;

  /// Wave active/progressed color.
  final Color? waveActiveColor;

  /// Wave inactive/remaining color.
  final Color? waveInactiveColor;

  /// Wave disabled opacity.
  final double? waveDisabledOpacity;

  /// Whether wave slider shows thumb.
  final bool? waveShowThumb;

  /// Wave thumb radius.
  final double? waveThumbRadius;

  /// Wave thumb fill color.
  final Color? waveThumbColor;

  /// Wave thumb border color.
  final Color? waveThumbBorderColor;

  /// Wave thumb border width.
  final double? waveThumbBorderWidth;

  /// Wave hit slop for easier dragging.
  final double? waveHitSlop;

  /// Enables wave interaction.
  final bool? waveEnabled;

  /// Optional popover builder for [WaveSlider].
  final ShadPopoverBuilder? wavePopoverBuilder;

  /// Wave popover anchor offset.
  final Offset? wavePopoverOffset;

  /// Visibility behavior for [WaveSlider] popover.
  final ShadPopoverVisibility? wavePopoverVisibility;

  /// Creates theme overrides for [Slider] and [WaveSlider].
  const SliderTheme({
    /// Density token override for this component scope.
    super.themeDensity,

    /// Spacing token override for this component scope.
    super.themeSpacing,

    /// Shadow token override for this component scope.
    super.themeShadows,

    /// See [trackHeight].
    this.trackHeight,

    /// See [trackRadius].
    this.trackRadius,

    /// See [thumbInset].
    this.thumbInset,

    /// See [thumbSize].
    this.thumbSize,

    /// See [thumbRadius].
    this.thumbRadius,

    /// See [thumbEdgeOffsetPx].
    this.thumbEdgeOffsetPx,

    /// See [thumbVerticalOffsetPx].
    this.thumbVerticalOffsetPx,

    /// See [joinGapPx].
    this.joinGapPx,

    /// See [fillStopsAtThumbCenter].
    this.fillStopsAtThumbCenter,

    /// See [fillEdgeBiasPx].
    this.fillEdgeBiasPx,

    /// See [preset].
    this.preset,

    /// See [trackBuilder].
    this.trackBuilder,

    /// See [fillBuilder].
    this.fillBuilder,

    /// See [thumbBuilder].
    this.thumbBuilder,

    /// See [ticksBuilder].
    this.ticksBuilder,

    /// See [overlayBuilder].
    this.overlayBuilder,

    /// See [segmentLayout].
    this.segmentLayout,

    /// See [trackRenderer].
    this.trackRenderer,

    /// See [dragPopoverBuilder].
    this.dragPopoverBuilder,

    /// See [dragPopoverOffset].
    this.dragPopoverOffset,

    /// See [dragPopoverVisibility].
    this.dragPopoverVisibility,

    /// See [popoverShape].
    this.popoverShape,

    /// See [popoverBackgroundColor].
    this.popoverBackgroundColor,

    /// See [popoverForegroundColor].
    this.popoverForegroundColor,

    /// See [guideColor].
    this.guideColor,

    /// See [fillActiveColor].
    this.fillActiveColor,

    /// See [fillInactiveColor].
    this.fillInactiveColor,

    /// See [thumbFillColor].
    this.thumbFillColor,

    /// See [thumbBorderColor].
    this.thumbBorderColor,

    /// See [dotsActiveColor].
    this.dotsActiveColor,

    /// See [dotsInactiveColor].
    this.dotsInactiveColor,

    /// See [waveformTicksActiveColor].
    this.waveformTicksActiveColor,

    /// See [waveformTicksInactiveColor].
    this.waveformTicksInactiveColor,

    /// See [waveHeight].
    this.waveHeight,

    /// See [wavePadding].
    this.wavePadding,

    /// See [waveBarWidth].
    this.waveBarWidth,

    /// See [waveBarGap].
    this.waveBarGap,

    /// See [waveMinBarHeight].
    this.waveMinBarHeight,

    /// See [waveMaxBarHeight].
    this.waveMaxBarHeight,

    /// See [waveCornerRadius].
    this.waveCornerRadius,

    /// See [waveActiveColor].
    this.waveActiveColor,

    /// See [waveInactiveColor].
    this.waveInactiveColor,

    /// See [waveDisabledOpacity].
    this.waveDisabledOpacity,

    /// See [waveShowThumb].
    this.waveShowThumb,

    /// See [waveThumbRadius].
    this.waveThumbRadius,

    /// See [waveThumbColor].
    this.waveThumbColor,

    /// See [waveThumbBorderColor].
    this.waveThumbBorderColor,

    /// See [waveThumbBorderWidth].
    this.waveThumbBorderWidth,

    /// See [waveHitSlop].
    this.waveHitSlop,

    /// See [waveEnabled].
    this.waveEnabled,

    /// See [wavePopoverBuilder].
    this.wavePopoverBuilder,

    /// See [wavePopoverOffset].
    this.wavePopoverOffset,

    /// See [wavePopoverVisibility].
    this.wavePopoverVisibility,
  });

  /// Returns a copy with selected fields replaced.
  ///
  /// Only non-null getters are evaluated; omitted entries keep prior values.
  /// To clear an override, pass a getter that returns `null`.
  SliderTheme copyWith({
    /// Replacement for [trackHeight].
    ValueGetter<double?>? trackHeight,

    /// Replacement for [trackRadius].
    ValueGetter<double?>? trackRadius,

    /// Replacement for [thumbInset].
    ValueGetter<double?>? thumbInset,

    /// Replacement for [thumbSize].
    ValueGetter<Size?>? thumbSize,

    /// Replacement for [thumbRadius].
    ValueGetter<double?>? thumbRadius,

    /// Replacement for [thumbEdgeOffsetPx].
    ValueGetter<double?>? thumbEdgeOffsetPx,

    /// Replacement for [thumbVerticalOffsetPx].
    ValueGetter<double?>? thumbVerticalOffsetPx,

    /// Replacement for [joinGapPx].
    ValueGetter<double?>? joinGapPx,

    /// Replacement for [fillStopsAtThumbCenter].
    ValueGetter<bool?>? fillStopsAtThumbCenter,

    /// Replacement for [fillEdgeBiasPx].
    ValueGetter<double?>? fillEdgeBiasPx,

    /// Replacement for [preset].
    ValueGetter<String?>? preset,

    /// Replacement for [trackBuilder].
    ValueGetter<ShadTrackBuilder?>? trackBuilder,

    /// Replacement for [fillBuilder].
    ValueGetter<ShadFillBuilder?>? fillBuilder,

    /// Replacement for [thumbBuilder].
    ValueGetter<ShadThumbBuilder?>? thumbBuilder,

    /// Replacement for [ticksBuilder].
    ValueGetter<ShadTicksBuilder?>? ticksBuilder,

    /// Replacement for [overlayBuilder].
    ValueGetter<ShadOverlayBuilder?>? overlayBuilder,

    /// Replacement for [segmentLayout].
    ValueGetter<ShadSegmentLayout?>? segmentLayout,

    /// Replacement for [trackRenderer].
    ValueGetter<ShadTrackRenderer?>? trackRenderer,

    /// Replacement for [dragPopoverBuilder].
    ValueGetter<ShadPopoverBuilder?>? dragPopoverBuilder,

    /// Replacement for [dragPopoverOffset].
    ValueGetter<Offset?>? dragPopoverOffset,

    /// Replacement for [dragPopoverVisibility].
    ValueGetter<ShadPopoverVisibility?>? dragPopoverVisibility,

    /// Replacement for [popoverShape].
    ValueGetter<ShadPopoverShape?>? popoverShape,

    /// Replacement for [popoverBackgroundColor].
    ValueGetter<Color?>? popoverBackgroundColor,

    /// Replacement for [popoverForegroundColor].
    ValueGetter<Color?>? popoverForegroundColor,

    /// Replacement for [guideColor].
    ValueGetter<Color?>? guideColor,

    /// Replacement for [fillActiveColor].
    ValueGetter<Color?>? fillActiveColor,

    /// Replacement for [fillInactiveColor].
    ValueGetter<Color?>? fillInactiveColor,

    /// Replacement for [thumbFillColor].
    ValueGetter<Color?>? thumbFillColor,

    /// Replacement for [thumbBorderColor].
    ValueGetter<Color?>? thumbBorderColor,

    /// Replacement for [dotsActiveColor].
    ValueGetter<Color?>? dotsActiveColor,

    /// Replacement for [dotsInactiveColor].
    ValueGetter<Color?>? dotsInactiveColor,

    /// Replacement for [waveformTicksActiveColor].
    ValueGetter<Color?>? waveformTicksActiveColor,

    /// Replacement for [waveformTicksInactiveColor].
    ValueGetter<Color?>? waveformTicksInactiveColor,

    /// Replacement for [waveHeight].
    ValueGetter<double?>? waveHeight,

    /// Replacement for [wavePadding].
    ValueGetter<EdgeInsets?>? wavePadding,

    /// Replacement for [waveBarWidth].
    ValueGetter<double?>? waveBarWidth,

    /// Replacement for [waveBarGap].
    ValueGetter<double?>? waveBarGap,

    /// Replacement for [waveMinBarHeight].
    ValueGetter<double?>? waveMinBarHeight,

    /// Replacement for [waveMaxBarHeight].
    ValueGetter<double?>? waveMaxBarHeight,

    /// Replacement for [waveCornerRadius].
    ValueGetter<double?>? waveCornerRadius,

    /// Replacement for [waveActiveColor].
    ValueGetter<Color?>? waveActiveColor,

    /// Replacement for [waveInactiveColor].
    ValueGetter<Color?>? waveInactiveColor,

    /// Replacement for [waveDisabledOpacity].
    ValueGetter<double?>? waveDisabledOpacity,

    /// Replacement for [waveShowThumb].
    ValueGetter<bool?>? waveShowThumb,

    /// Replacement for [waveThumbRadius].
    ValueGetter<double?>? waveThumbRadius,

    /// Replacement for [waveThumbColor].
    ValueGetter<Color?>? waveThumbColor,

    /// Replacement for [waveThumbBorderColor].
    ValueGetter<Color?>? waveThumbBorderColor,

    /// Replacement for [waveThumbBorderWidth].
    ValueGetter<double?>? waveThumbBorderWidth,

    /// Replacement for [waveHitSlop].
    ValueGetter<double?>? waveHitSlop,

    /// Replacement for [waveEnabled].
    ValueGetter<bool?>? waveEnabled,

    /// Replacement for [wavePopoverBuilder].
    ValueGetter<ShadPopoverBuilder?>? wavePopoverBuilder,

    /// Replacement for [wavePopoverOffset].
    ValueGetter<Offset?>? wavePopoverOffset,

    /// Replacement for [wavePopoverVisibility].
    ValueGetter<ShadPopoverVisibility?>? wavePopoverVisibility,
  }) {
    return SliderTheme(
      trackHeight: trackHeight == null ? this.trackHeight : trackHeight(),
      trackRadius: trackRadius == null ? this.trackRadius : trackRadius(),
      thumbInset: thumbInset == null ? this.thumbInset : thumbInset(),
      thumbSize: thumbSize == null ? this.thumbSize : thumbSize(),
      thumbRadius: thumbRadius == null ? this.thumbRadius : thumbRadius(),
      thumbEdgeOffsetPx: thumbEdgeOffsetPx == null
          ? this.thumbEdgeOffsetPx
          : thumbEdgeOffsetPx(),
      thumbVerticalOffsetPx: thumbVerticalOffsetPx == null
          ? this.thumbVerticalOffsetPx
          : thumbVerticalOffsetPx(),
      joinGapPx: joinGapPx == null ? this.joinGapPx : joinGapPx(),
      fillStopsAtThumbCenter: fillStopsAtThumbCenter == null
          ? this.fillStopsAtThumbCenter
          : fillStopsAtThumbCenter(),
      fillEdgeBiasPx: fillEdgeBiasPx == null
          ? this.fillEdgeBiasPx
          : fillEdgeBiasPx(),
      preset: preset == null ? this.preset : preset(),
      trackBuilder: trackBuilder == null ? this.trackBuilder : trackBuilder(),
      fillBuilder: fillBuilder == null ? this.fillBuilder : fillBuilder(),
      thumbBuilder: thumbBuilder == null ? this.thumbBuilder : thumbBuilder(),
      ticksBuilder: ticksBuilder == null ? this.ticksBuilder : ticksBuilder(),
      overlayBuilder: overlayBuilder == null
          ? this.overlayBuilder
          : overlayBuilder(),
      segmentLayout: segmentLayout == null
          ? this.segmentLayout
          : segmentLayout(),
      trackRenderer: trackRenderer == null
          ? this.trackRenderer
          : trackRenderer(),
      dragPopoverBuilder: dragPopoverBuilder == null
          ? this.dragPopoverBuilder
          : dragPopoverBuilder(),
      dragPopoverOffset: dragPopoverOffset == null
          ? this.dragPopoverOffset
          : dragPopoverOffset(),
      dragPopoverVisibility: dragPopoverVisibility == null
          ? this.dragPopoverVisibility
          : dragPopoverVisibility(),
      popoverShape: popoverShape == null ? this.popoverShape : popoverShape(),
      popoverBackgroundColor: popoverBackgroundColor == null
          ? this.popoverBackgroundColor
          : popoverBackgroundColor(),
      popoverForegroundColor: popoverForegroundColor == null
          ? this.popoverForegroundColor
          : popoverForegroundColor(),
      guideColor: guideColor == null ? this.guideColor : guideColor(),
      fillActiveColor: fillActiveColor == null
          ? this.fillActiveColor
          : fillActiveColor(),
      fillInactiveColor: fillInactiveColor == null
          ? this.fillInactiveColor
          : fillInactiveColor(),
      thumbFillColor: thumbFillColor == null
          ? this.thumbFillColor
          : thumbFillColor(),
      thumbBorderColor: thumbBorderColor == null
          ? this.thumbBorderColor
          : thumbBorderColor(),
      dotsActiveColor: dotsActiveColor == null
          ? this.dotsActiveColor
          : dotsActiveColor(),
      dotsInactiveColor: dotsInactiveColor == null
          ? this.dotsInactiveColor
          : dotsInactiveColor(),
      waveformTicksActiveColor: waveformTicksActiveColor == null
          ? this.waveformTicksActiveColor
          : waveformTicksActiveColor(),
      waveformTicksInactiveColor: waveformTicksInactiveColor == null
          ? this.waveformTicksInactiveColor
          : waveformTicksInactiveColor(),
      waveHeight: waveHeight == null ? this.waveHeight : waveHeight(),
      wavePadding: wavePadding == null ? this.wavePadding : wavePadding(),
      waveBarWidth: waveBarWidth == null ? this.waveBarWidth : waveBarWidth(),
      waveBarGap: waveBarGap == null ? this.waveBarGap : waveBarGap(),
      waveMinBarHeight: waveMinBarHeight == null
          ? this.waveMinBarHeight
          : waveMinBarHeight(),
      waveMaxBarHeight: waveMaxBarHeight == null
          ? this.waveMaxBarHeight
          : waveMaxBarHeight(),
      waveCornerRadius: waveCornerRadius == null
          ? this.waveCornerRadius
          : waveCornerRadius(),
      waveActiveColor: waveActiveColor == null
          ? this.waveActiveColor
          : waveActiveColor(),
      waveInactiveColor: waveInactiveColor == null
          ? this.waveInactiveColor
          : waveInactiveColor(),
      waveDisabledOpacity: waveDisabledOpacity == null
          ? this.waveDisabledOpacity
          : waveDisabledOpacity(),
      waveShowThumb: waveShowThumb == null
          ? this.waveShowThumb
          : waveShowThumb(),
      waveThumbRadius: waveThumbRadius == null
          ? this.waveThumbRadius
          : waveThumbRadius(),
      waveThumbColor: waveThumbColor == null
          ? this.waveThumbColor
          : waveThumbColor(),
      waveThumbBorderColor: waveThumbBorderColor == null
          ? this.waveThumbBorderColor
          : waveThumbBorderColor(),
      waveThumbBorderWidth: waveThumbBorderWidth == null
          ? this.waveThumbBorderWidth
          : waveThumbBorderWidth(),
      waveHitSlop: waveHitSlop == null ? this.waveHitSlop : waveHitSlop(),
      waveEnabled: waveEnabled == null ? this.waveEnabled : waveEnabled(),
      wavePopoverBuilder: wavePopoverBuilder == null
          ? this.wavePopoverBuilder
          : wavePopoverBuilder(),
      wavePopoverOffset: wavePopoverOffset == null
          ? this.wavePopoverOffset
          : wavePopoverOffset(),
      wavePopoverVisibility: wavePopoverVisibility == null
          ? this.wavePopoverVisibility
          : wavePopoverVisibility(),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is SliderTheme &&
        other.trackHeight == trackHeight &&
        other.trackRadius == trackRadius &&
        other.thumbInset == thumbInset &&
        other.thumbSize == thumbSize &&
        other.thumbRadius == thumbRadius &&
        other.thumbEdgeOffsetPx == thumbEdgeOffsetPx &&
        other.thumbVerticalOffsetPx == thumbVerticalOffsetPx &&
        other.joinGapPx == joinGapPx &&
        other.fillStopsAtThumbCenter == fillStopsAtThumbCenter &&
        other.fillEdgeBiasPx == fillEdgeBiasPx &&
        other.preset == preset &&
        other.trackBuilder == trackBuilder &&
        other.fillBuilder == fillBuilder &&
        other.thumbBuilder == thumbBuilder &&
        other.ticksBuilder == ticksBuilder &&
        other.overlayBuilder == overlayBuilder &&
        other.segmentLayout == segmentLayout &&
        other.trackRenderer == trackRenderer &&
        other.dragPopoverBuilder == dragPopoverBuilder &&
        other.dragPopoverOffset == dragPopoverOffset &&
        other.dragPopoverVisibility == dragPopoverVisibility &&
        other.popoverShape == popoverShape &&
        other.popoverBackgroundColor == popoverBackgroundColor &&
        other.popoverForegroundColor == popoverForegroundColor &&
        other.guideColor == guideColor &&
        other.fillActiveColor == fillActiveColor &&
        other.fillInactiveColor == fillInactiveColor &&
        other.thumbFillColor == thumbFillColor &&
        other.thumbBorderColor == thumbBorderColor &&
        other.dotsActiveColor == dotsActiveColor &&
        other.dotsInactiveColor == dotsInactiveColor &&
        other.waveformTicksActiveColor == waveformTicksActiveColor &&
        other.waveformTicksInactiveColor == waveformTicksInactiveColor &&
        other.waveHeight == waveHeight &&
        other.wavePadding == wavePadding &&
        other.waveBarWidth == waveBarWidth &&
        other.waveBarGap == waveBarGap &&
        other.waveMinBarHeight == waveMinBarHeight &&
        other.waveMaxBarHeight == waveMaxBarHeight &&
        other.waveCornerRadius == waveCornerRadius &&
        other.waveActiveColor == waveActiveColor &&
        other.waveInactiveColor == waveInactiveColor &&
        other.waveDisabledOpacity == waveDisabledOpacity &&
        other.waveShowThumb == waveShowThumb &&
        other.waveThumbRadius == waveThumbRadius &&
        other.waveThumbColor == waveThumbColor &&
        other.waveThumbBorderColor == waveThumbBorderColor &&
        other.waveThumbBorderWidth == waveThumbBorderWidth &&
        other.waveHitSlop == waveHitSlop &&
        other.waveEnabled == waveEnabled &&
        other.wavePopoverBuilder == wavePopoverBuilder &&
        other.wavePopoverOffset == wavePopoverOffset &&
        other.wavePopoverVisibility == wavePopoverVisibility;
  }

  @override
  int get hashCode => Object.hashAll([
    trackHeight,
    trackRadius,
    thumbInset,
    thumbSize,
    thumbRadius,
    thumbEdgeOffsetPx,
    thumbVerticalOffsetPx,
    joinGapPx,
    fillStopsAtThumbCenter,
    fillEdgeBiasPx,
    preset,
    trackBuilder,
    fillBuilder,
    thumbBuilder,
    ticksBuilder,
    overlayBuilder,
    segmentLayout,
    trackRenderer,
    dragPopoverBuilder,
    dragPopoverOffset,
    dragPopoverVisibility,
    popoverShape,
    popoverBackgroundColor,
    popoverForegroundColor,
    guideColor,
    fillActiveColor,
    fillInactiveColor,
    thumbFillColor,
    thumbBorderColor,
    dotsActiveColor,
    dotsInactiveColor,
    waveformTicksActiveColor,
    waveformTicksInactiveColor,
    waveHeight,
    wavePadding,
    waveBarWidth,
    waveBarGap,
    waveMinBarHeight,
    waveMaxBarHeight,
    waveCornerRadius,
    waveActiveColor,
    waveInactiveColor,
    waveDisabledOpacity,
    waveShowThumb,
    waveThumbRadius,
    waveThumbColor,
    waveThumbBorderColor,
    waveThumbBorderWidth,
    waveHitSlop,
    waveEnabled,
    wavePopoverBuilder,
    wavePopoverOffset,
    wavePopoverVisibility,
  ]);
}
