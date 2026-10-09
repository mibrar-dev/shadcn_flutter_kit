// Registry-owned theme data for the `stepper` component: [StepperTheme], the
// per-phase [StepperIndicatorStyle] rows, the themed [StepperIndicator] ring
// and the token-derived `stepperDefaults`. User-owned overrides live in
// `stepper_theme.dart`; CLI updates may replace this file. Like `calendar`,
// the theme classes carry no `copyWith`/`lerp`: nothing calls them.

import 'package:flutter/widgets.dart';

import '../../foundation/icons/lucide_icons.dart';
import '../../primitives/clickable.dart';
import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';

/// Extra state a step carries on top of "before / current / after".
enum StepperStepState {
  /// The step failed validation: it and every later connector go destructive.
  failed,
}

/// The lowest step index flagged [StepperStepState.failed], or null. The
/// flagged step and every connector leading away from it paint as failed.
int? firstFailedStep(Map<int, StepperStepState> stepStates) {
  int? result;
  for (final int key in stepStates.keys) {
    if (stepStates[key] == StepperStepState.failed) {
      result = result == null || key < result ? key : result;
    }
  }
  return result;
}

/// Where a step sits relative to the active one: the phase picks the glyph,
/// the theme picks the ring colours (so a themed `failed` ring keeps its
/// cross).
enum StepperPhase { pending, active, completed, failed }

/// Size of the step indicator and of the step title/icon.
enum StepperSize {
  /// 36px circle, `text-sm` title, 16px icon.
  sm(36),

  /// 40px circle (default), `text-base` title, 20px icon.
  md(40),

  /// 44px circle, `text-large` title, 24px icon.
  lg(44);

  const StepperSize(this.indicatorSize);

  /// Diameter of the indicator in logical pixels (multiplied by `scaling`).
  final double indicatorSize;

  /// The title text style for this size.
  TextStyle titleStyleFor(ShadcnThemeData theme) => switch (this) {
    StepperSize.sm => theme.typography.small,
    StepperSize.md => theme.typography.base,
    StepperSize.lg => theme.typography.large,
  };

  /// The icon slot for this size.
  IconThemeData iconThemeFor(ShadcnThemeData theme) => switch (this) {
    StepperSize.sm => theme.iconTheme.small,
    StepperSize.md => theme.iconTheme.medium,
    StepperSize.lg => theme.iconTheme.large,
  };
}

/// Visual contract of one step indicator.
class StepperIndicatorStyle implements Mergeable<StepperIndicatorStyle> {
  /// Creates an indicator style.
  const StepperIndicatorStyle({
    this.background,
    this.foreground,
    this.borderColor,
    this.borderWidth,
  });

  /// Fill of the indicator.
  final ThemedColor? background;

  /// Colour of the number, the check mark or the failure cross.
  final ThemedColor? foreground;

  /// Colour of the indicator ring.
  final ThemedColor? borderColor;

  /// Ring width. Default: 2 (multiplied by `scaling`).
  final double? borderWidth;

  /// First-non-null-wins merge; the receiver (higher-priority leg) wins.
  @override
  StepperIndicatorStyle merge(StepperIndicatorStyle? fallback) {
    if (fallback == null) {
      return this;
    }
    return StepperIndicatorStyle(
      background: background ?? fallback.background,
      foreground: foreground ?? fallback.foreground,
      borderColor: borderColor ?? fallback.borderColor,
      borderWidth: borderWidth ?? fallback.borderWidth,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is StepperIndicatorStyle &&
        other.background == background &&
        other.foreground == foreground &&
        other.borderColor == borderColor &&
        other.borderWidth == borderWidth;
  }

  @override
  int get hashCode =>
      Object.hash(background, foreground, borderColor, borderWidth);
}

/// Visual contract of a stepper. Every field is nullable: an override leg sets
/// only what it changes and [merge] keeps the lower leg's remaining fields.
class StepperTheme extends ComponentThemeData
    implements Mergeable<StepperTheme> {
  /// Creates a stepper theme.
  const StepperTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.direction,
    this.size,
    this.active,
    this.completed,
    this.pending,
    this.failed,
    this.connectorColor,
    this.connectorPendingColor,
    this.connectorThickness,
    this.gap,
    this.titleStyle,
  });

  /// Layout axis. Default: [Axis.horizontal].
  final Axis? direction;

  /// Indicator size. Default: [StepperSize.md].
  final StepperSize? size;

  /// The step the stepper is on.
  final StepperIndicatorStyle? active;

  /// A step before the active one.
  final StepperIndicatorStyle? completed;

  /// A step after the active one.
  final StepperIndicatorStyle? pending;

  /// The step flagged [StepperStepState.failed].
  final StepperIndicatorStyle? failed;

  /// Connector up to and including the active step. Default: `primary`.
  final ThemedColor? connectorColor;

  /// Connector after the active step. Default: `border`.
  final ThemedColor? connectorPendingColor;

  /// Connector thickness. Default: 2 (multiplied by `scaling`).
  final double? connectorThickness;

  /// Space around the indicator. Default: 8 (multiplied by `scaling`).
  final double? gap;

  /// Title style override; null takes the [size] typography.
  final TextStyle? titleStyle;

  /// First-non-null-wins merge; the receiver (higher-priority leg) wins.
  @override
  StepperTheme merge(StepperTheme? fallback) {
    if (fallback == null) {
      return this;
    }
    return StepperTheme(
      themeDensity: themeDensity ?? fallback.themeDensity,
      themeSpacing: themeSpacing ?? fallback.themeSpacing,
      themeShadows: themeShadows ?? fallback.themeShadows,
      direction: direction ?? fallback.direction,
      size: size ?? fallback.size,
      active: active?.merge(fallback.active) ?? fallback.active,
      completed: completed?.merge(fallback.completed) ?? fallback.completed,
      pending: pending?.merge(fallback.pending) ?? fallback.pending,
      failed: failed?.merge(fallback.failed) ?? fallback.failed,
      connectorColor: connectorColor ?? fallback.connectorColor,
      connectorPendingColor:
          connectorPendingColor ?? fallback.connectorPendingColor,
      connectorThickness: connectorThickness ?? fallback.connectorThickness,
      gap: gap ?? fallback.gap,
      titleStyle: titleStyle == null
          ? fallback.titleStyle
          : (fallback.titleStyle?.merge(titleStyle) ?? titleStyle),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is StepperTheme &&
        other.themeDensity == themeDensity &&
        other.themeSpacing == themeSpacing &&
        other.themeShadows == themeShadows &&
        other.direction == direction &&
        other.size == size &&
        other.active == active &&
        other.completed == completed &&
        other.pending == pending &&
        other.failed == failed &&
        other.connectorColor == connectorColor &&
        other.connectorPendingColor == connectorPendingColor &&
        other.connectorThickness == connectorThickness &&
        other.gap == gap &&
        other.titleStyle == titleStyle;
  }

  @override
  int get hashCode => Object.hashAll(<Object?>[
    themeDensity,
    themeSpacing,
    themeShadows,
    direction,
    size,
    active,
    completed,
    pending,
    failed,
    connectorColor,
    connectorPendingColor,
    connectorThickness,
    gap,
    titleStyle,
  ]);
}

// Defaults (registry-owned, tokens only).

/// The active step: a `secondary` ring holding the number.
const StepperIndicatorStyle _stepperActive = StepperIndicatorStyle(
  background: ThemedColor.ref(ColorRef.secondary),
  foreground: ThemedColor.ref(ColorRef.primary),
  borderColor: ThemedColor.ref(ColorRef.primary),
  borderWidth: 2,
);

/// A finished step: a `primary` ring holding a check mark.
const StepperIndicatorStyle _stepperCompleted = StepperIndicatorStyle(
  background: ThemedColor.ref(ColorRef.primary),
  foreground: ThemedColor.ref(ColorRef.background),
  borderColor: ThemedColor.ref(ColorRef.primary),
  borderWidth: 2,
);

/// A step after the active one: an empty ring on the `background`.
const StepperIndicatorStyle _stepperPending = StepperIndicatorStyle(
  background: ThemedColor.ref(ColorRef.background),
  foreground: ThemedColor.ref(ColorRef.primary),
  borderColor: ThemedColor.ref(ColorRef.border),
  borderWidth: 2,
);

/// A failed step: a `destructive` ring holding a cross.
const StepperIndicatorStyle _stepperFailed = StepperIndicatorStyle(
  background: ThemedColor.ref(ColorRef.destructive),
  foreground: ThemedColor.ref(ColorRef.destructiveForeground),
  borderColor: ThemedColor.ref(ColorRef.destructive),
  borderWidth: 2,
);

/// Token-derived baseline; every unset override field falls through here.
const StepperTheme stepperDefaults = StepperTheme(
  direction: Axis.horizontal,
  size: StepperSize.md,
  active: _stepperActive,
  completed: _stepperCompleted,
  pending: _stepperPending,
  failed: _stepperFailed,
  connectorColor: ThemedColor.ref(ColorRef.primary),
  connectorPendingColor: ThemedColor.ref(ColorRef.border),
  connectorThickness: 2,
  gap: 8,
);

/// The numbered ring of one step, public so a custom stepper layout can
/// reuse it.
class StepperIndicator extends StatelessWidget {
  /// Creates an indicator.
  const StepperIndicator({
    super.key,
    required this.index,
    required this.phase,
    required this.style,
    required this.size,
    this.icon,
    this.textStyle,
    this.iconTheme,
    this.onPressed,
    this.focusNode,
  });

  /// Zero-based step index, used for the number.
  final int index;

  /// Which glyph the ring paints.
  final StepperPhase phase;

  /// Ring colours for the phase.
  final StepperIndicatorStyle style;

  /// Diameter of the ring.
  final double size;

  /// Replaces the number.
  final Widget? icon;

  /// Style of the number.
  final TextStyle? textStyle;

  /// Icon slot; merged over the ring's foreground colour.
  final IconThemeData? iconTheme;

  /// Activates the step; null makes the ring inert.
  final VoidCallback? onPressed;

  /// Focus node for keyboard activation; internal when null.
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    final ShadcnColors colors = theme.colors;
    final Color? foreground = style.foreground?.resolve(colors);
    final Color? border = style.borderColor?.resolve(colors);
    final double borderWidth = (style.borderWidth ?? 2) * theme.scaling;
    final Widget glyph =
        icon ??
        switch (phase) {
          StepperPhase.failed => Icon(LucideIcons.x, color: foreground),
          StepperPhase.completed => Icon(LucideIcons.check, color: foreground),
          _ => Text('${index + 1}', style: textStyle),
        };
    final Widget content = IconTheme.merge(
      data: (iconTheme ?? const IconThemeData()).copyWith(
        color: foreground ?? iconTheme?.color,
      ),
      child: DefaultTextStyle.merge(
        style: textStyle?.copyWith(color: foreground),
        child: Center(child: glyph),
      ),
    );
    return SizedBox(
      width: size,
      height: size,
      child: Clickable(
        enabled: onPressed != null,
        onPressed: onPressed,
        focusNode: focusNode,
        padding: const WidgetStatePropertyAll<EdgeInsetsGeometry>(
          EdgeInsets.zero,
        ),
        decoration: WidgetStatePropertyAll<Decoration?>(
          BoxDecoration(
            color: style.background?.resolve(colors),
            shape: theme.radius > 0 ? BoxShape.circle : BoxShape.rectangle,
            borderRadius: theme.radius > 0 ? null : theme.borderRadiusMd,
            border: border == null || borderWidth <= 0
                ? null
                : Border.all(color: border, width: borderWidth),
          ),
        ),
        mouseCursor: const WidgetStatePropertyAll<MouseCursor?>(
          SystemMouseCursors.click,
        ),
        child: content,
      ),
    );
  }
}
