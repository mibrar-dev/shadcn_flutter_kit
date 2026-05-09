// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../avatar.dart';

/// Core class used by the avatar component.
class Avatar extends StatefulWidget implements AvatarWidget {
  /// Creates `Avatar` for configuring or rendering avatar.
  const Avatar({
    super.key,
    required this.initials,
    this.backgroundColor,
    this.size,
    this.borderRadius,
    this.badge,
    this.badgeAlignment,
    this.badgeGap,
    this.provider,
  });

  /// Creates `Avatar.network` for configuring or rendering avatar.
  Avatar.network({
    super.key,
    required this.initials,
    this.backgroundColor,
    this.size,
    this.borderRadius,
    this.badge,
    this.badgeAlignment,
    this.badgeGap,
    int? cacheWidth,
    int? cacheHeight,
    required String photoUrl,
  }) : provider = ResizeImage.resizeIfNeeded(
         cacheWidth,
         cacheHeight,

         NetworkImage(photoUrl),
       );

  /// Implements `getInitials` behavior for avatar.
  static String getInitials(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      return '';
    }
    final parts = trimmed.split(RegExp(r'\s+'));
    if (parts.length == 1) {
      final chars = parts.first.characters.take(2).toList();
      return chars.join().toUpperCase();
    }

    final first = parts.first.characters.first;

    final second = parts[1].characters.first;
    return '$first$second'.toUpperCase();
  }

  /// Input parameter used by `Avatar` during rendering and behavior handling.
  final String initials;

  /// Color value used by avatar painting or state styling.
  final Color? backgroundColor;

  /// Layout/size setting that affects avatar rendering.
  @override
  final double? size;

  /// Layout/size setting that affects avatar rendering.
  @override
  final double? borderRadius;

  /// Input parameter used by `Avatar` during rendering and behavior handling.
  final AvatarBadge? badge;

  /// Controls how avatar content is aligned within available space.
  final AlignmentGeometry? badgeAlignment;

  /// Layout/size setting that affects avatar rendering.
  final double? badgeGap;

  /// Input parameter used by `Avatar` during rendering and behavior handling.
  final ImageProvider? provider;

  /// Creates the State object used by this avatar widget.
  @override
  State<Avatar> createState() => _AvatarState();
}
