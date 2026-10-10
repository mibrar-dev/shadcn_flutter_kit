// Registry-owned theme data for the `chat` component: the bubble/tail enums,
// the merged [ChatTheme] container (the old copy shipped four theme classes),
// its token-derived defaults, the style resolver and the reaction widgets.
// User-owned overrides live in `chat_theme.dart`; CLI updates may replace
// this file.

import 'dart:ui' show lerpDouble;

import 'package:flutter/widgets.dart';

import '../../theme/color_tokens.dart';
import '../../theme/density.dart';
import '../../theme/theme.dart';

/// Bubble style (the old `ChatBubbleType` class hierarchy, data per the
/// component rules).
enum ChatBubbleVariant {
  /// A plain rounded rectangle.
  plain,

  /// A rounded rectangle with a small painted tail on its side corner.
  tail,

  /// A rounded rectangle whose side corner is sharp instead of rounded.
  sharpCorner,
}

/// Which bubble of a [ChatGroup] carries the tail.
enum ChatTailBehavior {
  /// Only the first bubble.
  first,

  /// Only the middle bubble of the group.
  middle,

  /// Only the last bubble (the default).
  last,

  /// No tail at all.
  never,
}

/// Concrete corner of a bubble, after RTL resolution.
enum ChatBubbleCorner { topLeft, topRight, bottomLeft, bottomRight }

/// Directional corner, resolved with the ambient text direction.
enum ChatBubbleCornerDirectional {
  topStart,
  topEnd,
  bottomStart,
  bottomEnd;

  /// Resolves this directional corner against [direction]. The concrete
  /// corners pair up with this enum, so RTL just swaps each start/end pair.
  ChatBubbleCorner resolve(TextDirection direction) {
    final ChatBubbleCorner corner = ChatBubbleCorner.values[index];
    if (direction == TextDirection.ltr) return corner;
    return ChatBubbleCorner.values[index ^ 1];
  }
}

/// The four theme legs of every chat widget: bubble surface, tail metrics,
/// group layout and reaction chips. Every field is nullable — an override
/// leg sets only what it changes and [merge] keeps the rest.
class ChatTheme extends ComponentThemeData implements Mergeable<ChatTheme> {
  const ChatTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.background,
    this.foreground,
    this.variant,
    this.alignment,
    this.widthFactor,
    this.padding,
    this.borderRadius,
    this.borderColor,
    this.borderWidth,
    this.tailSize,
    this.tailRadius,
    this.tailBehavior,
    this.spacing,
    this.avatarSpacing,
    this.avatarAlignment,
    this.reactionBackground,
    this.reactionForeground,
    this.reactionSelectedBackground,
    this.reactionSelectedForeground,
    this.reactionPadding,
  });

  /// Bubble fill; null resolves `primary`.
  final ThemedColor? background;

  /// Label/icon colour; null resolves `primaryForeground` (the old copy
  /// picked it by luminance instead).
  final ThemedColor? foreground;

  final ChatBubbleVariant? variant;

  /// Side of the row; null = `AlignmentDirectional.centerEnd`.
  final AlignmentGeometry? alignment;

  final double? widthFactor;

  /// Inner padding; null = the shadcn bubble's `px-3 py-2` (12/8) as an
  /// [EdgeInsetsDensity].
  final EdgeInsetsGeometry? padding;

  /// Corner radius; null resolves the ambient `radiusLg`.
  final BorderRadiusGeometry? borderRadius;

  /// Outline colour/width; null draws no border.
  final ThemedColor? borderColor;
  final double? borderWidth;

  /// Tail extent / tip rounding; null = `8 x 8` / ambient `radiusSm`.
  final Size? tailSize;
  final double? tailRadius;

  /// Which bubble of a group carries the tail; null = [ChatTailBehavior.last].
  final ChatTailBehavior? tailBehavior;

  /// Gap between a group's bubbles; null resolves `2` (a `Row`/`Column`
  /// spacing, so it cannot carry a density multiplier).
  final double? spacing;

  /// Avatar gap / edge alignment; null = `8` / the group default. A raw
  /// `double` (`Row.spacing`), so `8` stays a literal.
  final double? avatarSpacing;
  final AlignmentGeometry? avatarAlignment;

  /// Reaction chips: fill, label, selected fill, selected label and padding
  /// (`muted` / `foreground` / `primary` / `primaryForeground` / `6 x 4`).
  ///
  /// The padding is a pill `px-1.5 py-1` [EdgeInsetsDensity].
  final ThemedColor? reactionBackground;

  final ThemedColor? reactionForeground;

  final ThemedColor? reactionSelectedBackground;

  final ThemedColor? reactionSelectedForeground;

  final EdgeInsetsGeometry? reactionPadding;

  ChatTheme copyWith({
    ValueGetter<ThemedColor?>? background,
    ValueGetter<ThemedColor?>? foreground,
    ValueGetter<ChatBubbleVariant?>? variant,
    ValueGetter<AlignmentGeometry?>? alignment,
    ValueGetter<double?>? widthFactor,
    ValueGetter<EdgeInsetsGeometry?>? padding,
    ValueGetter<BorderRadiusGeometry?>? borderRadius,
    ValueGetter<ThemedColor?>? borderColor,
    ValueGetter<double?>? borderWidth,
    ValueGetter<Size?>? tailSize,
    ValueGetter<double?>? tailRadius,
    ValueGetter<ChatTailBehavior?>? tailBehavior,
    ValueGetter<double?>? spacing,
    ValueGetter<double?>? avatarSpacing,
    ValueGetter<AlignmentGeometry?>? avatarAlignment,
    ValueGetter<ThemedColor?>? reactionBackground,
    ValueGetter<ThemedColor?>? reactionForeground,
    ValueGetter<ThemedColor?>? reactionSelectedBackground,
    ValueGetter<ThemedColor?>? reactionSelectedForeground,
    ValueGetter<EdgeInsetsGeometry?>? reactionPadding,
  }) {
    return ChatTheme(
      themeDensity: themeDensity,
      themeSpacing: themeSpacing,
      themeShadows: themeShadows,
      background: background == null ? this.background : background(),
      foreground: foreground == null ? this.foreground : foreground(),
      variant: variant == null ? this.variant : variant(),
      alignment: alignment == null ? this.alignment : alignment(),
      widthFactor: widthFactor == null ? this.widthFactor : widthFactor(),
      padding: padding == null ? this.padding : padding(),
      borderRadius: borderRadius == null ? this.borderRadius : borderRadius(),
      borderColor: borderColor == null ? this.borderColor : borderColor(),
      borderWidth: borderWidth == null ? this.borderWidth : borderWidth(),
      tailSize: tailSize == null ? this.tailSize : tailSize(),
      tailRadius: tailRadius == null ? this.tailRadius : tailRadius(),
      tailBehavior: tailBehavior == null ? this.tailBehavior : tailBehavior(),
      spacing: spacing == null ? this.spacing : spacing(),
      avatarSpacing: avatarSpacing == null
          ? this.avatarSpacing
          : avatarSpacing(),
      avatarAlignment: avatarAlignment == null
          ? this.avatarAlignment
          : avatarAlignment(),
      reactionBackground: reactionBackground?.call() ?? this.reactionBackground,
      reactionForeground: reactionForeground?.call() ?? this.reactionForeground,
      reactionSelectedBackground:
          reactionSelectedBackground?.call() ?? this.reactionSelectedBackground,
      reactionSelectedForeground:
          reactionSelectedForeground?.call() ?? this.reactionSelectedForeground,
      reactionPadding: reactionPadding?.call() ?? this.reactionPadding,
    );
  }

  @override
  ChatTheme merge(ChatTheme? fallback) {
    if (fallback == null) {
      return this;
    }
    return ChatTheme(
      themeDensity: themeDensity ?? fallback.themeDensity,
      themeSpacing: themeSpacing ?? fallback.themeSpacing,
      themeShadows: themeShadows ?? fallback.themeShadows,
      background: background ?? fallback.background,
      foreground: foreground ?? fallback.foreground,
      variant: variant ?? fallback.variant,
      alignment: alignment ?? fallback.alignment,
      widthFactor: widthFactor ?? fallback.widthFactor,
      padding: padding ?? fallback.padding,
      borderRadius: borderRadius ?? fallback.borderRadius,
      borderColor: borderColor ?? fallback.borderColor,
      borderWidth: borderWidth ?? fallback.borderWidth,
      tailSize: tailSize ?? fallback.tailSize,
      tailRadius: tailRadius ?? fallback.tailRadius,
      tailBehavior: tailBehavior ?? fallback.tailBehavior,
      spacing: spacing ?? fallback.spacing,
      avatarSpacing: avatarSpacing ?? fallback.avatarSpacing,
      avatarAlignment: avatarAlignment ?? fallback.avatarAlignment,
      reactionBackground: reactionBackground ?? fallback.reactionBackground,
      reactionForeground: reactionForeground ?? fallback.reactionForeground,
      reactionSelectedBackground:
          reactionSelectedBackground ?? fallback.reactionSelectedBackground,
      reactionSelectedForeground:
          reactionSelectedForeground ?? fallback.reactionSelectedForeground,
      reactionPadding: reactionPadding ?? fallback.reactionPadding,
    );
  }

  static ChatTheme lerp(ChatTheme a, ChatTheme b, double t) {
    return ChatTheme(
      themeDensity: t < 0.5 ? a.themeDensity : b.themeDensity,
      themeSpacing: t < 0.5 ? a.themeSpacing : b.themeSpacing,
      themeShadows: t < 0.5 ? a.themeShadows : b.themeShadows,
      background: t < 0.5 ? a.background : b.background,
      foreground: t < 0.5 ? a.foreground : b.foreground,
      variant: t < 0.5 ? a.variant : b.variant,
      alignment: t < 0.5 ? a.alignment : b.alignment,
      widthFactor: lerpDouble(a.widthFactor, b.widthFactor, t),
      padding: EdgeInsetsGeometry.lerp(a.padding, b.padding, t),
      borderRadius: BorderRadiusGeometry.lerp(
        a.borderRadius,
        b.borderRadius,
        t,
      ),
      borderColor: t < 0.5 ? a.borderColor : b.borderColor,
      borderWidth: lerpDouble(a.borderWidth, b.borderWidth, t),
      tailSize: Size.lerp(a.tailSize, b.tailSize, t),
      tailRadius: lerpDouble(a.tailRadius, b.tailRadius, t),
      tailBehavior: t < 0.5 ? a.tailBehavior : b.tailBehavior,
      spacing: lerpDouble(a.spacing, b.spacing, t),
      avatarSpacing: lerpDouble(a.avatarSpacing, b.avatarSpacing, t),
      avatarAlignment: t < 0.5 ? a.avatarAlignment : b.avatarAlignment,
      reactionBackground: t < 0.5 ? a.reactionBackground : b.reactionBackground,
      reactionForeground: t < 0.5 ? a.reactionForeground : b.reactionForeground,
      reactionSelectedBackground: t < 0.5
          ? a.reactionSelectedBackground
          : b.reactionSelectedBackground,
      reactionSelectedForeground: t < 0.5
          ? a.reactionSelectedForeground
          : b.reactionSelectedForeground,
      reactionPadding: EdgeInsetsGeometry.lerp(
        a.reactionPadding,
        b.reactionPadding,
        t,
      ),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is ChatTheme &&
        other.themeDensity == themeDensity &&
        other.themeSpacing == themeSpacing &&
        other.themeShadows == themeShadows &&
        other.background == background &&
        other.foreground == foreground &&
        other.variant == variant &&
        other.alignment == alignment &&
        other.widthFactor == widthFactor &&
        other.padding == padding &&
        other.borderRadius == borderRadius &&
        other.borderColor == borderColor &&
        other.borderWidth == borderWidth &&
        other.tailSize == tailSize &&
        other.tailRadius == tailRadius &&
        other.tailBehavior == tailBehavior &&
        other.spacing == spacing &&
        other.avatarSpacing == avatarSpacing &&
        other.avatarAlignment == avatarAlignment &&
        other.reactionBackground == reactionBackground &&
        other.reactionForeground == reactionForeground &&
        other.reactionSelectedBackground == reactionSelectedBackground &&
        other.reactionSelectedForeground == reactionSelectedForeground &&
        other.reactionPadding == reactionPadding;
  }

  @override
  int get hashCode => Object.hashAll(<Object?>[
    themeDensity,
    themeSpacing,
    themeShadows,
    background,
    foreground,
    variant,
    alignment,
    widthFactor,
    padding,
    borderRadius,
    borderColor,
    borderWidth,
    tailSize,
    tailRadius,
    tailBehavior,
    spacing,
    avatarSpacing,
    avatarAlignment,
    reactionBackground,
    reactionForeground,
    reactionSelectedBackground,
    reactionSelectedForeground,
    reactionPadding,
  ]);
}

/// Token-derived baseline; unset override fields fall through here.
///
/// `padding` (bubble `px-3 py-2`, 12/8) and `reactionPadding` (pill
/// `px-1.5 py-1`, 6/4) are density multipliers resolved by the widgets that
/// paint them; `spacing`/`avatarSpacing` stay plain doubles (`Row` spacing).
const ChatTheme chatDefaults = ChatTheme(
  background: ThemedColor.ref(ColorRef.primary),
  foreground: ThemedColor.ref(ColorRef.primaryForeground),
  variant: ChatBubbleVariant.tail,
  alignment: AlignmentDirectional.centerEnd,
  widthFactor: 0.5,
  padding: EdgeInsetsDensity.pxSymmetric(horizontal: 12, vertical: 8),
  tailSize: Size(8, 8),
  tailBehavior: ChatTailBehavior.last,
  spacing: 2,
  avatarSpacing: 8,
  avatarAlignment: AlignmentDirectional.topEnd,
  reactionBackground: ThemedColor.ref(ColorRef.muted),
  reactionForeground: ThemedColor.ref(ColorRef.foreground),
  reactionSelectedBackground: ThemedColor.ref(ColorRef.primary),
  reactionSelectedForeground: ThemedColor.ref(ColorRef.primaryForeground),
  reactionPadding: EdgeInsetsDensity.pxSymmetric(horizontal: 6, vertical: 4),
);

/// Resolves the four theme legs plus widget args into one non-null style.
ChatTheme resolveChatStyle(
  BuildContext context, {
  ChatTheme? widgetTheme,
  ThemedColor? background,
  ThemedColor? foreground,
  ChatBubbleVariant? variant,
  AlignmentGeometry? alignment,
  double? widthFactor,
  EdgeInsetsGeometry? padding,
  BorderRadiusGeometry? borderRadius,
  ThemedColor? borderColor,
  double? spacing,
  double? avatarSpacing,
}) {
  final ShadcnThemeData theme = ShadcnTheme.of(context);
  final ChatTheme resolved = resolveComponentStyle<ChatTheme, ChatTheme>(
    context,
    widget: widgetTheme,
    select: (t) => t,
    defaults: chatDefaults,
  );
  return ChatTheme(
    background: background ?? resolved.background,
    foreground: foreground ?? resolved.foreground,
    variant: variant ?? resolved.variant,
    alignment: alignment ?? resolved.alignment,
    widthFactor: widthFactor ?? resolved.widthFactor ?? 0.5,
    padding: padding ?? resolved.padding,
    borderRadius: borderRadius ?? resolved.borderRadius ?? theme.borderRadiusLg,
    borderColor: borderColor ?? resolved.borderColor,
    borderWidth: resolved.borderWidth ?? 1,
    tailSize: resolved.tailSize ?? const Size(8, 8),
    tailRadius: resolved.tailRadius ?? theme.radiusSm,
    tailBehavior: resolved.tailBehavior ?? ChatTailBehavior.last,
    spacing: spacing ?? resolved.spacing ?? 2,
    avatarSpacing: avatarSpacing ?? resolved.avatarSpacing ?? 8,
    avatarAlignment: resolved.avatarAlignment ?? AlignmentDirectional.topEnd,
    reactionBackground: resolved.reactionBackground,
    reactionForeground: resolved.reactionForeground,
    reactionSelectedBackground: resolved.reactionSelectedBackground,
    reactionSelectedForeground: resolved.reactionSelectedForeground,
    reactionPadding: resolved.reactionPadding,
  );
}
