// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../chat.dart';

/// A simple [ChatBubbleType] with no tail.
class PlainChatBubbleType extends ChatBubbleType {
  /// The border radius of the bubble.
  final BorderRadiusGeometry? borderRadius;

  /// The border of the bubble.
  final BorderSide? border;

  /// The padding inside the bubble.
  final EdgeInsetsGeometry? padding;

  /// Creates a [PlainChatBubbleType].
  ///
  /// Parameters:
  /// - [borderRadius] (`BorderRadiusGeometry?`, optional): The border radius of the bubble.
  /// - [border] (`BorderSide?`, optional): The border of the bubble.
  /// - [padding] (`EdgeInsetsGeometry?`, optional): The padding inside the bubble.
  const PlainChatBubbleType({this.borderRadius, this.border, this.padding});
  @override
  Widget wrap(
    BuildContext context,
    Widget child,
    ChatBubbleData data,
    ChatBubble chat,
  ) {
    final theme = Theme.of(context);

    final compTheme = ComponentTheme.maybeOf<ChatTheme>(context);
    final border = styleValue(
      widgetValue: this.border,
      themeValue: compTheme?.border,
      defaultValue: null,
    );
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
    return Container(
      decoration: BoxDecoration(
        borderRadius: styleValue(
          widgetValue: borderRadius,
          themeValue: compTheme?.borderRadius,
          defaultValue: theme.borderRadiusLg,
        ),
        border: border == null
            ? null
            : Border.all(
                color: border.color,
                width: border.width,
                strokeAlign: border.strokeAlign,
                style: border.style,
              ),
        color: color,
      ),
      padding: padding,
      child: child,
    );
  }
}
