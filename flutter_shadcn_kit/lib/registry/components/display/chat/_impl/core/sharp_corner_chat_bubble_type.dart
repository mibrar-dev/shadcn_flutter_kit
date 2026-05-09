// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../chat.dart';

/// A [ChatBubbleType] that makes one corner sharp instead of rounded.
///
/// This style modifies the border radius of one corner to create a pointed
/// corner effect, similar to a speech bubble tail.
class SharpCornerChatBubbleType extends ChatBubbleType {
  /// The corner where the tail should be applied.
  final ChatBubbleCornerDirectional? corner;

  /// The border radius of the bubble.
  final BorderRadiusGeometry? borderRadius;

  /// The padding inside the bubble.
  final EdgeInsetsGeometry? padding;

  /// The behavior determining when to show the tail.
  final TailBehavior? tailBehavior;

  /// Creates a [SharpCornerChatBubbleType].
  ///
  /// Parameters:
  /// - [corner] (`ChatBubbleCornerDirectional?`, optional): The corner that should be sharp.
  /// - [borderRadius] (`BorderRadiusGeometry?`, optional): The border radius of the bubble.
  /// - [padding] (`EdgeInsetsGeometry?`, optional): The padding inside the bubble.
  /// - [tailBehavior] (`TailBehavior?`, optional): The behavior determining when to show the sharp corner.
  const SharpCornerChatBubbleType({
    this.corner,
    this.borderRadius,
    this.padding,
    this.tailBehavior,
  });

  /// Creates a copy of this bubble type with the given fields replaced with the new values.
  ///
  /// Parameters:
  /// - [corner] (`ValueGetter<ChatBubbleCornerDirectional?>?`, optional): New corner value.
  /// - [borderRadius] (`ValueGetter<BorderRadiusGeometry?>?`, optional): New border radius value.
  /// - [padding] (`ValueGetter<EdgeInsetsGeometry?>?`, optional): New padding value.
  /// - [tailBehavior] (`ValueGetter<TailBehavior?>?`, optional): New tail behavior value.
  ///
  /// Returns:
  /// A new [SharpCornerChatBubbleType] with the specified values updated.
  SharpCornerChatBubbleType copyWith({
    ValueGetter<ChatBubbleCornerDirectional?>? corner,
    ValueGetter<BorderRadiusGeometry?>? borderRadius,
    ValueGetter<EdgeInsetsGeometry?>? padding,
    ValueGetter<TailBehavior?>? tailBehavior,
  }) {
    return SharpCornerChatBubbleType(
      corner: corner == null ? this.corner : corner(),
      borderRadius: borderRadius == null ? this.borderRadius : borderRadius(),
      padding: padding == null ? this.padding : padding(),
      tailBehavior: tailBehavior == null ? this.tailBehavior : tailBehavior(),
    );
  }

  @override
  Widget wrap(
    BuildContext context,
    Widget child,
    ChatBubbleData data,
    ChatBubble chat,
  ) {
    final theme = Theme.of(context);

    final compTheme = ComponentTheme.maybeOf<ChatTheme>(context);

    final compTailTheme = ComponentTheme.maybeOf<ChatTailTheme>(context);

    final textDirection = Directionality.maybeOf(context) ?? TextDirection.ltr;
    final padding = styleValue(
      widgetValue: this.padding,
      themeValue: compTheme?.padding,
      defaultValue: EdgeInsets.symmetric(
        horizontal: 12 * theme.scaling,
        vertical: 8 * theme.scaling,
      ),
    );
    final color = styleValue(
      widgetValue: chat.color,
      themeValue: compTheme?.color,
      defaultValue: theme.colorScheme.primary,
    );
    var radius = styleValue(
      widgetValue: borderRadius,
      themeValue: compTheme?.borderRadius,
      defaultValue: theme.borderRadiusLg,
    ).resolve(textDirection);
    final tailBehavior = styleValue(
      widgetValue: this.tailBehavior,
      themeValue: compTailTheme?.tailBehavior,
      defaultValue: TailBehavior.last,
    );
    if (tailBehavior.wrapWithTail(data)) {
      ChatBubbleCorner? corner = this.corner?.resolve(textDirection);
      if (corner == null) {
        // guess corner based on alignment
        final alignment = styleValue(
          widgetValue: chat.alignment,
          themeValue: compTheme?.alignment,
          defaultValue: AxisAlignmentDirectional.end,
        ).resolve(textDirection);
        if (alignment.value > 0) {
          corner = ChatBubbleCorner.bottomRight;
        } else {
          corner = ChatBubbleCorner.bottomLeft;
        }
      }
      switch (corner) {
        case ChatBubbleCorner.topLeft:
          radius = radius.copyWith(topLeft: Radius.zero);
          break;
        case ChatBubbleCorner.topRight:
          radius = radius.copyWith(topRight: Radius.zero);
          break;
        case ChatBubbleCorner.bottomLeft:
          radius = radius.copyWith(bottomLeft: Radius.zero);
          break;
        case ChatBubbleCorner.bottomRight:
          radius = radius.copyWith(bottomRight: Radius.zero);
          break;
      }
    }
    return Container(
      decoration: BoxDecoration(borderRadius: radius, color: color),
      padding: padding,
      child: child,
    );
  }
}
