// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../chat.dart';

/// Defines the directional corner of a [ChatBubble].
///
/// This is used to support RTL languages by defining corners in terms of
/// start and end instead of left and right.
enum ChatBubbleCornerDirectional {
  /// The top-start corner (top-left in LTR, top-right in RTL).
  topStart,

  /// The top-end corner (top-right in LTR, top-left in RTL).
  topEnd,

  /// The bottom-start corner (bottom-left in LTR, bottom-right in RTL).
  bottomStart,

  /// The bottom-end corner (bottom-right in LTR, bottom-left in RTL).
  bottomEnd;

  /// Resolves the directional corner to a concrete [ChatBubbleCorner] based on the text direction.
  ChatBubbleCorner resolve(TextDirection direction) {
    return switch ((this, direction)) {
      (ChatBubbleCornerDirectional.topStart, TextDirection.ltr) =>
        ChatBubbleCorner.topLeft,
      (ChatBubbleCornerDirectional.topStart, TextDirection.rtl) =>
        ChatBubbleCorner.topRight,
      (ChatBubbleCornerDirectional.topEnd, TextDirection.ltr) =>
        ChatBubbleCorner.topRight,
      (ChatBubbleCornerDirectional.topEnd, TextDirection.rtl) =>
        ChatBubbleCorner.topLeft,
      (ChatBubbleCornerDirectional.bottomStart, TextDirection.ltr) =>
        ChatBubbleCorner.bottomLeft,
      (ChatBubbleCornerDirectional.bottomStart, TextDirection.rtl) =>
        ChatBubbleCorner.bottomRight,
      (ChatBubbleCornerDirectional.bottomEnd, TextDirection.ltr) =>
        ChatBubbleCorner.bottomRight,
      (ChatBubbleCornerDirectional.bottomEnd, TextDirection.rtl) =>
        ChatBubbleCorner.bottomLeft,
    };
  }
}
