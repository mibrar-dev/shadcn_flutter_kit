// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'dart:math' as math;

import 'package:flutter/material.dart' hide Slider, SliderTheme, Theme;

import '../../../shared/theme/theme.dart';
import '../../../shared/utils/style_value.dart';

import '_impl/core/shad_slider_logic.dart';
import '_impl/core/shad_slider_models.dart';
import '_impl/core/shad_slider_renderers.dart';
import '_impl/styles/shad_slider_defaults.dart';
import '_impl/styles/shad_slider_presets.dart';
import '_impl/themes/base/slider_theme.dart';

export '_impl/core/shad_slider_renderers.dart';
export '_impl/variants/base_slider_variant.dart';
export '_impl/variants/brightness_slider.dart';
export '_impl/variants/range_soft_slider.dart';
export '_impl/variants/steps_dots_slider.dart';
export '_impl/variants/waveform_slider.dart';
export '_impl/variants/wave_slider.dart';

/// Registry slider widget with single and range modes.
///
/// Use [Slider.single] (or [Slider]) for a single value and [Slider.range]
/// for two-thumb range selection.
///
/// Thumb placement can be controlled with [thumbEdgeOffsetPx] and
/// [thumbVerticalOffsetPx].
class Slider extends StatefulWidget {
  const Slider._({
    super.key,
    required this.min,
    required this.max,
    required this.enabled,
    required this.snap,
    required this.trackHeight,
    required this.trackRadius,
    required this.thumbInset,
    required this.thumbSize,
    required this.thumbRadius,
    required this.thumbEdgeOffsetPx,
    required this.thumbVerticalOffsetPx,
    required this.joinGapPx,
    required this.fillStopsAtThumbCenter,
    required this.fillEdgeBiasPx,
    required this.preset,
    required this.value,
    required this.onChanged,
    required this.rangeValue,
    required this.onRangeChanged,
    required this.trackBuilder,
    required this.fillBuilder,
    required this.thumbBuilder,
    required this.ticksBuilder,
    required this.overlayBuilder,
    required this.segmentLayout,
    required this.trackRenderer,
    required this.dragPopoverBuilder,
    required this.dragPopoverOffset,
    required this.dragPopoverVisibility,
    required this.semanticLabel,
  });

  /// Creates a single-value slider.
  ///
  /// Alias of [Slider.single].
  factory Slider({
    /// Widget identity key.
    Key? key,

    /// Current single value.
    ///
    /// Clamped to `[min, max]` before rendering.
    required double value,

    /// Fired after drag/tap updates resolve.
    ///
    /// Receives clamped/snapped value.
    required ValueChanged<double> onChanged,

    /// Lower bound of slider domain.
    ///
    /// `0` starts at zero; negative values are allowed.
    double min = 0,

    /// Upper bound of slider domain.
    ///
    /// Must be greater than [min].
    double max = 1,

    /// Enables/disables interactions.
    bool enabled = true,

    /// Snapping mode for tap/drag output values.
    ShadSnap snap = const ShadSnap.none(),

    /// Track height override.
    double? trackHeight,

    /// Track radius override.
    double? trackRadius,

    /// Horizontal thumb inset override.
    double? thumbInset,

    /// Thumb size override.
    Size? thumbSize,

    /// Default thumb radius override.
    double? thumbRadius,

    /// Horizontal thumb offset override.
    ///
    /// `0` keeps baseline position; positive pushes outward.
    /// Negative pulls inward.
    double? thumbEdgeOffsetPx,

    /// Vertical thumb offset override.
    ///
    /// `0` centers; positive down; negative up.
    double? thumbVerticalOffsetPx,

    /// Segment gap around thumb centers.
    ///
    /// `0` joins segments directly.
    double? joinGapPx,

    /// Fill alignment mode relative to thumb center.
    bool? fillStopsAtThumbCenter,

    /// Fill edge bias override.
    ///
    /// `0` no bias; positive trims/offsets edge.
    double? fillEdgeBiasPx,

    /// Preset identifier (`brightness`, `rangeSoft`, `stepsDots`, `waveform`).
    String? preset,

    /// Custom track builder override.
    ShadTrackBuilder? trackBuilder,

    /// Custom fill builder override.
    ShadFillBuilder? fillBuilder,

    /// Custom thumb builder override.
    ShadThumbBuilder? thumbBuilder,

    /// Custom ticks builder override.
    ShadTicksBuilder? ticksBuilder,

    /// Custom overlay builder override.
    ShadOverlayBuilder? overlayBuilder,

    /// Segment layout override.
    ShadSegmentLayout? segmentLayout,

    /// Unified renderer override.
    ShadTrackRenderer? trackRenderer,

    /// Popover builder override.
    ShadPopoverBuilder? dragPopoverBuilder,

    /// Popover anchor offset override.
    Offset? dragPopoverOffset,

    /// Popover visibility override.
    ShadPopoverVisibility? dragPopoverVisibility,

    /// Accessibility label override.
    String? semanticLabel,
  }) {
    return Slider.single(
      key: key,
      value: value,
      onChanged: onChanged,
      min: min,
      max: max,
      enabled: enabled,
      snap: snap,
      trackHeight: trackHeight,
      trackRadius: trackRadius,
      thumbInset: thumbInset,
      thumbSize: thumbSize,
      thumbRadius: thumbRadius,
      thumbEdgeOffsetPx: thumbEdgeOffsetPx,
      thumbVerticalOffsetPx: thumbVerticalOffsetPx,
      joinGapPx: joinGapPx,
      fillStopsAtThumbCenter: fillStopsAtThumbCenter,
      fillEdgeBiasPx: fillEdgeBiasPx,
      preset: preset,
      trackBuilder: trackBuilder,
      fillBuilder: fillBuilder,
      thumbBuilder: thumbBuilder,
      ticksBuilder: ticksBuilder,
      overlayBuilder: overlayBuilder,
      segmentLayout: segmentLayout,
      trackRenderer: trackRenderer,
      dragPopoverBuilder: dragPopoverBuilder,
      dragPopoverOffset: dragPopoverOffset,
      dragPopoverVisibility: dragPopoverVisibility,
      semanticLabel: semanticLabel,
    );
  }

  /// Configures single-thumb slider behavior and visual overrides.
  ///
  /// Resolution order for nullable overrides is:
  /// explicit parameter -> [SliderTheme] -> preset/default values.
  factory Slider.single({
    /// Widget key.
    Key? key,

    /// Current single slider value.
    ///
    /// Expected in `[min, max]`. Values outside range are clamped.
    required double value,

    /// Called whenever the single value changes due to tap/drag.
    ///
    /// Receives the resolved value after clamping and optional snapping.
    required ValueChanged<double> onChanged,

    /// Lower bound of the slider domain.
    ///
    /// Value mapping starts from this number.
    double min = 0,

    /// Upper bound of the slider domain.
    ///
    /// Value mapping ends at this number. Must be greater than [min].
    double max = 1,

    /// Enables/disables gestures and callbacks.
    ///
    /// When false, slider is non-interactive and rendered as disabled.
    bool enabled = true,

    /// Snapping behavior for drag/tap updates.
    ///
    /// Use `none`, `steps(n)`, or explicit `values([...])`.
    ShadSnap snap = const ShadSnap.none(),

    /// Track height in logical pixels.
    ///
    /// If null, comes from theme tokens/preset defaults.
    double? trackHeight,

    /// Track corner radius in logical pixels.
    ///
    /// Final radius is clamped to half track height.
    double? trackRadius,

    /// Base horizontal inset used by track-to-value mapping.
    ///
    /// Higher values keep value centers away from both edges.
    double? thumbInset,

    /// Logical layout size for thumb painting + hit target calculations.
    ///
    /// Large sizes increase drag affordance and visible thumb area.
    Size? thumbSize,

    /// Radius override for default bar thumb corners.
    ///
    /// Ignored when a custom [thumbBuilder] is supplied.
    double? thumbRadius,

    /// Horizontal edge offset for thumb center mapping.
    ///
    /// `0` keeps thumb fully inside. Positive values push it toward/outside
    /// edges. Negative values pull it more inward.
    double? thumbEdgeOffsetPx,

    /// Vertical thumb offset from track center.
    ///
    /// Positive values move thumb down, negative move thumb up.
    double? thumbVerticalOffsetPx,

    /// Gap around thumb center between filled and remaining segments.
    ///
    /// Automatically collapses at exact min/max edges.
    double? joinGapPx,

    /// Whether fill geometry should align to thumb center.
    ///
    /// Presets may override behavior for style consistency.
    bool? fillStopsAtThumbCenter,

    /// Extra fill edge bias in logical pixels.
    ///
    /// Positive values trim/shift fill edges slightly.
    double? fillEdgeBiasPx,

    /// Preset name: `brightness`, `rangeSoft`, `stepsDots`, `waveform`.
    ///
    /// Determines default builders and tuned dimensions.
    String? preset,

    /// Custom track layer builder.
    ShadTrackBuilder? trackBuilder,

    /// Custom fill layer builder.
    ShadFillBuilder? fillBuilder,

    /// Custom thumb builder.
    ShadThumbBuilder? thumbBuilder,

    /// Custom ticks/marks builder.
    ShadTicksBuilder? ticksBuilder,

    /// Custom overlay builder above track/fill/thumbs.
    ShadOverlayBuilder? overlayBuilder,

    /// Segment geometry strategy.
    ShadSegmentLayout? segmentLayout,

    /// Unified track renderer.
    ShadTrackRenderer? trackRenderer,

    /// Custom popover shown while dragging.
    ShadPopoverBuilder? dragPopoverBuilder,

    /// Popover offset from thumb anchor.
    Offset? dragPopoverOffset,

    /// Controls when popover is visible.
    ShadPopoverVisibility? dragPopoverVisibility,

    /// Accessibility label used by semantics.
    String? semanticLabel,
  }) {
    return Slider._(
      key: key,
      min: min,
      max: max,
      enabled: enabled,
      snap: snap,
      trackHeight: trackHeight,
      trackRadius: trackRadius,
      thumbInset: thumbInset,
      thumbSize: thumbSize,
      thumbRadius: thumbRadius,
      thumbEdgeOffsetPx: thumbEdgeOffsetPx,
      thumbVerticalOffsetPx: thumbVerticalOffsetPx,
      joinGapPx: joinGapPx,
      fillStopsAtThumbCenter: fillStopsAtThumbCenter,
      fillEdgeBiasPx: fillEdgeBiasPx,
      preset: preset,
      value: value,
      onChanged: onChanged,
      rangeValue: null,
      onRangeChanged: null,
      trackBuilder: trackBuilder,
      fillBuilder: fillBuilder,
      thumbBuilder: thumbBuilder,
      ticksBuilder: ticksBuilder,
      overlayBuilder: overlayBuilder,
      segmentLayout: segmentLayout,
      trackRenderer: trackRenderer,
      dragPopoverBuilder: dragPopoverBuilder,
      dragPopoverOffset: dragPopoverOffset,
      dragPopoverVisibility: dragPopoverVisibility,
      semanticLabel: semanticLabel,
    );
  }

  /// Creates a range slider with start/end thumbs.
  ///
  /// For thumb placement:
  /// - [thumbEdgeOffsetPx] controls inside/outside horizontal placement.
  /// - [thumbVerticalOffsetPx] controls up/down placement.
  ///
  ///

  /// Configures two-thumb range slider behavior and visual overrides.
  ///
  /// Resolution order for nullable overrides is:
  /// explicit parameter -> [SliderTheme] -> preset/default values.
  factory Slider.range({
    /// Widget key.
    Key? key,

    /// Current range values (`start`, `end`) for the two thumbs.
    ///
    /// Values are normalized/clamped into `[min, max]`.
    required ShadRangeValue rangeValue,

    /// Called whenever range values change due to tap/drag.
    ///
    /// Receives normalized range after clamping/snap/min-range rules.
    required ValueChanged<ShadRangeValue> onChanged,

    /// Lower bound of the value domain.
    double min = 0,

    /// Upper bound of the value domain. Must be greater than [min].
    double max = 1,

    /// Enables/disables gestures and callbacks.
    bool enabled = true,

    /// Snapping behavior for both thumbs.
    ShadSnap snap = const ShadSnap.none(),

    /// Track height in logical pixels.
    double? trackHeight,

    /// Track corner radius in logical pixels.
    double? trackRadius,

    /// Base horizontal inset used by track-to-value mapping.
    double? thumbInset,

    /// Logical layout size for each thumb.
    Size? thumbSize,

    /// Radius override for default bar thumb corners.
    double? thumbRadius,

    /// Horizontal edge offset for thumb center mapping.
    ///
    /// `0` keeps thumbs inside. Positive values push toward/outside edges.
    double? thumbEdgeOffsetPx,

    /// Vertical thumb offset from track center.
    double? thumbVerticalOffsetPx,

    /// Gap around each thumb center for segmented fills.
    double? joinGapPx,

    /// Minimum allowed distance between `start` and `end`.
    double minRange = 0,

    /// If true, thumbs may cross and swap roles while dragging.
    bool allowSwap = false,

    /// Whether fill geometry should align to thumb centers.
    bool? fillStopsAtThumbCenter,

    /// Extra fill edge bias in logical pixels.
    double? fillEdgeBiasPx,

    /// Preset name: `brightness`, `rangeSoft`, `stepsDots`, `waveform`.
    String? preset,

    /// Custom track layer builder.
    ShadTrackBuilder? trackBuilder,

    /// Custom fill layer builder.
    ShadFillBuilder? fillBuilder,

    /// Custom thumb builder.
    ShadThumbBuilder? thumbBuilder,

    /// Custom ticks/marks builder.
    ShadTicksBuilder? ticksBuilder,

    /// Custom overlay builder above track/fill/thumbs.
    ShadOverlayBuilder? overlayBuilder,

    /// Segment geometry strategy.
    ShadSegmentLayout? segmentLayout,

    /// Unified track renderer.
    ShadTrackRenderer? trackRenderer,

    /// Custom popover shown while dragging.
    ShadPopoverBuilder? dragPopoverBuilder,

    /// Popover offset from thumb anchor.
    Offset? dragPopoverOffset,

    /// Controls when popover is visible.
    ShadPopoverVisibility? dragPopoverVisibility,

    /// Accessibility label used by semantics.
    String? semanticLabel,
  }) {
    final rv = rangeValue.copyWith(minRange: minRange, allowSwap: allowSwap);
    return Slider._(
      key: key,
      min: min,
      max: max,
      enabled: enabled,
      snap: snap,
      trackHeight: trackHeight,
      trackRadius: trackRadius,
      thumbInset: thumbInset,
      thumbSize: thumbSize,
      thumbRadius: thumbRadius,
      thumbEdgeOffsetPx: thumbEdgeOffsetPx,
      thumbVerticalOffsetPx: thumbVerticalOffsetPx,
      joinGapPx: joinGapPx,
      fillStopsAtThumbCenter: fillStopsAtThumbCenter,
      fillEdgeBiasPx: fillEdgeBiasPx,
      preset: preset,
      value: null,
      onChanged: null,
      rangeValue: rv,
      onRangeChanged: onChanged,
      trackBuilder: trackBuilder,
      fillBuilder: fillBuilder,
      thumbBuilder: thumbBuilder,
      ticksBuilder: ticksBuilder,
      overlayBuilder: overlayBuilder,
      segmentLayout: segmentLayout,
      trackRenderer: trackRenderer,
      dragPopoverBuilder: dragPopoverBuilder,
      dragPopoverOffset: dragPopoverOffset,
      dragPopoverVisibility: dragPopoverVisibility,
      semanticLabel: semanticLabel,
    );
  }

  /// Lower bound of the slider value domain.
  ///
  /// Current values are interpreted relative to this bound.
  final double min;

  /// Upper bound of the slider value domain.
  ///
  /// Must be greater than [min].
  final double max;

  /// Enables or disables user interaction.
  ///
  /// When false, drag/tap callbacks are not emitted.
  final bool enabled;

  /// Snapping strategy applied during drag/tap updates.
  ///
  /// Use [ShadSnap.none], [ShadSnap.steps], or [ShadSnap.values].
  final ShadSnap snap;

  /// Track height in logical pixels.
  ///
  /// If null, resolves from theme/preset defaults.
  final double? trackHeight;

  /// Track corner radius in logical pixels.
  ///
  /// Runtime-clamped to `trackHeight / 2`.
  final double? trackRadius;

  /// Base horizontal inset used for value-to-position mapping.
  ///
  /// Higher values keep thumb centers farther from outer edges.
  final double? thumbInset;

  /// Thumb layout size used for paint and hit target calculations.
  ///
  /// Large values increase thumb footprint and gesture area.
  final Size? thumbSize;

  /// Optional corner radius for the default bar thumb.
  ///
  /// Ignored when [thumbBuilder] is provided.
  final double? thumbRadius;

  /// Horizontal thumb edge offset in logical pixels.
  ///
  /// - `0`: keeps thumb inside the track bounds.
  /// - positive: moves thumb outward toward/outside edges.
  /// - negative: moves thumb further inward.
  final double? thumbEdgeOffsetPx;

  /// Vertical thumb offset from track center in logical pixels.
  ///
  /// - `0`: centered on track
  /// - positive: moves thumb down
  /// - negative: moves thumb up
  final double? thumbVerticalOffsetPx;

  /// Gap between active and remaining segments around thumb centers.
  ///
  /// Gap automatically collapses at min/max ends.
  final double? joinGapPx;

  /// Whether fill edge alignment is centered around thumb centers.
  ///
  /// Presets may override this for specific visuals.
  final bool? fillStopsAtThumbCenter;

  /// Extra fill edge bias in logical pixels.
  ///
  /// Positive values trim/shift fill edges slightly.
  final double? fillEdgeBiasPx;

  /// Preset name used to resolve default builders and tuned dimensions.
  ///
  /// Supported values: `brightness`, `rangeSoft`, `stepsDots`, `waveform`.
  final String? preset;

  /// Single-mode value.
  ///
  /// Used when [isRange] is false.
  final double? value;

  /// Single-mode change callback.
  ///
  /// Receives clamped/snapped values.
  final ValueChanged<double>? onChanged;

  /// Range-mode value.
  ///
  /// Used when [isRange] is true.
  final ShadRangeValue? rangeValue;

  /// Range-mode change callback.
  ///
  /// Receives normalized clamped/snapped ranges.
  final ValueChanged<ShadRangeValue>? onRangeChanged;

  /// Custom track renderer.
  final ShadTrackBuilder? trackBuilder;

  /// Custom fill renderer.
  final ShadFillBuilder? fillBuilder;

  /// Custom thumb renderer.
  final ShadThumbBuilder? thumbBuilder;

  /// Custom ticks/marks renderer.
  final ShadTicksBuilder? ticksBuilder;

  /// Custom overlay renderer above track/fill/thumbs.
  final ShadOverlayBuilder? overlayBuilder;

  /// Segment geometry strategy.
  final ShadSegmentLayout? segmentLayout;

  /// Unified track renderer.
  final ShadTrackRenderer? trackRenderer;

  /// Custom popover shown while dragging.
  final ShadPopoverBuilder? dragPopoverBuilder;

  /// Popover offset from thumb anchor.
  final Offset? dragPopoverOffset;

  /// Controls when popover is visible.
  final ShadPopoverVisibility? dragPopoverVisibility;

  /// Optional accessibility label.
  final String? semanticLabel;

  /// Whether this widget is currently operating in range mode.
  ///
  /// Returns `true` when [rangeValue] is non-null and single-value callbacks
  /// are ignored. Returns `false` for single mode.
  bool get isRange => rangeValue != null;

  /// Creates state that handles gesture updates and resolved rendering.
  @override
  State<Slider> createState() => _SliderState();
}

class _SliderState extends State<Slider> {
  late final ShadSliderLogic _logic;
  int? _activeThumb;
  bool _dragging = false;

  @override
  void initState() {
    super.initState();
    _logic = ShadSliderLogic();
  }

  void _emitSingle(double v) {
    if (!widget.enabled) return;
    widget.onChanged?.call(v);
  }

  void _emitRange(ShadRangeValue rv) {
    if (!widget.enabled) return;
    widget.onRangeChanged?.call(rv);
  }

  ShadSliderPreset _parsePreset(String name, {required bool isRange}) {
    switch (name) {
      case 'stepsDots':
        return ShadSliderPreset.stepsDots;
      case 'waveform':
        return ShadSliderPreset.waveform;
      case 'rangeSoft':
        return ShadSliderPreset.rangeSoft;
      case 'brightness':
      default:
        return isRange
            ? ShadSliderPreset.rangeSoft
            : ShadSliderPreset.brightness;
    }
  }

  @override
  Widget build(BuildContext context) {
    assert(widget.max > widget.min);
    final theme = Theme.of(context);
    final baseGap = theme.density.baseGap * theme.scaling;
    final compTheme = ComponentTheme.maybeOf<SliderTheme>(context);

    final resolvedTrackHeight = styleValue(
      widgetValue: widget.trackHeight,
      themeValue: compTheme?.trackHeight,
      defaultValue: baseGap * 3.5,
    );
    final resolvedTrackRadius = styleValue(
      widgetValue: widget.trackRadius,
      themeValue: compTheme?.trackRadius,
      defaultValue: theme.radiusLg,
    );
    final resolvedThumbInset = styleValue(
      widgetValue: widget.thumbInset,
      themeValue: compTheme?.thumbInset,
      defaultValue: baseGap * 1.25,
    );
    final resolvedThumbSizeOverride = styleValue<Size?>(
      widgetValue: widget.thumbSize,
      themeValue: compTheme?.thumbSize,
      defaultValue: null,
    );
    final resolvedJoinGapPx = styleValue(
      widgetValue: widget.joinGapPx,
      themeValue: compTheme?.joinGapPx,
      defaultValue: baseGap * 0.25,
    );
    final resolvedThumbRadius = styleValue(
      widgetValue: widget.thumbRadius,
      themeValue: compTheme?.thumbRadius,
      defaultValue: null,
    );
    final resolvedThumbEdgeOffsetOverride = styleValue<double?>(
      widgetValue: widget.thumbEdgeOffsetPx,
      themeValue: compTheme?.thumbEdgeOffsetPx,
      defaultValue: null,
    );
    final resolvedThumbVerticalOffsetPx = styleValue(
      widgetValue: widget.thumbVerticalOffsetPx,
      themeValue: compTheme?.thumbVerticalOffsetPx,
      defaultValue: 0.0,
    );
    final resolvedFillStopsAtThumbCenter = styleValue(
      widgetValue: widget.fillStopsAtThumbCenter,
      themeValue: compTheme?.fillStopsAtThumbCenter,
      defaultValue: true,
    );
    final resolvedFillEdgeBiasPx = styleValue(
      widgetValue: widget.fillEdgeBiasPx,
      themeValue: compTheme?.fillEdgeBiasPx,
      defaultValue: 0.0,
    );
    final resolvedPresetName = styleValue(
      widgetValue: widget.preset,
      themeValue: compTheme?.preset,
      defaultValue: widget.isRange ? 'rangeSoft' : 'brightness',
    );
    final resolvedTrackBuilder = styleValue(
      widgetValue: widget.trackBuilder,
      themeValue: compTheme?.trackBuilder,
      defaultValue: null,
    );
    final resolvedFillBuilder = styleValue(
      widgetValue: widget.fillBuilder,
      themeValue: compTheme?.fillBuilder,
      defaultValue: null,
    );
    final resolvedThumbBuilder = styleValue(
      widgetValue: widget.thumbBuilder,
      themeValue: compTheme?.thumbBuilder,
      defaultValue: null,
    );
    final resolvedTicksBuilder = styleValue(
      widgetValue: widget.ticksBuilder,
      themeValue: compTheme?.ticksBuilder,
      defaultValue: null,
    );
    final resolvedOverlayBuilder = styleValue(
      widgetValue: widget.overlayBuilder,
      themeValue: compTheme?.overlayBuilder,
      defaultValue: null,
    );
    final resolvedSegmentLayout = styleValue<ShadSegmentLayout?>(
      widgetValue: widget.segmentLayout,
      themeValue: compTheme?.segmentLayout,
      defaultValue: null,
    );
    final resolvedTrackRenderer = styleValue<ShadTrackRenderer?>(
      widgetValue: widget.trackRenderer,
      themeValue: compTheme?.trackRenderer,
      defaultValue: null,
    );
    final resolvedDragPopoverBuilder = styleValue<ShadPopoverBuilder?>(
      widgetValue: widget.dragPopoverBuilder,
      themeValue: compTheme?.dragPopoverBuilder,
      defaultValue: null,
    );
    final resolvedDragPopoverOffset = styleValue<Offset>(
      widgetValue: widget.dragPopoverOffset,
      themeValue: compTheme?.dragPopoverOffset,
      defaultValue: const Offset(0, -12),
    );
    final resolvedDragPopoverVisibility = styleValue<ShadPopoverVisibility>(
      widgetValue: widget.dragPopoverVisibility,
      themeValue: compTheme?.dragPopoverVisibility,
      defaultValue: ShadPopoverVisibility.whileDragging,
    );

    final preset = _parsePreset(resolvedPresetName, isRange: widget.isRange);
    final resolved = resolveShadSliderPreset(
      context,
      preset: preset,
      trackHeight: resolvedTrackHeight,
      thumbInset: resolvedThumbInset,
      fillEdgeBiasPx: resolvedFillEdgeBiasPx,
      trackBuilder: resolvedTrackBuilder,
      fillBuilder: resolvedFillBuilder,
      thumbBuilder: resolvedThumbBuilder,
      ticksBuilder: resolvedTicksBuilder,
      overlayBuilder: resolvedOverlayBuilder,
    );
    final defaults = ShadSliderDefaults.of(context);
    final effectiveThumbBuilder =
        (identical(resolved.thumbBuilder, defaults.thumbBuilder) &&
            resolvedThumbRadius != null)
        ? ShadSliderDefaults.barThumb(radius: resolvedThumbRadius)
        : resolved.thumbBuilder;
    final isCircleThumb = identical(
      effectiveThumbBuilder,
      ShadSliderDefaults.circleThumb,
    );
    final resolvedJoinGapForThumb = resolvedJoinGapPx;
    final resolvedThumbSize =
        resolvedThumbSizeOverride ??
        (isCircleThumb
            ? Size(baseGap * 3.0, baseGap * 3.0)
            : Size(baseGap * 2.5, baseGap * 3.5));
    final resolvedThumbEdgeOffsetPx =
        resolvedThumbEdgeOffsetOverride ??
        (isCircleThumb ? resolvedThumbSize.width / 2 : 0.0);
    final effectiveSegmentLayout =
        resolvedSegmentLayout ??
        ShadJoinGapLayout(
          gapPx: resolvedJoinGapForThumb,
          endsPolicy: ShadGapEndsPolicy.noneAtMinMax,
          segmentRadius: ShadSegmentRadiusPolicy.fullPills,
        );
    final effectiveTrackRenderer =
        resolvedTrackRenderer ??
        ShadLegacyBuildersRenderer(
          trackBuilder: resolved.trackBuilder,
          fillBuilder: resolved.fillBuilder,
          ticksBuilder: resolved.ticksBuilder,
        );

    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final h = resolved.trackHeight;
        final canvasHeight = math.max(h, resolvedThumbSize.height);
        final trackTop = (canvasHeight - h) / 2;
        final radius = resolvedTrackRadius.clamp(0.0, h / 2).toDouble();
        final dir = Directionality.of(context);
        final trackRect = Rect.fromLTWH(0, trackTop, w, h);

        final view = _logic.buildView(
          min: widget.min,
          max: widget.max,
          snap: widget.snap,
          enabled: widget.enabled,
          trackRect: trackRect,
          trackRadius: radius,
          thumbInset: resolved.thumbInset,
          dragging: _dragging,
          activeThumb: _activeThumb,
          fillStopsAtThumbCenter: resolvedFillStopsAtThumbCenter,
          fillEdgeBiasPx: resolved.fillEdgeBiasPx,
          joinGapPx: resolvedJoinGapForThumb,
          thumbEdgeOffsetPx: resolvedThumbEdgeOffsetPx,
          thumbVerticalOffsetPx: resolvedThumbVerticalOffsetPx,
          segmentLayout: effectiveSegmentLayout,
          textDirection: dir,
          value: widget.value,
          rangeValue: widget.rangeValue,
          thumbSize: resolvedThumbSize,
        );

        Widget content = SizedBox(
          height: canvasHeight,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              effectiveTrackRenderer.build(context, view),
              for (final t in view.thumbs)
                Positioned(
                  left: t.center.dx - t.size.width / 2,
                  top: t.center.dy - t.size.height / 2,
                  child: effectiveThumbBuilder(context, t),
                ),
              if (resolvedDragPopoverBuilder != null &&
                  view.thumbs.isNotEmpty &&
                  resolvedDragPopoverVisibility !=
                      ShadPopoverVisibility.never &&
                  (resolvedDragPopoverVisibility ==
                          ShadPopoverVisibility.always ||
                      _dragging))
                Builder(
                  builder: (context) {
                    final idx = (_activeThumb ?? 0).clamp(
                      0,
                      view.thumbs.length - 1,
                    );
                    final active = view.thumbs[idx];
                    return Positioned(
                      left: active.center.dx + resolvedDragPopoverOffset.dx,
                      top:
                          active.center.dy -
                          active.size.height / 2 +
                          resolvedDragPopoverOffset.dy,
                      child: FractionalTranslation(
                        translation: const Offset(-0.5, -1.0),
                        child: IgnorePointer(
                          child: resolvedDragPopoverBuilder(
                            context,
                            ShadPopoverData(
                              value: active.value,
                              normalizedValue: active.t,
                              isDragging: _dragging,
                              thumbIndex: idx,
                              state: view,
                              thumb: active,
                              meta: <String, Object?>{
                                'isRange': widget.isRange,
                                'min': widget.min,
                                'max': widget.max,
                              },
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              resolved.overlayBuilder(context, view),
            ],
          ),
        );

        content = GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: widget.enabled
              ? (d) {
                  final hit = _logic.hitTest(
                    view: view,
                    localPosition: d.localPosition,
                  );
                  _activeThumb = hit.activeThumb;
                  final next = _logic.updateFromDx(
                    view: view,
                    snap: widget.snap,
                    dx: d.localPosition.dx,
                    thumbIndex: _activeThumb ?? 0,
                  );
                  if (next.singleValue != null) _emitSingle(next.singleValue!);
                  if (next.rangeValue != null) _emitRange(next.rangeValue!);
                }
              : null,
          onHorizontalDragStart: widget.enabled
              ? (d) => setState(() {
                  _dragging = true;
                  _activeThumb = _logic.pickActiveThumb(
                    view: view,
                    dx: d.localPosition.dx,
                  );
                })
              : null,
          onHorizontalDragUpdate: widget.enabled
              ? (d) {
                  final next = _logic.updateFromDx(
                    view: view,
                    snap: widget.snap,
                    dx: d.localPosition.dx,
                    thumbIndex: _activeThumb ?? 0,
                  );
                  if (next.singleValue != null) _emitSingle(next.singleValue!);
                  if (next.rangeValue != null) _emitRange(next.rangeValue!);
                }
              : null,
          onHorizontalDragEnd: widget.enabled
              ? (_) => setState(() {
                  _dragging = false;
                  _activeThumb = null;
                })
              : null,
          onHorizontalDragCancel: widget.enabled
              ? () => setState(() {
                  _dragging = false;
                  _activeThumb = null;
                })
              : null,
          child: content,
        );

        return Semantics(
          label: widget.semanticLabel,
          enabled: widget.enabled,
          slider: true,
          child: content,
        );
      },
    );
  }
}
