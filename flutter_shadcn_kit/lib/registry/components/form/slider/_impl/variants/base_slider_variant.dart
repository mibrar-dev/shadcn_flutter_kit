// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/widgets.dart';

import '../core/shad_slider_renderers.dart';
import '../core/shad_slider_models.dart';
import '../../slider.dart';

/// Shared single-slider variant base.
abstract class SingleSliderVariantBase extends StatelessWidget {
  const SingleSliderVariantBase({
    /// Passes identity through the widget tree.
    super.key,

    /// Current single-thumb value for this variant.
    ///
    /// Input is clamped to `[min, max]` before rendering.
    required this.value,

    /// Fired after tap/drag updates are snapped/clamped.
    ///
    /// Receives the resolved single value in `[min, max]`.
    required this.onChanged,

    /// Lower bound of the variant domain.
    ///
    /// `0` starts at zero; negative values allow negative ranges.
    this.min = 0,

    /// Upper bound of the variant domain.
    ///
    /// Must be greater than [min].
    this.max = 1,

    /// Enables/disables interaction callbacks.
    ///
    /// `false` keeps visuals but blocks updates.
    this.enabled = true,

    /// Snapping strategy for drag/tap gestures.
    ///
    /// `none` keeps continuous values; step/value modes quantize output.
    this.snap = const ShadSnap.none(),

    /// Track height override.
    ///
    /// `0` collapses track; positive values increase thickness.
    this.trackHeight,

    /// Track corner radius override.
    ///
    /// `0` gives square corners; positive values round corners.
    this.trackRadius,

    /// Horizontal inset used for thumb center mapping.
    ///
    /// `0` maps full width; positive values pull centers inward.
    this.thumbInset,

    /// Thumb layout size override.
    ///
    /// Larger values increase painted thumb footprint and hit target.
    this.thumbSize,

    /// Corner radius for default bar thumb.
    ///
    /// `0` makes square edges; positive values round it.
    this.thumbRadius,

    /// Horizontal thumb offset.
    ///
    /// `0` keeps baseline placement. Positive moves outward.
    /// Negative moves inward.
    this.thumbEdgeOffsetPx,

    /// Vertical thumb offset from track center.
    ///
    /// `0` centers; positive moves down; negative moves up.
    this.thumbVerticalOffsetPx,

    /// Gap near thumb between active and remaining segments.
    ///
    /// `0` joins segments directly. Positive values add separation.
    this.joinGapPx,

    /// Whether fill edges align to thumb centers.
    this.fillStopsAtThumbCenter,

    /// Additional pixel bias for fill edges.
    ///
    /// `0` means no bias. Positive trims/offsets fill.
    this.fillEdgeBiasPx,

    /// Custom base track painter.
    ///
    /// If null, preset/theme/default implementation is used.
    this.trackBuilder,

    /// Custom active/remaining fill painter.
    ///
    /// If null, preset/theme/default implementation is used.
    this.fillBuilder,

    /// Custom thumb widget builder.
    ///
    /// If null, preset/theme/default implementation is used.
    this.thumbBuilder,

    /// Custom ticks/marks painter.
    ///
    /// If null, preset/theme/default implementation is used.
    this.ticksBuilder,

    /// Optional overlay layer above track/thumb/ticks.
    this.overlayBuilder,

    /// Segment geometry strategy override.
    this.segmentLayout,

    /// Unified renderer override for track/fill/ticks.
    this.trackRenderer,

    /// Popover builder for value labels.
    this.dragPopoverBuilder,

    /// Popover anchor offset.
    ///
    /// Positive `dx` moves right. Negative `dy` moves up.
    this.dragPopoverOffset,

    /// Popover visibility policy.
    this.dragPopoverVisibility,

    /// Optional semantics label override.
    this.semanticLabel,
  });

  /// Current single-thumb value.
  final double value;

  /// Callback for resolved value updates.
  final ValueChanged<double> onChanged;

  /// Lower bound for value mapping.
  final double min;

  /// Upper bound for value mapping.
  final double max;

  /// Whether gestures are enabled.
  final bool enabled;

  /// Snap strategy for updates.
  final ShadSnap snap;

  /// Track height override.
  final double? trackHeight;

  /// Track corner radius override.
  final double? trackRadius;

  /// Horizontal thumb inset override.
  final double? thumbInset;

  /// Thumb layout size override.
  final Size? thumbSize;

  /// Default bar thumb corner radius override.
  final double? thumbRadius;

  /// Horizontal thumb placement offset.
  final double? thumbEdgeOffsetPx;

  /// Vertical thumb placement offset.
  final double? thumbVerticalOffsetPx;

  /// Gap near thumb between segments.
  final double? joinGapPx;

  /// Fill alignment mode relative to thumb center.
  final bool? fillStopsAtThumbCenter;

  /// Pixel bias applied to fill edges.
  final double? fillEdgeBiasPx;

  /// Custom track layer builder.
  final ShadTrackBuilder? trackBuilder;

  /// Custom fill layer builder.
  final ShadFillBuilder? fillBuilder;

  /// Custom thumb builder.
  final ShadThumbBuilder? thumbBuilder;

  /// Custom ticks builder.
  final ShadTicksBuilder? ticksBuilder;

  /// Custom overlay builder.
  final ShadOverlayBuilder? overlayBuilder;

  /// Segment layout override.
  final ShadSegmentLayout? segmentLayout;

  /// Unified renderer override.
  final ShadTrackRenderer? trackRenderer;

  /// Popover builder override.
  final ShadPopoverBuilder? dragPopoverBuilder;

  /// Popover offset override.
  final Offset? dragPopoverOffset;

  /// Popover visibility override.
  final ShadPopoverVisibility? dragPopoverVisibility;

  /// Accessibility label override.
  final String? semanticLabel;

  /// Preset identifier forwarded to [Slider.single].
  String get presetName;

  /// Snap strategy used by this variant.
  ShadSnap get resolvedSnap => snap;

  /// Builds [Slider.single] with this variant's preset and overrides.
  @override
  Widget build(BuildContext context) {
    return Slider.single(
      value: value,
      onChanged: onChanged,
      min: min,
      max: max,
      enabled: enabled,
      snap: resolvedSnap,
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
      preset: presetName,
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
}

/// Shared range-slider variant base.
abstract class RangeSliderVariantBase extends StatelessWidget {
  const RangeSliderVariantBase({
    /// Passes identity through the widget tree.
    super.key,

    /// Current start/end values for the range variant.
    required this.rangeValue,

    /// Fired after range updates are clamped/snapped.
    required this.onChanged,

    /// Lower domain bound.
    this.min = 0,

    /// Upper domain bound.
    this.max = 1,

    /// Enables/disables interactions.
    this.enabled = true,

    /// Snapping strategy for both thumbs.
    this.snap = const ShadSnap.none(),

    /// Track height override.
    this.trackHeight,

    /// Track radius override.
    this.trackRadius,

    /// Thumb inset override.
    this.thumbInset,

    /// Thumb size override.
    this.thumbSize,

    /// Default thumb radius override.
    this.thumbRadius,

    /// Horizontal thumb placement offset.
    this.thumbEdgeOffsetPx,

    /// Vertical thumb placement offset.
    this.thumbVerticalOffsetPx,

    /// Segment join gap around thumbs.
    this.joinGapPx,

    /// Minimum distance between start and end.
    ///
    /// `0` allows touching thumbs.
    this.minRange = 0,

    /// Whether thumbs can cross and swap.
    this.allowSwap = false,

    /// Fill alignment mode relative to thumb centers.
    this.fillStopsAtThumbCenter,

    /// Pixel bias for fill edges.
    this.fillEdgeBiasPx,

    /// Custom track builder override.
    this.trackBuilder,

    /// Custom fill builder override.
    this.fillBuilder,

    /// Custom thumb builder override.
    this.thumbBuilder,

    /// Custom ticks builder override.
    this.ticksBuilder,

    /// Custom overlay builder override.
    this.overlayBuilder,

    /// Segment layout override.
    this.segmentLayout,

    /// Unified renderer override.
    this.trackRenderer,

    /// Popover builder override.
    this.dragPopoverBuilder,

    /// Popover offset override.
    this.dragPopoverOffset,

    /// Popover visibility override.
    this.dragPopoverVisibility,

    /// Accessibility label override.
    this.semanticLabel,
  });

  /// Current range value.
  final ShadRangeValue rangeValue;

  /// Callback for resolved range updates.
  final ValueChanged<ShadRangeValue> onChanged;

  /// Lower domain bound.
  final double min;

  /// Upper domain bound.
  final double max;

  /// Whether interactions are enabled.
  final bool enabled;

  /// Snap strategy for updates.
  final ShadSnap snap;

  /// Track height override.
  final double? trackHeight;

  /// Track radius override.
  final double? trackRadius;

  /// Thumb inset override.
  final double? thumbInset;

  /// Thumb size override.
  final Size? thumbSize;

  /// Default thumb radius override.
  final double? thumbRadius;

  /// Horizontal thumb offset override.
  final double? thumbEdgeOffsetPx;

  /// Vertical thumb offset override.
  final double? thumbVerticalOffsetPx;

  /// Segment join gap override.
  final double? joinGapPx;

  /// Minimum start/end distance.
  final double minRange;

  /// Whether thumbs may swap when crossing.
  final bool allowSwap;

  /// Fill alignment mode relative to thumb centers.
  final bool? fillStopsAtThumbCenter;

  /// Pixel bias for fill edges.
  final double? fillEdgeBiasPx;

  /// Custom track builder.
  final ShadTrackBuilder? trackBuilder;

  /// Custom fill builder.
  final ShadFillBuilder? fillBuilder;

  /// Custom thumb builder.
  final ShadThumbBuilder? thumbBuilder;

  /// Custom ticks builder.
  final ShadTicksBuilder? ticksBuilder;

  /// Custom overlay builder.
  final ShadOverlayBuilder? overlayBuilder;

  /// Segment layout override.
  final ShadSegmentLayout? segmentLayout;

  /// Unified renderer override.
  final ShadTrackRenderer? trackRenderer;

  /// Popover builder override.
  final ShadPopoverBuilder? dragPopoverBuilder;

  /// Popover offset override.
  final Offset? dragPopoverOffset;

  /// Popover visibility override.
  final ShadPopoverVisibility? dragPopoverVisibility;

  /// Accessibility label override.
  final String? semanticLabel;

  /// Preset identifier forwarded to [Slider.range].
  String get presetName;

  /// Snap strategy used by this variant.
  ShadSnap get resolvedSnap => snap;

  /// Builds [Slider.range] with this variant's preset and overrides.
  @override
  Widget build(BuildContext context) {
    return Slider.range(
      rangeValue: rangeValue,
      onChanged: onChanged,
      min: min,
      max: max,
      enabled: enabled,
      snap: resolvedSnap,
      trackHeight: trackHeight,
      trackRadius: trackRadius,
      thumbInset: thumbInset,
      thumbSize: thumbSize,
      thumbRadius: thumbRadius,
      thumbEdgeOffsetPx: thumbEdgeOffsetPx,
      thumbVerticalOffsetPx: thumbVerticalOffsetPx,
      joinGapPx: joinGapPx,
      minRange: minRange,
      allowSwap: allowSwap,
      fillStopsAtThumbCenter: fillStopsAtThumbCenter,
      fillEdgeBiasPx: fillEdgeBiasPx,
      preset: presetName,
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
}
