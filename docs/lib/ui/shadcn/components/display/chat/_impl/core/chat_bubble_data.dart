// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../chat.dart';

/// Data associated with a [ChatBubble] within a [ChatGroup].
class ChatBubbleData {
  /// The index of the bubble in the group.
  final int index;

  /// The total number of bubbles in the group.
  final int length;

  /// Creates a [ChatBubbleData].
  ///
  /// Parameters:
  /// - [index] (`int`, required): The index of the bubble in the group.
  /// - [length] (`int`, required): The total number of bubbles in the group.
  const ChatBubbleData({required this.index, required this.length});

  /// Creates a copy of this data with the given fields replaced with the new values.
  ///
  /// Parameters:
  /// - [index] (`int?`, optional): New index value.
  /// - [length] (`int?`, optional): New length value.
  ///
  /// Returns:
  /// A new [ChatBubbleData] with the specified values updated.
  ChatBubbleData copyWith({int? index, int? length}) {
    return ChatBubbleData(
      index: index ?? this.index,
      length: length ?? this.length,
    );
  }

  /// Returns a debug string for this chat value.
  @override
  String toString() {
    return 'ChatBubbleData(index: $index, length: $length)';
  }

  /// Compares two chat values for structural equality.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ChatBubbleData &&
        other.index == index &&
        other.length == length;
  }

  @override
  int get hashCode {
    return Object.hash(index, length);
  }
}
