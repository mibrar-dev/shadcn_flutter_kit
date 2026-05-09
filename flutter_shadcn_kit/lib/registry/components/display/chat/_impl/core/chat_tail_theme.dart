// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../chat.dart';

/// Defines the theme for the tail of a [ChatBubble].
class ChatTailTheme extends ComponentThemeData {
  /// The position of the tail relative to the bubble.
  final AxisDirectional? position;

  /// The size of the tail.
  final Size? size;

  /// The border radius of the bubble when a tail is present.
  final BorderRadiusGeometry? borderRadius;

  /// The radius of the tail's curve.
  final double? tailRadius;

  /// The behavior determining when to show the tail.
  final TailBehavior? tailBehavior;

  /// Creates a [ChatTailTheme].
  ///
  /// Parameters:
  /// - [position] (`AxisDirectional?`, optional): The position of the tail relative to the bubble.
  /// - [size] (`Size?`, optional): The size of the tail.
  /// - [borderRadius] (`BorderRadiusGeometry?`, optional): The border radius of the bubble when a tail is present.
  /// - [tailRadius] (`double?`, optional): The radius of the tail's curve.
  /// - [tailBehavior] (`TailBehavior?`, optional): The behavior determining when to show the tail.
  const ChatTailTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.position,
    this.size,
    this.borderRadius,
    this.tailRadius,
    this.tailBehavior,
  });

  /// Returns a debug string for this chat value.
  @override
  String toString() {
    return 'ChatTailTheme(position: $position, size: $size, borderRadius: $borderRadius, tailRadius: $tailRadius, tailBehavior: $tailBehavior)';
  }

  /// Creates a copy of this theme with the given fields replaced with the new values.
  ///
  /// Parameters:
  /// - [position] (`ValueGetter<AxisDirectional>?`, optional): New position value.
  /// - [size] (`ValueGetter<Size>?`, optional): New size value.
  /// - [borderRadius] (`ValueGetter<BorderRadiusGeometry>?`, optional): New border radius value.
  /// - [tailRadius] (`ValueGetter<double>?`, optional): New tail radius value.
  /// - [tailBehavior] (`ValueGetter<TailBehavior>?`, optional): New tail behavior value.
  ///
  /// Returns:
  /// A new [ChatTailTheme] with the specified values updated.
  ChatTailTheme copyWith({
    ValueGetter<AxisDirectional>? position,
    ValueGetter<Size>? size,
    ValueGetter<BorderRadiusGeometry>? borderRadius,
    ValueGetter<double>? tailRadius,
    ValueGetter<TailBehavior>? tailBehavior,
  }) {
    return ChatTailTheme(
      position: position?.call() ?? this.position,
      size: size?.call() ?? this.size,
      borderRadius: borderRadius?.call() ?? this.borderRadius,
      tailRadius: tailRadius?.call() ?? this.tailRadius,
      tailBehavior: tailBehavior?.call() ?? this.tailBehavior,
    );
  }

  /// Compares two chat values for structural equality.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ChatTailTheme &&
        other.position == position &&
        other.size == size &&
        other.borderRadius == borderRadius &&
        other.tailRadius == tailRadius &&
        other.tailBehavior == tailBehavior;
  }

  @override
  int get hashCode {
    return Object.hash(position, size, borderRadius, tailRadius, tailBehavior);
  }
}
