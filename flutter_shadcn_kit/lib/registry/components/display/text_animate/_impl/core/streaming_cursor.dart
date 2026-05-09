// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../text_animate.dart';

/// Cursor configuration for [StreamingText].
@immutable
class StreamingCursor {
  /// Creates `StreamingCursor.none` for configuring or rendering text animate.
  const StreamingCursor.none()
    : enabled = false,
      blink = false,
      character = '',
      blinkPeriod = Duration.zero,
      showWhenSettled = false,
      style = null;

  /// Creates `StreamingCursor.blink` for configuring or rendering text animate.
  const StreamingCursor.blink({
    this.character = '|',
    this.blinkPeriod = const Duration(milliseconds: 650),
    this.showWhenSettled = true,
    this.style,
  }) : enabled = true,
       blink = true;

  /// Creates `StreamingCursor.solid` for configuring or rendering text animate.
  const StreamingCursor.solid({
    this.character = '|',
    this.showWhenSettled = true,
    this.style,
  }) : enabled = true,
       blink = false,
       blinkPeriod = Duration.zero;

  /// Whether the cursor is rendered.
  final bool enabled;

  /// Whether cursor visibility should toggle over time.
  final bool blink;

  /// Cursor text.
  final String character;

  /// Blink cycle duration.
  final Duration blinkPeriod;

  /// Optional cursor style merged over text style.
  final TextStyle? style;

  /// Keeps cursor visible after animation settles.
  final bool showWhenSettled;

  /// Compares two text animate values for structural equality.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is StreamingCursor &&
        other.enabled == enabled &&
        other.blink == blink &&
        other.character == character &&
        other.blinkPeriod == blinkPeriod &&
        other.showWhenSettled == showWhenSettled &&
        other.style == style;
  }

  @override
  int get hashCode => Object.hash(
    enabled,
    blink,
    character,
    blinkPeriod,
    showWhenSettled,
    style,
  );
}
