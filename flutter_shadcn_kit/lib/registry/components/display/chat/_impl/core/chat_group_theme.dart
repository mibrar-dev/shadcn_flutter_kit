// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../chat.dart';

/// Defines the theme for a [ChatGroup].
class ChatGroupTheme extends ComponentThemeData {
  /// The spacing between chat bubbles in the group.
  final double? spacing;

  /// The alignment of the avatar relative to the chat bubbles.
  final AxisAlignmentGeometry? avatarAlignment;

  /// The spacing between the avatar and the chat bubbles.
  final double? avatarSpacing;

  /// Creates a [ChatGroupTheme].
  ///
  /// Parameters:
  /// - [spacing] (`double?`, optional): The spacing between chat bubbles in the group.
  /// - [avatarAlignment] (`AxisAlignmentGeometry?`, optional): The alignment of the avatar relative to the chat bubbles.
  /// - [avatarSpacing] (`double?`, optional): The spacing between the avatar and the chat bubbles.
  const ChatGroupTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.spacing,
    this.avatarAlignment,
    this.avatarSpacing,
  });

  /// Creates a copy of this theme with the given fields replaced with the new values.
  ///
  /// Parameters:
  /// - [spacing] (`ValueGetter<double?>?`, optional): New spacing value.
  /// - [avatarAlignment] (`ValueGetter<AxisAlignmentGeometry?>?`, optional): New avatar alignment value.
  /// - [avatarSpacing] (`ValueGetter<double?>?`, optional): New avatar spacing value.
  ///
  /// Returns:
  /// A new [ChatGroupTheme] with the specified values updated.
  ChatGroupTheme copyWith({
    ValueGetter<double?>? spacing,
    ValueGetter<AxisAlignmentGeometry?>? avatarAlignment,
    ValueGetter<double?>? avatarSpacing,
  }) {
    return ChatGroupTheme(
      spacing: spacing == null ? this.spacing : spacing(),
      avatarAlignment: avatarAlignment == null
          ? this.avatarAlignment
          : avatarAlignment(),
      avatarSpacing: avatarSpacing == null
          ? this.avatarSpacing
          : avatarSpacing(),
    );
  }

  /// Returns a debug string for this chat value.
  @override
  String toString() {
    return 'ChatGroupTheme(spacing: $spacing, avatarAlignment: $avatarAlignment, avatarSpacing: $avatarSpacing)';
  }

  /// Compares two chat values for structural equality.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ChatGroupTheme &&
        other.spacing == spacing &&
        other.avatarAlignment == avatarAlignment &&
        other.avatarSpacing == avatarSpacing;
  }

  @override
  int get hashCode {
    return Object.hash(spacing, avatarAlignment, avatarSpacing);
  }
}
