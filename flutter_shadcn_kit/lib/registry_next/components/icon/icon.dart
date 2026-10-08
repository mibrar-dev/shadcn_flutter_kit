// The `icon` component: theme-driven icon modifiers and an icon container.
//
// Ported from `components/display/icon/**` (old tree). Clean break, keeping
// only members with real call sites: the extension keeps `iconSmall`,
// `iconXSmall`, `iconX3Small`, `iconMedium`, `iconLarge` and
// `iconMutedForeground`; the unused `iconX4Small`/`iconX2Small`/large-size/
// colour members, the `WrappedIcon` wrapper (0 external users) and the
// deprecated `IconContainer` constructor arguments are dropped.

import 'package:flutter/widgets.dart';

import '../../theme/color_tokens.dart';
import '../../theme/density.dart';
import '../../theme/theme.dart';
import 'icon_style.dart';

export 'icon_style.dart';

/// Icon modifiers that apply the ambient icon theme slots to any [Widget].
///
/// ```dart
/// const Icon(LucideIcons.chevronRight).iconSmall();
/// const Icon(LucideIcons.x).iconSmall().iconMutedForeground();
/// ```
extension IconExtension on Widget {
  /// Applies the `x3Small` (8px) icon slot.
  Widget iconX3Small() {
    return _IconThemeModifier(
      resolve: (theme) => theme.iconTheme.x3Small,
      child: this,
    );
  }

  /// Applies the `xSmall` (12px) icon slot.
  Widget iconXSmall() {
    return _IconThemeModifier(
      resolve: (theme) => theme.iconTheme.xSmall,
      child: this,
    );
  }

  /// Applies the `small` (16px) icon slot.
  Widget iconSmall() {
    return _IconThemeModifier(
      resolve: (theme) => theme.iconTheme.small,
      child: this,
    );
  }

  /// Applies the `medium` (20px) icon slot.
  Widget iconMedium() {
    return _IconThemeModifier(
      resolve: (theme) => theme.iconTheme.medium,
      child: this,
    );
  }

  /// Applies the `large` (24px) icon slot.
  Widget iconLarge() {
    return _IconThemeModifier(
      resolve: (theme) => theme.iconTheme.large,
      child: this,
    );
  }

  /// Applies the `mutedForeground` token as the icon colour.
  ///
  /// The resolved colour wins over an ambient icon colour (the old helper
  /// merged the other way around, so an ancestor `IconTheme` colour silently
  /// swallowed the muted colour).
  Widget iconMutedForeground() {
    return _IconThemeModifier(
      resolve: (theme) => IconThemeData(color: theme.colors.mutedForeground),
      child: this,
    );
  }
}

/// Applies a theme-resolved [IconThemeData] on top of the ambient icon theme.
class _IconThemeModifier extends StatelessWidget {
  const _IconThemeModifier({required this.resolve, required this.child});

  final IconThemeData Function(ShadcnThemeData theme) resolve;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return IconTheme.merge(
      data: resolve(ShadcnTheme.of(context)),
      child: child,
    );
  }
}

/// A padded, filled square around an icon.
///
/// ```dart
/// const IconContainer(icon: Icon(LucideIcons.star));
/// ```
class IconContainer extends StatelessWidget {
  /// Creates an icon container.
  const IconContainer({
    super.key,
    required this.icon,
    this.backgroundColor,
    this.iconColor,
    this.padding,
    this.borderRadius,
    this.theme,
  });

  /// The icon to display.
  final Widget icon;

  /// Container fill override.
  final Color? backgroundColor;

  /// Icon colour override.
  final Color? iconColor;

  /// Inner padding override.
  final EdgeInsetsGeometry? padding;

  /// Corner radius override.
  final BorderRadiusGeometry? borderRadius;

  /// Widget-leg theme override, merged on top of the other legs.
  final IconContainerTheme? theme;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData shadcnTheme = ShadcnTheme.of(context);
    final ShadcnColors colors = shadcnTheme.colors;
    final resolved =
        resolveComponentStyle<IconContainerTheme, IconContainerTheme>(
          context,
          widget: theme,
          select: (t) => t,
          defaults: iconContainerDefaults,
        );
    final EdgeInsetsGeometry effectivePadding =
        padding ?? resolved.padding ?? const EdgeInsetsDensity.all(padXs);
    final Color background =
        backgroundColor ??
        resolved.backgroundColor?.resolve(colors) ??
        colors.primary;
    final Color foreground =
        iconColor ??
        resolved.iconColor?.resolve(colors) ??
        colors.primaryForeground;

    return Container(
      padding: resolveEdgeInsets(
        effectivePadding,
        shadcnTheme.density.baseContainerPadding * shadcnTheme.scaling,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius:
            borderRadius ?? resolved.borderRadius ?? shadcnTheme.borderRadiusMd,
      ),
      child: IconTheme.merge(
        data: IconThemeData(color: foreground),
        child: icon,
      ),
    );
  }
}
