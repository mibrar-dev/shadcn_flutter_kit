// The `chat` component: [ChatBubble] (plain / tailed / sharp-corner), [ChatGroup] (bubbles + avatars) and [ChatReaction] (chip rows).
// Fixes over the old copy: the part-file tree and 4 theme classes are gone, the luminance-picked foreground (`0xFF111827`)
// is the `primaryForeground` token, and the dead `ChatCollapsible` marker is not ported (README).

import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../../foundation/data.dart';
import '../../primitives/clickable.dart';
import '../../primitives/fractional_align_box.dart';
import '../../primitives/overlap_layout.dart';
import '../../theme/color_tokens.dart';
import '../../theme/density.dart';
import '../../theme/theme.dart';
import 'chat_style.dart';

export 'chat_style.dart';

/// Position of a bubble in its [ChatGroup], fed through [Data] for the tail behaviour.
class ChatBubbleData {
  const ChatBubbleData({required this.index, required this.length});

  final int index;
  final int length;
}

/// A chat message bubble, aligned to its side of the row.
class ChatBubble extends StatelessWidget {
  const ChatBubble({
    super.key,
    required this.child,
    this.variant,
    this.alignment,
    this.color,
    this.padding,
    this.borderRadius,
    this.borderColor,
    this.corner,
    this.widthFactor,
    this.theme,
  });

  final Widget child;

  final ChatBubbleVariant? variant;
  final AlignmentGeometry? alignment;
  final ThemedColor? color;
  final EdgeInsetsGeometry? padding;
  final BorderRadiusGeometry? borderRadius;
  final ThemedColor? borderColor;

  /// Corner that sharpens / carries the tail; null = the bubble's side corner.
  final ChatBubbleCornerDirectional? corner;

  final double? widthFactor;

  /// Widget-leg theme override, merged on top of the other legs.
  final ChatTheme? theme;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData shadcn = ShadcnTheme.of(context);
    final TextDirection direction = Directionality.of(context);
    final ChatTheme style = resolveChatStyle(
      context,
      widgetTheme: theme,
      background: color,
      variant: variant,
      alignment: alignment,
      widthFactor: widthFactor,
      padding: padding,
      borderRadius: borderRadius,
      borderColor: borderColor,
    );
    final ChatBubbleData data =
        Data.maybeOf<ChatBubbleData>(context) ??
        const ChatBubbleData(index: 0, length: 1);
    final Alignment resolved = style.alignment!.resolve(direction);
    final ChatBubbleCorner bubbleCorner =
        corner?.resolve(direction) ??
        (resolved.x >= 0
            ? ChatBubbleCorner.bottomRight
            : ChatBubbleCorner.bottomLeft);
    final Color background = style.background!.resolve(shadcn.colors);
    final Color foreground = style.foreground!.resolve(shadcn.colors);
    final IconThemeData icons = IconThemeData(color: foreground);
    final BorderRadiusGeometry source = style.borderRadius!;
    final BorderRadius radius = source is BorderRadius
        ? source
        : source.resolve(direction);
    final bool sharp = style.variant == ChatBubbleVariant.sharpCorner;
    // Density multipliers resolve where they paint; a literal override (widget
    // or app leg) passes through unchanged.
    final EdgeInsetsGeometry bubblePadding = resolveEdgeInsets(
      style.padding!,
      shadcn.density.baseContentPadding * shadcn.scaling,
    );
    final Widget content = DecoratedBox(
      decoration: BoxDecoration(
        color: background,
        borderRadius: sharp ? _zeroCorner(radius, bubbleCorner) : radius,
        border: style.borderColor == null
            ? null
            : Border.all(
                color: style.borderColor!.resolve(shadcn.colors),
                width: style.borderWidth!,
              ),
      ),
      child: Padding(
        padding: bubblePadding,
        child: DefaultTextStyle.merge(
          style: TextStyle(color: foreground),
          child: IconTheme.merge(data: icons, child: child),
        ),
      ),
    );
    Widget result = content;
    final bool carries = switch (style.tailBehavior!) {
      ChatTailBehavior.first => data.index == 0,
      ChatTailBehavior.middle => data.index == (data.length - 1) ~/ 2,
      ChatTailBehavior.last => data.index == data.length - 1,
      ChatTailBehavior.never => false,
    };
    if (style.variant == ChatBubbleVariant.tail && carries) {
      final Size tail = style.tailSize!;
      final double inset = tail.height;
      final bool bottom =
          bubbleCorner == ChatBubbleCorner.bottomRight ||
          bubbleCorner == ChatBubbleCorner.bottomLeft;
      result = CustomPaint(
        painter: _ChatTailPainter(
          color: background,
          borderColor: style.borderColor?.resolve(shadcn.colors),
          borderWidth: style.borderWidth!,
          radius: radius,
          corner: bubbleCorner,
          tailSize: tail,
          tailRadius: style.tailRadius ?? shadcn.radiusSm,
        ),
        child: Padding(
          padding: EdgeInsets.only(
            top: bottom ? 0 : inset,
            bottom: bottom ? inset : 0,
          ),
          child: content,
        ),
      );
    }
    return FractionalAlignBox(
      factor: style.widthFactor!,
      alignment: resolved,
      child: result,
    );
  }

  BorderRadius _zeroCorner(BorderRadius radius, ChatBubbleCorner corner) {
    return switch (corner) {
      ChatBubbleCorner.topLeft => radius.copyWith(topLeft: Radius.zero),
      ChatBubbleCorner.topRight => radius.copyWith(topRight: Radius.zero),
      ChatBubbleCorner.bottomLeft => radius.copyWith(bottomLeft: Radius.zero),
      ChatBubbleCorner.bottomRight => radius.copyWith(bottomRight: Radius.zero),
    };
  }
}

/// A stack of [ChatBubble]s with optional avatars; it publishes its surface overrides as the scoped theme leg.
class ChatGroup extends StatelessWidget {
  const ChatGroup({
    super.key,
    required this.children,
    this.alignment,
    this.color,
    this.foreground,
    this.variant,
    this.borderRadius,
    this.padding,
    this.borderColor,
    this.spacing,
    this.avatarPrefix,
    this.avatarSuffix,
    this.avatarAlignment,
    this.avatarSpacing,
    this.theme,
  });

  /// Bubbles, top to bottom.
  final List<Widget> children;

  /// Surface overrides applied to every bubble in the group.
  final AlignmentGeometry? alignment;
  final ThemedColor? color;
  final ThemedColor? foreground;
  final ChatBubbleVariant? variant;
  final BorderRadiusGeometry? borderRadius;
  final EdgeInsetsGeometry? padding;
  final ThemedColor? borderColor;

  /// Vertical gap between bubbles; null uses the theme, then `2`.
  final double? spacing;

  /// Widget shown before (or after) the bubbles, e.g. an avatar.
  final Widget? avatarPrefix;
  final Widget? avatarSuffix;

  /// Edge alignment of the avatars / gap to them; null uses the theme.
  final AlignmentGeometry? avatarAlignment;
  final double? avatarSpacing;

  /// Widget-leg theme override for the group layout and its bubbles.
  final ChatTheme? theme;

  @override
  Widget build(BuildContext context) {
    final ChatTheme style = resolveChatStyle(
      context,
      widgetTheme: theme,
      foreground: foreground,
      spacing: spacing,
      avatarSpacing: avatarSpacing,
      avatarAlignment: avatarAlignment,
    );
    // Only explicit values become the scoped leg, so app overrides below
    // still reach the bubbles; the group's `theme` arg outranks them.
    final ChatTheme group = ChatTheme(
      background: color,
      foreground: foreground,
      variant: variant,
      alignment: alignment,
      padding: padding,
      borderRadius: borderRadius,
      borderColor: borderColor,
      spacing: spacing,
      avatarAlignment: avatarAlignment,
      avatarSpacing: avatarSpacing,
    );
    return ComponentTheme<ChatTheme>(
      data: theme?.merge(group) ?? group,
      // No IntrinsicHeight + CrossAxisAlignment.stretch here: a stretch Row
      // has no intrinsic height, so IntrinsicHeight had to invent one from the
      // avatars (32px) and then forced the Flexible bubble column into it,
      // overflowing by the whole column (P6-F3). The row now sizes itself to
      // the tallest child - the bubble column - and the avatars keep their
      // own size, positioned by `avatarAlignment`.
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: style.avatarSpacing!,
        children: <Widget>[
          if (avatarPrefix != null)
            Align(alignment: style.avatarAlignment!, child: avatarPrefix!),
          Flexible(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: style.spacing!,
              children: <Widget>[
                for (int i = 0; i < children.length; i++)
                  Data<ChatBubbleData>.inherit(
                    data: ChatBubbleData(index: i, length: children.length),
                    child: children[i],
                  ),
              ],
            ),
          ),
          if (avatarSuffix != null)
            Align(alignment: style.avatarAlignment!, child: avatarSuffix!),
        ],
      ),
    );
  }
}

/// Reaction chips hung over a bubble's side corner (corner maps to [OverlapCorner] by enum order); each chip toggles through its own `ChatReactionContainer.onTap`.
class ChatReaction extends StatelessWidget {
  const ChatReaction({
    super.key,
    required this.child,
    required this.chips,
    this.corner,
    this.gap,
    this.extraWidth,
    this.theme,
  });
  final Widget child;
  final List<Widget> chips;
  final ChatBubbleCornerDirectional? corner;
  final double? gap;
  final double? extraWidth;
  final ChatTheme? theme;

  @override
  Widget build(BuildContext context) {
    final TextDirection dir = Directionality.of(context);
    final ChatTheme style = resolveChatStyle(context, widgetTheme: theme);
    final ShadcnThemeData shadcn = ShadcnTheme.of(context);
    final Alignment side = style.alignment!.resolve(dir);
    final ChatBubbleCorner fallback = side.x >= 0
        ? ChatBubbleCorner.bottomRight
        : ChatBubbleCorner.bottomLeft;
    final ChatBubbleCorner at = corner?.resolve(dir) ?? fallback;
    return OverlapLayout(
      corner: OverlapCorner.values[at.index],
      alignment: side,
      gap: (gap ?? 8) * shadcn.scaling,
      extraWidth: (extraWidth ?? 8) * shadcn.scaling,
      overlap: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 4 * shadcn.scaling,
        children: chips,
      ),
      child: ComponentTheme<ChatTheme>(
        data: const ChatTheme(widthFactor: 1.0),
        child: child,
      ),
    );
  }
}

/// One reaction chip (emoji + count) in a pill; [onTap] toggles it, [selected] paints the selected colours.
class ChatReactionContainer extends StatelessWidget {
  const ChatReactionContainer({
    super.key,
    required this.child,
    this.onTap,
    this.selected = false,
    this.theme,
  });
  final Widget child;
  final VoidCallback? onTap;
  final bool selected;
  final ChatTheme? theme;

  @override
  Widget build(BuildContext context) {
    final ChatTheme style = resolveChatStyle(context, widgetTheme: theme);
    final ShadcnThemeData shadcn = ShadcnTheme.of(context);
    final ShadcnColors colors = shadcn.colors;
    ThemedColor fill = style.reactionBackground!;
    ThemedColor label = style.reactionForeground!;
    if (selected) fill = style.reactionSelectedBackground!;
    if (selected) label = style.reactionSelectedForeground!;
    final EdgeInsetsGeometry pillPadding = resolveEdgeInsets(
      style.reactionPadding!,
      shadcn.density.baseContentPadding * shadcn.scaling,
    );
    final BoxDecoration decoration = BoxDecoration(
      color: fill.resolve(colors),
      border: Border.all(color: colors.border),
      borderRadius: const BorderRadius.all(Radius.circular(999)),
    );
    final TextStyle textStyle = TextStyle(color: label.resolve(colors));
    if (onTap == null) {
      return Container(
        padding: pillPadding,
        decoration: decoration,
        child: DefaultTextStyle.merge(style: textStyle, child: child),
      );
    }
    // Keyboard, hover, focus ring and button semantics come from the
    // primitive; a raw GestureDetector gave tap-only behaviour.
    return Clickable(
      onPressed: onTap,
      decoration: WidgetStatePropertyAll<BoxDecoration?>(decoration),
      textStyle: WidgetStatePropertyAll<TextStyle?>(textStyle),
      child: Container(padding: pillPadding, child: child),
    );
  }
}

/// Paints the small triangular tail of a bubble at [corner].
class _ChatTailPainter extends CustomPainter {
  const _ChatTailPainter({
    required this.color,
    required this.borderColor,
    required this.borderWidth,
    required this.radius,
    required this.corner,
    required this.tailSize,
    required this.tailRadius,
  });

  /// Bubble fill, corner radius (the base grows past it to join cleanly),
  /// corner, tail extent and tip rounding.
  final Color color;

  /// Bubble border, painted along the tail outline so a bordered bubble
  /// keeps its ring around the nub; null draws a fill-only tail.
  final Color? borderColor;

  /// Width of the tail outline; ignored when [borderColor] is null.
  final double borderWidth;
  final BorderRadius radius;
  final ChatBubbleCorner corner;
  final Size tailSize;
  final double tailRadius;

  // Corner order (topLeft, topRight, bottomLeft, bottomRight): the low bit separates right/left, the high bit bottom/top.
  @override
  void paint(Canvas canvas, Size size) {
    final bool right = corner.index & 1 == 1;
    final bool bottom = corner.index >= 2;
    final double h = tailSize.height;
    final double w = tailSize.width;
    final double baseY = bottom ? size.height - h : h;
    final double baseX = right ? size.width - w : 0;
    final List<double> radii = <double>[
      radius.topLeft.y,
      radius.topRight.y,
      radius.bottomLeft.y,
      radius.bottomRight.y,
    ];
    final double cornerRadius = radii[corner.index];
    final Offset i1 = Offset(baseX, baseY);
    final Offset i2 = Offset(baseX + w, baseY);
    final Offset tip = Offset(right ? size.width : 0, bottom ? size.height : 0);
    // Grow the base points past the rounded corner so the tail joins it.
    final double r = tailRadius;
    final Offset v1 = i1 - tip;
    final Offset v2 = i2 - tip;
    final double d1 = v1.distance;
    final double d2 = v2.distance;
    final Offset b1 = d1 == 0 ? i1 : tip + v1 * ((d1 + cornerRadius) / d1);
    final Offset b2 = d2 == 0 ? i2 : tip + v2 * ((d2 + cornerRadius) / d2);
    final double e1 = (b1 - tip).distance;
    final double e2 = (b2 - tip).distance;
    final Offset p1 = e1 == 0 ? tip : tip + (b1 - tip) * (math.min(e1, r) / e1);
    final Offset p2 = e2 == 0 ? tip : tip + (b2 - tip) * (math.min(e2, r) / e2);
    final Path path = Path()
      ..moveTo(b1.dx, b1.dy)
      ..lineTo(p1.dx, p1.dy)
      ..quadraticBezierTo(tip.dx, tip.dy, p2.dx, p2.dy)
      ..lineTo(b2.dx, b2.dy)
      ..close();
    canvas.drawPath(path, Paint()..color = color);
    if (borderColor != null && borderWidth > 0) {
      canvas.drawPath(
        path,
        Paint()
          ..color = borderColor!
          ..style = PaintingStyle.stroke
          ..strokeWidth = borderWidth,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ChatTailPainter oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.borderColor != borderColor ||
      oldDelegate.borderWidth != borderWidth ||
      oldDelegate.radius != radius ||
      oldDelegate.corner != corner ||
      oldDelegate.tailSize != tailSize ||
      oldDelegate.tailRadius != tailRadius;
}
