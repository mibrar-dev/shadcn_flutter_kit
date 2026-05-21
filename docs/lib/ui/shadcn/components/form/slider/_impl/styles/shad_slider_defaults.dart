// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'dart:math' as math;
import 'package:flutter/material.dart' hide SliderTheme, Theme;

import '../../../../../shared/theme/theme.dart';

import '../core/shad_slider_models.dart';
import '../themes/base/slider_theme.dart';

/// Default builders used by slider presets.
class ShadSliderDefaults {
  ShadSliderDefaults({
    /// Base track layer builder.
    required this.trackBuilder,

    /// Active/remaining fill layer builder.
    required this.fillBuilder,

    /// Thumb builder used for each resolved thumb state.
    required this.thumbBuilder,

    /// Marks/ticks layer builder.
    required this.ticksBuilder,

    /// Optional overlay layer builder.
    required this.overlayBuilder,
  });

  /// Base track layer builder.
  final ShadTrackBuilder trackBuilder;

  /// Fill layer builder for active/remaining segments.
  final ShadFillBuilder fillBuilder;

  /// Thumb widget builder.
  final ShadThumbBuilder thumbBuilder;

  /// Tick/mark layer builder.
  final ShadTicksBuilder ticksBuilder;

  /// Overlay layer builder painted above other layers.
  final ShadOverlayBuilder overlayBuilder;

  /// Resolves default builders from current app theme tokens.
  ///
  /// Defaults are intentionally low-contrast and token-driven.
  static ShadSliderDefaults of(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return ShadSliderDefaults(
      trackBuilder: (context, s) {
        final theme = Theme.of(context);
        final compTheme = ComponentTheme.maybeOf<SliderTheme>(context);
        final guideHeight = (theme.density.baseGap * theme.scaling * 0.25)
            .clamp(1.0, 3.0)
            .toDouble();
        final guideColor =
            compTheme?.guideColor ?? cs.foreground.withOpacity(0.06);
        return Positioned.fromRect(
          rect: s.trackRect,
          child: SizedBox(
            width: s.trackRect.width,
            height: s.trackRect.height,
            child: Center(
              child: Container(
                height: guideHeight,
                width: s.trackRect.width,
                decoration: BoxDecoration(
                  color: guideColor,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
          ),
        );
      },
      fillBuilder: (context, s) {
        final theme = Theme.of(context);
        final cs = theme.colorScheme;
        final compTheme = ComponentTheme.maybeOf<SliderTheme>(context);
        final fillColor = (compTheme?.fillActiveColor ?? cs.primary)
            .withOpacity(s.enabled ? 0.92 : 0.35);
        final remColor = (compTheme?.fillInactiveColor ?? cs.muted).withOpacity(
          0.78,
        );
        final ordered = [...s.segments]
          ..sort((a, b) => a.paintOrder.compareTo(b.paintOrder));

        return Stack(
          children: [
            for (final segment in ordered)
              if (segment.rect.width > 0.5)
                Positioned.fromRect(
                  rect: segment.rect,
                  child: IgnorePointer(
                    child: Container(
                      decoration: BoxDecoration(
                        color: switch (segment.kind) {
                          ShadSegmentKind.fill => fillColor,
                          ShadSegmentKind.remaining => remColor,
                          ShadSegmentKind.gap => Colors.transparent,
                          ShadSegmentKind.disabled => remColor.withOpacity(0.5),
                          ShadSegmentKind.custom => remColor,
                        },
                        borderRadius:
                            segment.radius ??
                            BorderRadius.circular(
                              math.min(s.trackRadius, s.trackRect.height / 2),
                            ),
                      ),
                    ),
                  ),
                ),
          ],
        );
      },
      thumbBuilder: barThumb(),
      ticksBuilder: (context, s) => const SizedBox.shrink(),
      overlayBuilder: (context, s) => const SizedBox.shrink(),
    );
  }

  /// Default bar thumb builder with optional radius override.
  ///
  /// The returned builder respects [ShadThumbStateView.size] for layout.
  static ShadThumbBuilder barThumb({
    /// Corner radius override for bar thumb body.
    ///
    /// `0` creates square corners; positive values round corners.
    /// Null computes pill radius from resolved thumb width/height.
    double? radius,

    /// Horizontal inset applied to the visual thumb body in logical pixels.
    ///
    /// `0` keeps the body centered on the thumb anchor.
    /// Positive values pull the body inward (LTR: left, RTL: right) while
    /// preserving edge alignment at min/max.
    double insideOffsetPx = 0,
  }) {
    return (context, t) {
      final theme = Theme.of(context);
      final baseGap = theme.density.baseGap * theme.scaling;
      final barH = (t.size.height - baseGap * 0.25).clamp(2.0, 200.0);
      final w = (t.size.width - baseGap * 0.25).clamp(2.0, 400.0);
      final barRadius =
          radius ?? (math.min(w, barH) / 2).clamp(1.0, 999.0).toDouble();
      final cs = theme.colorScheme;
      final compTheme = ComponentTheme.maybeOf<SliderTheme>(context);
      final thumbFill = compTheme?.thumbFillColor ?? cs.background;
      final thumbBorder =
          compTheme?.thumbBorderColor ?? cs.foreground.withOpacity(0.10);

      Widget body = IgnorePointer(
        ignoring: true,
        child: SizedBox(
          width: t.size.width,
          height: t.size.height,
          child: Center(
            child: Container(
              width: w,
              height: barH,
              decoration: BoxDecoration(
                color: thumbFill.withOpacity(t.enabled ? 1 : 0.7),
                borderRadius: BorderRadius.circular(barRadius),
                border: Border.all(color: thumbBorder, width: 1),
              ),
            ),
          ),
        ),
      );

      if (insideOffsetPx != 0) {
        const eps = 0.005;
        final atEdge = t.t <= eps || t.t >= 1 - eps;
        if (!atEdge) {
          final dir = Directionality.of(context);
          final sign = dir == TextDirection.rtl ? 1.0 : -1.0;
          body = Transform.translate(
            offset: Offset(sign * insideOffsetPx, 0),
            child: body,
          );
        }
      }

      return body;
    };
  }

  /// Default drag popover for showing current value.
  ///
  /// Uses [ShadPopoverData.value] and applies shape/color from explicit
  /// arguments first, then [SliderTheme], then component defaults.
  static ShadPopoverBuilder valuePopover({
    /// Value-to-string formatter.
    ///
    /// If null, formats with `toStringAsFixed(2)`.
    String Function(double value)? formatter,

    /// Popover shape override.
    ///
    /// Null defers to theme/default shape.
    ShadPopoverShape? shape,
  }) {
    return (context, data) {
      final compTheme = ComponentTheme.maybeOf<SliderTheme>(context);
      final valueText =
          formatter?.call(data.value) ?? data.value.toStringAsFixed(2);
      final resolvedShape =
          shape ?? compTheme?.popoverShape ?? ShadPopoverShape.rounded;
      return _buildValuePopover(
        context,
        valueText: valueText,
        shape: resolvedShape,
      );
    };
  }

  static Widget _buildValuePopover(
    BuildContext context, {
    required String valueText,
    required ShadPopoverShape shape,
  }) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final compTheme = ComponentTheme.maybeOf<SliderTheme>(context);
    final bg = compTheme?.popoverBackgroundColor ?? cs.primary;
    final fg = compTheme?.popoverForegroundColor ?? cs.background;
    final radius = switch (shape) {
      ShadPopoverShape.pill => BorderRadius.circular(999),
      ShadPopoverShape.rounded => BorderRadius.circular(theme.radiusMd),
      ShadPopoverShape.square => BorderRadius.circular(theme.radiusSm),
    };

    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: radius,
          boxShadow: const [
            BoxShadow(
              color: Color(0x22000000),
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Text(
          valueText,
          style: TextStyle(color: fg, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  /// Returns preconfigured popover helper with a pill shape.
  static ShadPopoverBuilder valuePopoverPill({
    /// Value-to-string formatter.
    ///
    /// If null, formats with `toStringAsFixed(2)`.
    String Function(double value)? formatter,
  }) {
    return valuePopover(formatter: formatter, shape: ShadPopoverShape.pill);
  }

  /// Returns preconfigured popover helper with a rounded-rect shape.
  static ShadPopoverBuilder valuePopoverRounded({
    /// Value-to-string formatter.
    ///
    /// If null, formats with `toStringAsFixed(2)`.
    String Function(double value)? formatter,
  }) {
    return valuePopover(formatter: formatter, shape: ShadPopoverShape.rounded);
  }

  /// Returns preconfigured popover helper with a square-like shape.
  static ShadPopoverBuilder valuePopoverSquare({
    /// Value-to-string formatter.
    ///
    /// If null, formats with `toStringAsFixed(2)`.
    String Function(double value)? formatter,
  }) {
    return valuePopover(formatter: formatter, shape: ShadPopoverShape.square);
  }

  // ---- Convenience builders for presets ----

  /// Ring thumb with subtle border and small center dot.
  static Widget circleThumb(BuildContext context, ShadThumbStateView t) {
    final cs = Theme.of(context).colorScheme;
    final compTheme = ComponentTheme.maybeOf<SliderTheme>(context);
    final border =
        compTheme?.thumbBorderColor ?? cs.foreground.withOpacity(0.18);
    final ring = cs.primary.withOpacity(t.enabled ? 0.95 : 0.45);
    final d = t.size.width;

    return IgnorePointer(
      ignoring: true,
      child: SizedBox(
        width: t.size.width,
        height: t.size.height,
        child: Center(
          child: SizedBox(
            width: d,
            height: d,
            child: DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent,
                border: Border.all(color: border, width: 1),
              ),
              child: Center(
                child: Container(
                  width: d * 0.30,
                  height: d * 0.30,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: ring,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Square-ish thumb helper that still honors theme colors and thumb size.
  static Widget squareThumb(BuildContext context, ShadThumbStateView t) {
    final theme = Theme.of(context);
    final compTheme = ComponentTheme.maybeOf<SliderTheme>(context);
    final cs = theme.colorScheme;
    final border =
        compTheme?.thumbBorderColor ?? cs.foreground.withOpacity(0.12);
    final fill = compTheme?.thumbFillColor ?? cs.background;
    final w = t.size.width;
    final h = t.size.height * 0.85;

    return IgnorePointer(
      ignoring: true,
      child: SizedBox(
        width: t.size.width,
        height: t.size.height,
        child: Center(
          child: SizedBox(
            width: w,
            height: h,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: fill,
                borderRadius: BorderRadius.circular(theme.radiusSm),
                border: Border.all(color: border, width: 1),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Pin-style thumb helper with stem and circular head.
  static Widget pinThumb(BuildContext context, ShadThumbStateView t) {
    final cs = Theme.of(context).colorScheme;
    final compTheme = ComponentTheme.maybeOf<SliderTheme>(context);
    final border =
        compTheme?.thumbBorderColor ?? cs.foreground.withOpacity(0.12);
    final fill = compTheme?.thumbFillColor ?? cs.background;
    final dot = cs.primary.withOpacity(t.enabled ? 0.95 : 0.45);

    return IgnorePointer(
      ignoring: true,
      child: SizedBox(
        width: 22,
        height: 30,
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Positioned(
              top: 10,
              child: Container(
                width: 2,
                height: 18,
                decoration: BoxDecoration(
                  color: border,
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
            ),
            Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                color: fill,
                shape: BoxShape.circle,
                border: Border.all(color: border, width: 1),
              ),
              child: Center(
                child: Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(color: dot, shape: BoxShape.circle),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Softer dots (Stripe/Linear low-contrast).
  /// Dot ticks helper that colors marks by progress position.
  static Widget dotsTicks(BuildContext context, ShadSliderStateView s) {
    final cs = Theme.of(context).colorScheme;
    final compTheme = ComponentTheme.maybeOf<SliderTheme>(context);
    final activeT = s.t ?? 0;
    final active =
        compTheme?.dotsActiveColor ?? cs.foreground.withOpacity(0.18);
    final inactive =
        compTheme?.dotsInactiveColor ?? cs.foreground.withOpacity(0.08);

    return IgnorePointer(
      child: Stack(
        children: [
          for (final m in s.marks)
            Positioned(
              left: m.x - 3,
              top: s.trackRect.center.dy - 3,
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
      ),
    );
  }

  /// Smooth, natural waveform-like bars (no patterned modulo).
  /// Subtle bar ticks helper with waveform-like amplitude envelope.
  static Widget subtleBarsTicks(BuildContext context, ShadSliderStateView s) {
    final cs = Theme.of(context).colorScheme;
    final compTheme = ComponentTheme.maybeOf<SliderTheme>(context);
    final w = s.trackRect.width;
    final h = s.trackRect.height;

    const bars = 64;
    final barW = w / bars;
    final maxBarH = h * 0.75;

    final activeT = s.t ?? 0;
    final activeX = w * activeT;

    // Inner bars: light on active segment, darker on inactive segment.
    final active =
        compTheme?.waveformTicksActiveColor ?? cs.background.withOpacity(0.52);
    final inactive =
        compTheme?.waveformTicksInactiveColor ??
        cs.foreground.withOpacity(0.40);

    return Positioned.fromRect(
      rect: s.trackRect,
      child: IgnorePointer(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(s.trackRadius),
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
                      final amp =
                          (math.sin(t * math.pi) * 0.85 + 0.15); // 0.15..1.0
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
                            color: ((i * barW) <= activeX) ? active : inactive,
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
    );
  }
}
