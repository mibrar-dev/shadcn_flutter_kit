// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../chat.dart';

/// Internal helper class used by the chat component implementation.
class _ChatTailBehavior implements TailBehavior {
  final bool Function(ChatBubbleData data) shouldHaveTail;
  const _ChatTailBehavior(this.shouldHaveTail);

  /// Implements `wrapWithTail` behavior for chat.
  @override
  bool wrapWithTail(ChatBubbleData data) {
    return shouldHaveTail(data);
  }
}
