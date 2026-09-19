// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../../chat.dart';

/// Theme configuration for [ChatReaction] and [ChatReactionContainer].
///
/// Apply it with [ComponentTheme] to restyle every reaction in a subtree:
///
/// ```dart
/// ComponentTheme<ChatReactionTheme>(
///   data: const ChatReactionTheme(
///     corner: ChatBubbleCornerDirectional.bottomStart,
///   ),
///   child: chatList,
/// );
/// ```
class ChatReactionTheme extends ComponentThemeData {
  /// Default corner for [ChatReaction.corner].
  final ChatBubbleCornerDirectional? corner;

  /// Decoration painted behind a [ChatReactionContainer].
  ///
  /// If null, a rounded muted pill with a contrasting border is used.
  final Decoration? decoration;

  /// How far the reaction is inset from the bubble's left or right edge.
  final double? horizontalPadding;

  /// How far the reaction is inset from the bubble's top or bottom edge.
  final double? verticalPadding;

  /// Padding between a [ChatReactionContainer]'s border and its content.
  final EdgeInsetsGeometry? containerPadding;

  /// The minimum extra width the bubble keeps beyond the reaction when the
  /// reaction is wider than the bubble.
  final double? extraWidth;

  /// Creates a [ChatReactionTheme].
  const ChatReactionTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.corner,
    this.decoration,
    this.horizontalPadding,
    this.verticalPadding,
    this.containerPadding,
    this.extraWidth,
  });

  /// Creates a copy of this theme with the given fields replaced.
  ChatReactionTheme copyWith({
    ValueGetter<ChatBubbleCornerDirectional?>? corner,
    ValueGetter<Decoration?>? decoration,
    ValueGetter<double?>? horizontalPadding,
    ValueGetter<double?>? verticalPadding,
    ValueGetter<EdgeInsetsGeometry?>? containerPadding,
    ValueGetter<double?>? extraWidth,
  }) {
    return ChatReactionTheme(
      corner: corner == null ? this.corner : corner(),
      decoration: decoration == null ? this.decoration : decoration(),
      horizontalPadding: horizontalPadding == null
          ? this.horizontalPadding
          : horizontalPadding(),
      verticalPadding: verticalPadding == null
          ? this.verticalPadding
          : verticalPadding(),
      containerPadding: containerPadding == null
          ? this.containerPadding
          : containerPadding(),
      extraWidth: extraWidth == null ? this.extraWidth : extraWidth(),
    );
  }

  /// Returns a debug string for this chat reaction value.
  @override
  String toString() {
    return 'ChatReactionTheme(corner: $corner, decoration: $decoration, horizontalPadding: $horizontalPadding, verticalPadding: $verticalPadding, extraWidth: $extraWidth)';
  }

  /// Compares two chat reaction values for structural equality.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ChatReactionTheme &&
        other.corner == corner &&
        other.decoration == decoration &&
        other.horizontalPadding == horizontalPadding &&
        other.verticalPadding == verticalPadding &&
        other.containerPadding == containerPadding &&
        other.extraWidth == extraWidth;
  }

  @override
  int get hashCode {
    return Object.hash(
      corner,
      decoration,
      horizontalPadding,
      verticalPadding,
      containerPadding,
      extraWidth,
    );
  }
}
