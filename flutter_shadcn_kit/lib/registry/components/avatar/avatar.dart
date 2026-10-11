// The `avatar` component: an image/initials tile, a small status badge and a
// group that overlaps several tiles with a background-coloured ring.
//
// Ported from `components/display/avatar/**` (old tree). Clean break: the
// `Avatar.network` constructor and the `AvatarGroup.toLeft/toRight/...`
// factories are gone; pass an [ImageProvider] and an alignment instead.
// `AvatarWidget`, `WrappedIcon`-style helper classes and the notch clipper
// have no replacement: the group draws a token ring instead.

import 'package:flutter/widgets.dart';

import '../../primitives/text/text.dart';
import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';
import 'avatar_style.dart';

export 'avatar_style.dart';

/// An image or initials tile for a person or entity.
///
/// ```dart
/// const Avatar(initials: 'IB');
/// Avatar(initials: 'IB', image: NetworkImage(url), badge: AvatarBadge());
/// ```
class Avatar extends StatelessWidget {
  /// Creates an avatar.
  ///
  /// [initials] is the fallback shown while [image] is absent or cannot be
  /// decoded. [badge] is usually an [AvatarBadge].
  const Avatar({
    super.key,
    required this.initials,
    this.image,
    this.size,
    this.borderRadius,
    this.backgroundColor,
    this.foregroundColor,
    this.textStyle,
    this.fit = BoxFit.cover,
    this.badge,
    this.badgeAlignment,
    this.badgeGap,
    this.theme,
  });

  /// Fallback label; also the accessible label of the tile.
  final String initials;

  /// Optional photo. When it fails to decode, [initials] are shown.
  final ImageProvider? image;

  /// Diameter override; null uses [AvatarTheme.size] then `32 * scaling`
  /// (shadcn `size-8`).
  final double? size;

  /// Corner radius override; null uses [AvatarTheme.borderRadius] then a
  /// full circle.
  final BorderRadiusGeometry? borderRadius;

  /// Initials fill override.
  final Color? backgroundColor;

  /// Initials colour override.
  final Color? foregroundColor;

  /// Initials style override.
  final TextStyle? textStyle;

  /// How the image fills the tile.
  final BoxFit fit;

  /// Optional badge overlaid on the tile.
  final Widget? badge;

  /// Where [badge] sits; null uses [AvatarTheme.badgeAlignment] then the
  /// bottom end corner.
  final AlignmentGeometry? badgeAlignment;

  /// Inset of [badge] from the tile edge.
  final double? badgeGap;

  /// Widget-leg theme override, merged on top of the other legs.
  final AvatarTheme? theme;

  /// Two-letter fallback for [name] (`'Ibrar Ahmed'` -> `'IA'`).
  ///
  /// Returns the first two characters for a single word, or the first
  /// character of the first two words, uppercased. Empty input returns `''`.
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

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData shadcnTheme = ShadcnTheme.of(context);
    final ShadcnColors colors = shadcnTheme.colors;
    final resolved = resolveComponentStyle<AvatarTheme, AvatarTheme>(
      context,
      widget: theme,
      select: (t) => t,
      defaults: avatarDefaults,
    );
    final double effectiveSize =
        size ?? resolved.size ?? 32 * shadcnTheme.scaling;
    final BorderRadiusGeometry radius =
        borderRadius ??
        resolved.borderRadius ??
        BorderRadius.circular(effectiveSize / 2);
    final Color background =
        backgroundColor ??
        resolved.backgroundColor?.resolve(colors) ??
        colors.muted;
    final Color foreground =
        foregroundColor ??
        resolved.foregroundColor?.resolve(colors) ??
        colors.foreground;
    final TextStyle effectiveTextStyle =
        (resolved.textStyle ?? const TextStyle())
            .merge(textStyle)
            .copyWith(color: foreground);

    final Widget tile = image == null
        ? _initialsTile(
            theme: shadcnTheme,
            background: background,
            style: effectiveTextStyle,
          )
        : Image(
            image: image!,
            fit: fit,
            errorBuilder: (context, error, stackTrace) => _initialsTile(
              theme: shadcnTheme,
              background: background,
              style: effectiveTextStyle,
            ),
          );

    final AlignmentGeometry alignment =
        badgeAlignment ??
        resolved.badgeAlignment ??
        AlignmentDirectional.bottomEnd;
    final double gap = badgeGap ?? resolved.badgeGap ?? 0;

    return Semantics(
      label: initials,
      image: true,
      child: SizedBox(
        width: effectiveSize,
        height: effectiveSize,
        child: Stack(
          clipBehavior: Clip.none,
          fit: StackFit.expand,
          children: <Widget>[
            ClipRRect(borderRadius: radius, child: tile),
            if (badge != null)
              Align(
                alignment: alignment,
                child: Padding(padding: EdgeInsets.all(gap), child: badge),
              ),
          ],
        ),
      ),
    );
  }

  Widget _initialsTile({
    required ShadcnThemeData theme,
    required Color background,
    required TextStyle style,
  }) {
    return ColoredBox(
      color: background,
      child: Center(
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Padding(
            padding: EdgeInsets.all(theme.spacing.sm),
            child: WrappedText(
              style: (context, theme) => style,
              child: Text(initials, textAlign: TextAlign.center),
            ),
          ),
        ),
      ),
    );
  }
}

/// A small circular badge drawn on an [Avatar] corner.
///
/// ```dart
/// const Avatar(
///   initials: 'IB',
///   badge: AvatarBadge(child: Icon(LucideIcons.check)),
/// );
/// ```
class AvatarBadge extends StatelessWidget {
  /// Creates a badge.
  const AvatarBadge({
    super.key,
    this.child,
    this.size,
    this.borderRadius,
    this.color,
    this.foregroundColor,
    this.theme,
  });

  /// Badge content, usually an icon or a short text.
  final Widget? child;

  /// Diameter override; null uses [AvatarTheme.badgeSize] then
  /// `10 * scaling` (shadcn `size-2.5` on the default avatar).
  final double? size;

  /// Corner radius override; null is a full circle.
  final BorderRadiusGeometry? borderRadius;

  /// Fill override; null uses [AvatarTheme.badgeColor] then the `primary`
  /// token.
  final Color? color;

  /// Child colour override (text and icons).
  final Color? foregroundColor;

  /// Widget-leg theme override, merged on top of the other legs.
  final AvatarTheme? theme;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData shadcnTheme = ShadcnTheme.of(context);
    final ShadcnColors colors = shadcnTheme.colors;
    final resolved = resolveComponentStyle<AvatarTheme, AvatarTheme>(
      context,
      widget: theme,
      select: (t) => t,
      defaults: avatarDefaults,
    );
    final double badgeSize =
        size ?? resolved.badgeSize ?? 10 * shadcnTheme.scaling;
    final BorderRadiusGeometry radius =
        borderRadius ??
        resolved.badgeBorderRadius ??
        BorderRadius.circular(badgeSize / 2);
    final Color background =
        color ?? resolved.badgeColor?.resolve(colors) ?? colors.primary;
    final Color foreground =
        foregroundColor ??
        resolved.badgeForeground?.resolve(colors) ??
        colors.primaryForeground;

    return Container(
      width: badgeSize,
      height: badgeSize,
      decoration: BoxDecoration(color: background, borderRadius: radius),
      child: Center(
        child: IconTheme.merge(
          data: IconThemeData(color: foreground),
          child: DefaultTextStyle.merge(
            style: TextStyle(color: foreground),
            child: child ?? const SizedBox.shrink(),
          ),
        ),
      ),
    );
  }
}

/// Overlaps several [Avatar]s with a background-coloured ring between them.
///
/// ```dart
/// const AvatarGroup(
///   children: <Widget>[Avatar(initials: 'IB'), Avatar(initials: 'AC')],
/// );
/// ```
class AvatarGroup extends StatelessWidget {
  /// Creates an avatar group.
  const AvatarGroup({
    super.key,
    required this.children,
    this.size,
    this.overlap,
    this.ringWidth = 2,
    this.clipBehavior = Clip.none,
    this.borderRadius,
  });

  /// Tiles to overlap, first in front; usually [Avatar]s.
  final List<Widget> children;

  /// Tile diameter; null resolves `32 * scaling` (shadcn `size-8`).
  /// Children are laid out at this size; an inner [Avatar.size] has no
  /// effect.
  final double? size;

  /// How far each tile overlaps its predecessor; null resolves
  /// `size * 0.3`.
  final double? overlap;

  /// Width of the background ring around each tile.
  final double ringWidth;

  /// Clip behavior of the group's stack.
  final Clip clipBehavior;

  /// Shape of the background ring; null is a full circle, matching the
  /// default circular tile. Pass the tile radius when grouping
  /// rounded-square tiles so the ring does not peek out.
  final BorderRadiusGeometry? borderRadius;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    if (children.isEmpty) {
      return const SizedBox.shrink();
    }
    final double tileSize = size ?? 32 * theme.scaling;
    final double effectiveOverlap = (overlap ?? tileSize * 0.3).clamp(
      0.0,
      tileSize + ringWidth * 2,
    );
    final double cell = tileSize + ringWidth * 2;
    final double step = cell - effectiveOverlap;
    final double width = cell + step * (children.length - 1);
    final TextDirection direction = Directionality.of(context);
    final bool rtl = direction == TextDirection.rtl;
    final BorderRadiusGeometry ringShape =
        borderRadius ?? BorderRadius.circular(cell / 2);

    return SizedBox(
      width: width,
      height: cell,
      child: Stack(
        clipBehavior: clipBehavior,
        children: <Widget>[
          for (var i = 0; i < children.length; i++)
            Positioned(
              left: rtl ? null : i * step,
              right: rtl ? i * step : null,
              top: 0,
              width: cell,
              height: cell,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: theme.colors.background,
                  borderRadius: ringShape,
                ),
                child: Padding(
                  padding: EdgeInsets.all(ringWidth),
                  child: SizedBox(
                    width: tileSize,
                    height: tileSize,
                    child: children[i],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
