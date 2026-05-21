// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'dart:math' as math;

import 'package:flutter/material.dart' hide SliderTheme, Theme;

import '../../../../../shared/theme/theme.dart';
import '../themes/base/slider_theme.dart';
import 'shad_slider_models.dart';

/// Unified rendering contract for slider track layers.
abstract class ShadTrackRenderer {
  const ShadTrackRenderer();

  /// Builds visual layers for the provided computed slider [view].
  Widget build(BuildContext context, ShadSliderStateView view);
}

/// Adapter that renders legacy `track/fill/ticks` builders in order.
class ShadLegacyBuildersRenderer extends ShadTrackRenderer {
  const ShadLegacyBuildersRenderer({
    /// Base track layer builder.
    required this.trackBuilder,

    /// Active/remaining fill layer builder.
    required this.fillBuilder,

    /// Tick/mark layer builder.
    required this.ticksBuilder,
  });

  /// Base track layer builder.
  final ShadTrackBuilder trackBuilder;

  /// Fill layer builder.
  final ShadFillBuilder fillBuilder;

  /// Tick layer builder.
  final ShadTicksBuilder ticksBuilder;

  /// Builds layers in legacy order: track, fill, then ticks.
  @override
  Widget build(BuildContext context, ShadSliderStateView view) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        trackBuilder(context, view),
        fillBuilder(context, view),
        ticksBuilder(context, view),
      ],
    );
  }
}

/// Default segmented renderer that draws each [ShadSegment] as a capsule.
class ShadSegmentedCapsuleRenderer extends ShadTrackRenderer {
  const ShadSegmentedCapsuleRenderer({
    /// Optional per-segment style resolver.
    ///
    /// If null, renderer uses theme-aware defaults by segment kind.
    this.styleResolver,
  });

  /// Optional style resolver for custom segment colors/borders/radii.
  final ShadSegmentStyleResolver? styleResolver;

  /// Builds styled segments using resolver or theme defaults.
  @override
  Widget build(BuildContext context, ShadSliderStateView view) {
    final cs = Theme.of(context).colorScheme;
    final compTheme = ComponentTheme.maybeOf<SliderTheme>(context);

    ShadSegmentStyle resolve(ShadSegment s) {
      if (styleResolver != null) return styleResolver!(context, view, s);
      switch (s.kind) {
        case ShadSegmentKind.fill:
          return ShadSegmentStyle(
            color: compTheme?.fillActiveColor ?? cs.primary,
            radius: s.radius,
          );
        case ShadSegmentKind.remaining:
          return ShadSegmentStyle(
            color: compTheme?.fillInactiveColor ?? cs.muted,
            radius: s.radius,
          );
        case ShadSegmentKind.gap:
          return const ShadSegmentStyle(color: Colors.transparent);
        case ShadSegmentKind.disabled:
          return ShadSegmentStyle(
            color: (compTheme?.fillInactiveColor ?? cs.muted).withOpacity(0.5),
            radius: s.radius,
          );
        case ShadSegmentKind.custom:
          return ShadSegmentStyle(color: cs.muted, radius: s.radius);
      }
    }

    final ordered = [...view.segments]
      ..sort((a, b) => a.paintOrder.compareTo(b.paintOrder));

    return Stack(
      clipBehavior: Clip.none,
      children: [
        for (final s in ordered)
          if (s.rect.width > 0)
            Positioned.fromRect(
              rect: s.rect,
              child: Builder(
                builder: (context) {
                  final style = resolve(s);
                  final opacity = style.opacity ?? 1.0;
                  return Opacity(
                    opacity: opacity,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: style.color,
                        gradient: style.gradient,
                        border: style.border,
                        borderRadius:
                            style.radius ?? s.radius ?? BorderRadius.zero,
                      ),
                    ),
                  );
                },
              ),
            ),
      ],
    );
  }
}

/// Renderer that adds step dots on top of a base segmented track.
class ShadStepDotsRenderer extends ShadTrackRenderer {
  const ShadStepDotsRenderer({
    /// Base renderer used before dots are painted.
    ///
    /// Use this to swap the underlying segment style.
    this.base = const ShadSegmentedCapsuleRenderer(),
  });

  /// Base renderer for non-dot layers.
  final ShadTrackRenderer base;

  /// Builds base layers first, then paints progress-aware dots.
  @override
  Widget build(BuildContext context, ShadSliderStateView view) {
    final cs = Theme.of(context).colorScheme;
    final compTheme = ComponentTheme.maybeOf<SliderTheme>(context);
    final active =
        compTheme?.dotsActiveColor ?? cs.foreground.withOpacity(0.18);
    final inactive =
        compTheme?.dotsInactiveColor ?? cs.foreground.withOpacity(0.08);
    final activeT = view.t ?? 0;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        base.build(context, view),
        for (final m in view.marks)
          Positioned(
            left: m.x - 3,
            top: view.trackRect.center.dy - 3,
            child: Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: (m.t <= activeT) ? active : inactive,
              ),
            ),
          ),
      ],
    );
  }
}

/// Renderer that paints waveform-like bars over a base segmented track.
class ShadWaveformRenderer extends ShadTrackRenderer {
  const ShadWaveformRenderer({
    /// Base renderer used before waveform bars are painted.
    this.base = const ShadSegmentedCapsuleRenderer(),

    /// Number of generated bars across track width.
    ///
    /// `0` is invalid. Higher values increase detail and paint cost.
    this.bars = 64,
  });

  /// Base renderer for non-wave layers.
  final ShadTrackRenderer base;

  /// Number of waveform bars to render.
  final int bars;

  /// Builds base layers first, then paints waveform bars over the track.
  @override
  Widget build(BuildContext context, ShadSliderStateView view) {
    final cs = Theme.of(context).colorScheme;
    final compTheme = ComponentTheme.maybeOf<SliderTheme>(context);
    final w = view.trackRect.width;
    final h = view.trackRect.height;
    final barW = w / bars;
    final maxBarH = h * 0.75;
    final activeX = w * (view.t ?? 0);
    final active =
        compTheme?.waveformTicksActiveColor ?? cs.background.withOpacity(0.52);
    final inactive =
        compTheme?.waveformTicksInactiveColor ??
        cs.foreground.withOpacity(0.40);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        base.build(context, view),
        Positioned.fromRect(
          rect: view.trackRect,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(view.trackRadius),
            child: SizedBox(
              width: w,
              height: h,
              child: Stack(
                children: [
                  for (int i = 0; i < bars; i++)
                    Positioned(
                      left: i * barW,
                      top: () {
                        final t = i / (bars - 1);
                        final amp = (math.sin(t * math.pi) * 0.85 + 0.15);
                        final bh = maxBarH * amp;
                        return (h - bh) / 2;
                      }(),
                      child: Builder(
                        builder: (_) {
                          final t = i / (bars - 1);
                          final amp = (math.sin(t * math.pi) * 0.85 + 0.15);
                          final bh = maxBarH * amp;
                          return Container(
                            width: math.max(1, barW * 0.55),
                            height: bh,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(999),
                              color: ((i * barW) <= activeX)
                                  ? active
                                  : inactive,
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
