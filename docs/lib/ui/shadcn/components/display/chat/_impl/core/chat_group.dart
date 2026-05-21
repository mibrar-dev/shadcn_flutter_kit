// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../chat.dart';

/// A widget that groups multiple [ChatBubble]s together.
///
/// This widget handles the layout and styling of a group of chat bubbles,
/// including avatar positioning and spacing.
///
/// Example:
/// ```dart
/// ChatGroup(
///   avatarPrefix: Avatar(child: Text('A')),
///   children: [
///     ChatBubble(child: Text('Hello')),
///     ChatBubble(child: Text('How are you?')),
///   ],
/// )
/// ```
class ChatGroup extends StatelessWidget {
  /// The widget to display before the chat bubbles (e.g., an avatar).
  final Widget? avatarPrefix;

  /// The widget to display after the chat bubbles.
  final Widget? avatarSuffix;

  /// The list of chat bubbles to display.
  final List<Widget> children;

  /// The alignment of the chat bubbles within the group.
  final AxisAlignmentGeometry? alignment;

  /// The background color of the chat bubbles.
  final Color? color;

  /// The type of the chat bubbles.
  final ChatBubbleType? type;

  /// The border radius of the chat bubbles.
  final BorderRadiusGeometry? borderRadius;

  /// The padding inside the chat bubbles.
  final EdgeInsetsGeometry? padding;

  /// The border of the chat bubbles.
  final BorderSide? border;

  /// The spacing between chat bubbles.
  final double? spacing;

  /// The alignment of the avatar.
  final AxisAlignmentGeometry? avatarAlignment;

  /// The spacing between the avatar and the chat bubbles.
  final double? avatarSpacing;

  /// Creates a [ChatGroup].
  ///
  /// Parameters:
  /// - [children] (`List<Widget>`, required): The list of chat bubbles to display.
  /// - [alignment] (`AxisAlignmentGeometry?`, optional): The alignment of the chat bubbles within the group.
  /// - [color] (`Color?`, optional): The background color of the chat bubbles.
  /// - [type] (`ChatBubbleType?`, optional): The type of the chat bubbles.
  /// - [borderRadius] (`BorderRadiusGeometry?`, optional): The border radius of the chat bubbles.
  /// - [padding] (`EdgeInsetsGeometry?`, optional): The padding inside the chat bubbles.
  /// - [border] (`BorderSide?`, optional): The border of the chat bubbles.
  /// - [spacing] (`double?`, optional): The spacing between chat bubbles.
  /// - [avatarPrefix] (`Widget?`, optional): The widget to display before the chat bubbles.
  /// - [avatarSuffix] (`Widget?`, optional): The widget to display after the chat bubbles.
  /// - [avatarAlignment] (`AxisAlignmentGeometry?`, optional): The alignment of the avatar.
  /// - [avatarSpacing] (`double?`, optional): The spacing between the avatar and the chat bubbles.
  const ChatGroup({
    super.key,
    required this.children,
    this.alignment,
    this.color,
    this.type,
    this.borderRadius,
    this.padding,
    this.border,
    this.spacing,
    this.avatarPrefix,
    this.avatarSuffix,
    this.avatarAlignment,
    this.avatarSpacing,
  });

  /// Builds the widget tree for chat.
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final compTheme = ComponentTheme.maybeOf<ChatTheme>(context);
    final color = styleValue(
      widgetValue: this.color,
      themeValue: compTheme?.color,
      defaultValue: theme.colorScheme.primary,
    );
    final type = styleValue(
      widgetValue: this.type,
      themeValue: compTheme?.type,
      defaultValue: ChatBubbleType.tail,
    );
    final groupTheme = ComponentTheme.maybeOf<ChatGroupTheme>(context);
    final avatarAlignment =
        styleValue(
              widgetValue: this.avatarAlignment,
              themeValue: groupTheme?.avatarAlignment,
              defaultValue: AxisAlignmentDirectional.end,
            )
            .resolve(Directionality.maybeOf(context) ?? TextDirection.ltr)
            .asVerticalAlignment(AxisAlignment.center);
    return ComponentTheme<ChatTheme>(
      data:
          compTheme?.copyWith(
            alignment: alignment == null ? null : () => alignment,
            border: border == null ? null : () => border,
            borderRadius: borderRadius == null ? null : () => borderRadius,
            color: this.color == null ? null : () => this.color,
            padding: padding == null ? null : () => padding,
            type: this.type == null ? null : () => this.type,
          ) ??
          ChatTheme(
            alignment: alignment,
            border: border,
            borderRadius: borderRadius,
            color: color,
            padding: padding,
            type: type,
          ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: styleValue(
            widgetValue: avatarSpacing,
            themeValue: groupTheme?.avatarSpacing,
            defaultValue: 8 * theme.scaling,
          ),
          children: [
            if (avatarPrefix != null)
              Align(alignment: avatarAlignment, child: avatarPrefix!),

            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: styleValue(
                  widgetValue: spacing,
                  themeValue: groupTheme?.spacing,
                  defaultValue: 2 * theme.scaling,
                ),
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (int i = 0; i < children.length; i++)
                    Data.inherit(
                      data: ChatBubbleData(index: i, length: children.length),
                      child: children[i],
                    ),
                ],
              ),
            ),
            if (avatarSuffix != null)
              Align(alignment: avatarAlignment, child: avatarSuffix!),
          ],
        ),
      ),
    );
  }
}
