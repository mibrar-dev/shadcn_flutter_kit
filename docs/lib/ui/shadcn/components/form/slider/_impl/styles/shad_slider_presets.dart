// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/material.dart' hide Theme;

import '../../../../../shared/theme/theme.dart';

import '../core/shad_slider_models.dart';
import 'shad_slider_defaults.dart';

enum ShadSliderPreset { brightness, rangeSoft, stepsDots, waveform }

/// Resolved preset output: builders + tuned layout values.
class ShadPresetResolved {
  const ShadPresetResolved({
    /// Resolved base track builder.
    required this.trackBuilder,

    /// Resolved fill builder.
    required this.fillBuilder,

    /// Resolved thumb builder.
    required this.thumbBuilder,

    /// Resolved ticks builder.
    required this.ticksBuilder,

    /// Resolved overlay builder.
    required this.overlayBuilder,

    /// Resolved track height.
    required this.trackHeight,

    /// Resolved thumb inset.
    required this.thumbInset,

    /// Resolved fill edge bias.
    required this.fillEdgeBiasPx,
  });

  /// Base track builder selected after preset + overrides.
  final ShadTrackBuilder trackBuilder;

  /// Fill builder selected after preset + overrides.
  final ShadFillBuilder fillBuilder;

  /// Thumb builder selected after preset + overrides.
  final ShadThumbBuilder thumbBuilder;

  /// Ticks builder selected after preset + overrides.
  final ShadTicksBuilder ticksBuilder;

  /// Overlay builder selected after preset + overrides.
  final ShadOverlayBuilder overlayBuilder;

  /// Track height selected by preset.
  final double trackHeight;

  /// Thumb inset selected by preset.
  final double thumbInset;

  /// Fill edge bias selected by preset.
  final double fillEdgeBiasPx;
}

/// Resolves final builder/layout values for a given [preset].
///
/// Explicit widget/theme overrides win first; preset fills only missing pieces.
ShadPresetResolved resolveShadSliderPreset(
  BuildContext context, {

  /// Preset identity to resolve.
  required ShadSliderPreset preset,

  /// Base track height before preset adjustments.
  required double trackHeight,

  /// Base thumb inset before preset adjustments.
  required double thumbInset,

  /// Base fill bias before preset adjustments.
  required double fillEdgeBiasPx,

  /// Optional track builder override.
  ShadTrackBuilder? trackBuilder,

  /// Optional fill builder override.
  ShadFillBuilder? fillBuilder,

  /// Optional thumb builder override.
  ShadThumbBuilder? thumbBuilder,

  /// Optional ticks builder override.
  ShadTicksBuilder? ticksBuilder,

  /// Optional overlay builder override.
  ShadOverlayBuilder? overlayBuilder,
}) {
  // Presets only fill missing inputs; explicit widget/theme inputs win.
  final defaults = ShadSliderDefaults.of(context);

  ShadTrackBuilder tb = trackBuilder ?? defaults.trackBuilder;
  ShadFillBuilder fb = fillBuilder ?? defaults.fillBuilder;
  ShadThumbBuilder thb = thumbBuilder ?? defaults.thumbBuilder;
  ShadTicksBuilder tix = ticksBuilder ?? defaults.ticksBuilder;
  ShadOverlayBuilder ob = overlayBuilder ?? defaults.overlayBuilder;

  double h = trackHeight;
  double inset = thumbInset;
  double bias = fillEdgeBiasPx;

  switch (preset) {
    case ShadSliderPreset.brightness:
      break;
    case ShadSliderPreset.rangeSoft:
      h = trackHeight + 2;
      thb = thumbBuilder ?? ShadSliderDefaults.circleThumb;
      bias = 0;
      break;
    case ShadSliderPreset.stepsDots:
      h = (trackHeight - 2).clamp(16.0, 9999.0);
      thb = thumbBuilder ?? ShadSliderDefaults.circleThumb;
      tix = ticksBuilder ?? ShadSliderDefaults.dotsTicks;
      bias = 0;
      break;
    case ShadSliderPreset.waveform:
      thb = thumbBuilder ?? ShadSliderDefaults.circleThumb;
      tix = ticksBuilder ?? ShadSliderDefaults.subtleBarsTicks;
      bias = 0;
      break;
  }

  return ShadPresetResolved(
    trackBuilder: tb,
    fillBuilder: fb,
    thumbBuilder: thb,
    ticksBuilder: tix,
    overlayBuilder: ob,
    trackHeight: h,
    thumbInset: inset,
    fillEdgeBiasPx: bias,
  );
}
