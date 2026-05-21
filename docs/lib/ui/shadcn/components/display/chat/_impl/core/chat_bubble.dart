// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../chat.dart';

/// A widget that displays a single chat message or content.
///
/// This widget renders a chat bubble with customizable styling, including
/// background color, alignment, and tail behavior.
///
/// Example:
/// ```dart
/// ChatBubble(
///   child: Text('Hello World'),
///   alignment: AxisAlignment.right,
///   color: Colors.blue,
/// )
/// ```
class ChatBubble extends StatelessWidget {
  /// The content of the chat bubble.
  final Widget child;

  /// The type of the chat bubble.
  final ChatBubbleType? type;

  /// The background color of the chat bubble.
  final Color? color;

  /// The alignment of the chat bubble.
  final AxisAlignmentGeometry? alignment;

  /// The border of the chat bubble.
  final BorderSide? border;

  /// The padding inside the chat bubble.
  final EdgeInsetsGeometry? padding;

  /// The border radius of the chat bubble.
  final BorderRadiusGeometry? borderRadius;

  /// The width factor of the chat bubble.
  final double? widthFactor;

  /// Creates a [ChatBubble].
  ///
  /// Parameters:
  /// - [child] (`Widget`, required): The content of the chat bubble.
  /// - [type] (`ChatBubbleType?`, optional): The type of the chat bubble.
  /// - [color] (`Color?`, optional): The background color of the chat bubble.
  /// - [alignment] (`AxisAlignmentGeometry?`, optional): The alignment of the chat bubble.
  /// - [border] (`BorderSide?`, optional): The border of the chat bubble.
  /// - [padding] (`EdgeInsetsGeometry?`, optional): The padding inside the chat bubble.
  /// - [borderRadius] (`BorderRadiusGeometry?`, optional): The border radius of the chat bubble.
  /// - [widthFactor] (`double?`, optional): The width factor of the chat bubble.
  const ChatBubble({
    super.key,
    required this.child,
    this.type,
    this.color,
    this.alignment,
    this.border,
    this.padding,
    this.borderRadius,
    this.widthFactor,
  });

  /// Builds the widget tree for chat.
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final chatTheme = ComponentTheme.maybeOf<ChatTheme>(context);
    final textDirection = Directionality.maybeOf(context) ?? TextDirection.ltr;
    final alignment = styleValue(
      widgetValue: this.alignment,
      themeValue: chatTheme?.alignment,
      defaultValue: AxisAlignmentDirectional.end,
    ).resolve(textDirection);
    final type = styleValue(
      widgetValue: this.type,
      themeValue: chatTheme?.type,
      defaultValue: ChatBubbleType.tail,
    );
    final effectiveData =
        (Data.maybeOf<ChatBubbleData>(context) ??
        ChatBubbleData(index: 0, length: 1));
    final widthFactor = styleValue(
      widgetValue: this.widthFactor,
      themeValue: chatTheme?.widthFactor,
      defaultValue: 0.5,
    );
    final bubbleColor = styleValue(
      widgetValue: color,
      themeValue: chatTheme?.color,
      defaultValue: theme.colorScheme.primary,
    );
    final foregroundColor = _chatForegroundColorFor(bubbleColor);
    return ChatConstrainedBox(
      widthFactor: widthFactor,
      alignment: alignment,
      child: ComponentTheme(
        data:
            chatTheme?.copyWith(
              color: color == null ? null : () => color,
              type: () => type,
              alignment: () => alignment,
              border: border == null ? null : () => border,
              padding: padding == null ? null : () => padding,
              borderRadius: borderRadius == null ? null : () => borderRadius,
              widthFactor: widthFactor == 0.5 ? null : () => widthFactor,
            ) ??
            ChatTheme(
              color: color,
              type: type,
              alignment: alignment,
              border: border,
              padding: padding,
              borderRadius: borderRadius,
              widthFactor: widthFactor,
            ),
        child: Builder(
          builder: (context) {
            return type.wrap(
              context,
              DefaultTextStyle.merge(
                style: TextStyle(color: foregroundColor),
                child: IconTheme.merge(
                  data: IconThemeData(color: foregroundColor),
                  child: child,
                ),
              ),
              effectiveData,
              this,
            );
          },
        ),
      ),
    );
  }
}
