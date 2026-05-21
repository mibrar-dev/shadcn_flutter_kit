// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../chat.dart';

/// Defines when a tail should be shown on a [ChatBubble].
abstract class TailBehavior {
  /// Shows a tail on the first bubble in a group.
  static const first = _ChatTailBehavior(_first);

  /// Shows a tail on the middle bubble in a group.
  static const middle = _ChatTailBehavior(_middle);

  /// Shows a tail on the last bubble in a group.
  static const last = _ChatTailBehavior(_last);

  /// Implements `_first` behavior for chat.
  static bool _first(ChatBubbleData data) => data.index == 0;

  /// Implements `_middle` behavior for chat.
  static bool _middle(ChatBubbleData data) =>
      data.index == (data.length - 1) ~/ 2;

  /// Implements `_last` behavior for chat.
  static bool _last(ChatBubbleData data) => data.index == data.length - 1;

  /// Determines whether the bubble at the given index should have a tail.
  bool wrapWithTail(ChatBubbleData data);
}
