// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../chat.dart';

/// Defines the theme for [ChatBubble]s.
class ChatTheme extends ComponentThemeData {
  /// The background color of the chat bubble.
  final Color? color;

  /// The alignment of the chat bubble.
  final AxisAlignmentGeometry? alignment;

  /// The type of the chat bubble (e.g., plain, tailed).
  final ChatBubbleType? type;

  /// The border radius of the chat bubble.
  final BorderRadiusGeometry? borderRadius;

  /// The padding inside the chat bubble.
  final EdgeInsetsGeometry? padding;

  /// The border of the chat bubble.
  final BorderSide? border;

  /// The width factor of the chat bubble.
  final double? widthFactor;

  /// Creates a [ChatTheme].
  ///
  /// Parameters:
  /// - [color] (`Color?`, optional): The background color of the chat bubble.
  /// - [alignment] (`AxisAlignmentGeometry?`, optional): The alignment of the chat bubble.
  /// - [type] (`ChatBubbleType?`, optional): The type of the chat bubble (e.g., plain, tailed).
  /// - [borderRadius] (`BorderRadiusGeometry?`, optional): The border radius of the chat bubble.
  /// - [padding] (`EdgeInsetsGeometry?`, optional): The padding inside the chat bubble.
  /// - [border] (`BorderSide?`, optional): The border of the chat bubble.
  /// - [widthFactor] (`double?`, optional): The width factor of the chat bubble.
  const ChatTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.color,
    this.alignment,
    this.type,
    this.borderRadius,
    this.padding,
    this.border,
    this.widthFactor,
  });

  /// Creates a copy of this theme with the given fields replaced with the new values.
  ///
  /// Parameters:
  /// - [color] (`ValueGetter<Color?>?`, optional): New color value.
  /// - [alignment] (`ValueGetter<AxisAlignmentGeometry?>?`, optional): New alignment value.
  /// - [type] (`ValueGetter<ChatBubbleType?>?`, optional): New type value.
  /// - [borderRadius] (`ValueGetter<BorderRadiusGeometry?>?`, optional): New border radius value.
  /// - [padding] (`ValueGetter<EdgeInsetsGeometry?>?`, optional): New padding value.
  /// - [border] (`ValueGetter<BorderSide?>?`, optional): New border value.
  ///
  /// Returns:
  /// A new [ChatTheme] with the specified values updated.
  ChatTheme copyWith({
    ValueGetter<Color?>? color,
    ValueGetter<AxisAlignmentGeometry?>? alignment,
    ValueGetter<ChatBubbleType?>? type,
    ValueGetter<BorderRadiusGeometry?>? borderRadius,
    ValueGetter<EdgeInsetsGeometry?>? padding,
    ValueGetter<BorderSide?>? border,
    ValueGetter<double?>? widthFactor,
  }) {
    return ChatTheme(
      color: color == null ? this.color : color(),
      alignment: alignment == null ? this.alignment : alignment(),
      type: type == null ? this.type : type(),
      borderRadius: borderRadius == null ? this.borderRadius : borderRadius(),
      padding: padding == null ? this.padding : padding(),
      border: border == null ? this.border : border(),
      widthFactor: widthFactor == null ? this.widthFactor : widthFactor(),
    );
  }

  /// Returns a debug string for this chat value.
  @override
  String toString() {
    return 'ChatTheme(color: $color, alignment: $alignment, type: $type, borderRadius: $borderRadius, padding: $padding, border: $border, widthFactor: $widthFactor)';
  }

  /// Compares two chat values for structural equality.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ChatTheme &&
        other.color == color &&
        other.alignment == alignment &&
        other.type == type &&
        other.borderRadius == borderRadius &&
        other.padding == padding &&
        other.border == border &&
        other.widthFactor == widthFactor;
  }

  @override
  int get hashCode {
    return Object.hash(
      color,
      alignment,
      type,
      borderRadius,
      padding,
      border,
      widthFactor,
    );
  }
}
