// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'base_slider_variant.dart';

/// Preset wrapper for `brightness` single slider.
class BrightnessSlider extends SingleSliderVariantBase {
  const BrightnessSlider({
    /// Passes identity through the widget tree.
    super.key,

    /// Current brightness-style value.
    required super.value,

    /// Fired after drag/tap updates resolve to a value.
    required super.onChanged,

    /// Lower value bound.
    super.min,

    /// Upper value bound.
    super.max,

    /// Enables/disables gestures.
    super.enabled,

    /// Snap strategy override.
    super.snap,

    /// Track height override.
    super.trackHeight,

    /// Track radius override.
    super.trackRadius,

    /// Thumb inset override.
    super.thumbInset,

    /// Thumb size override.
    super.thumbSize,

    /// Default thumb radius override.
    super.thumbRadius,

    /// Horizontal thumb offset override.
    super.thumbEdgeOffsetPx,

    /// Vertical thumb offset override.
    super.thumbVerticalOffsetPx,

    /// Segment join gap override.
    super.joinGapPx,

    /// Fill alignment override.
    super.fillStopsAtThumbCenter,

    /// Fill edge bias override.
    super.fillEdgeBiasPx,

    /// Custom track builder override.
    super.trackBuilder,

    /// Custom fill builder override.
    super.fillBuilder,

    /// Custom thumb builder override.
    super.thumbBuilder,

    /// Custom ticks builder override.
    super.ticksBuilder,

    /// Custom overlay builder override.
    super.overlayBuilder,

    /// Segment layout override.
    super.segmentLayout,

    /// Unified renderer override.
    super.trackRenderer,

    /// Popover builder override.
    super.dragPopoverBuilder,

    /// Popover offset override.
    super.dragPopoverOffset,

    /// Popover visibility override.
    super.dragPopoverVisibility,

    /// Accessibility label override.
    super.semanticLabel,
  });

  /// Preset key resolved by [resolveShadSliderPreset].
  @override
  String get presetName => 'brightness';
}
