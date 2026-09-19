// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/widgets.dart';

import '../../../../../shared/theme/theme.dart';
import '../../../../../shared/utils/style_value.dart';
import '../themes/base/icon_container_theme.dart';

/// A container widget for displaying an icon with customizable padding, background, and border radius.
///
/// Use [IconContainer] to wrap an icon and apply theme or custom styling.
///
/// Example:
/// ```dart
/// IconContainer(
///   icon: Icon(LucideIcons.star),
///   backgroundColor: Colors.yellow,
///   borderRadius: BorderRadius.circular(8),
/// )
/// ```
class IconContainer extends StatelessWidget implements Styleable<IconContainerTheme> {
  /// The icon widget to display.
  final Widget icon;

  /// Padding inside the container.
  @Deprecated('Use theme: IconContainerTheme(padding: ...) instead.')
  final EdgeInsetsGeometry? padding;

  /// Border radius for the container.
  @Deprecated('Use theme: IconContainerTheme(borderRadius: ...) instead.')
  final BorderRadius? borderRadius;

  /// Background color for the container.
  @Deprecated('Use theme: IconContainerTheme(backgroundColor: ...) instead.')
  final Color? backgroundColor;

  /// Color for the icon.
  @Deprecated('Use theme: IconContainerTheme(iconColor: ...) instead.')
  final Color? iconColor;

  /// Theme override for this icon container.
  ///
  /// Styling for this widget alone, overriding the ancestor theme.
  /// Resolved via `ComponentTheme.maybeOf<IconContainerTheme>` when null.
  @override
  final IconContainerTheme? theme;

  /// Creates an [IconContainer].
  ///
  /// Parameters:
  /// - [icon] (`Widget`, required): Icon widget to display.
  /// - [padding] (`EdgeInsetsGeometry?`, optional): Container padding.
  /// - [borderRadius] (`BorderRadius?`, optional): Container border radius.
  /// - [backgroundColor] (`Color?`, optional): Container background color.
  /// - [iconColor] (`Color?`, optional): Icon color.
  const IconContainer({
    super.key,
    required this.icon,
    this.padding,
    this.borderRadius,
    this.backgroundColor,
    this.iconColor,
    this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final compTheme =
        this.theme ?? ComponentTheme.maybeOf<IconContainerTheme>(context);
    return Container(
      padding: styleValue(
        defaultValue: EdgeInsetsDensity.all(
          padXs,
        ).resolveDensity(theme.density.baseContainerPadding),
        widgetValue: padding,
        themeValue: compTheme?.padding,
      ),
      decoration: BoxDecoration(
        color: styleValue(
          defaultValue: theme.colorScheme.primary,
          widgetValue: backgroundColor,
          themeValue: compTheme?.backgroundColor,
        ),
        borderRadius: styleValue(
          defaultValue: theme.borderRadiusMd,
          widgetValue: borderRadius,
          themeValue: compTheme?.borderRadius,
        ),
      ),
      child: IconTheme(
        data: IconThemeData(
          color: styleValue(
            defaultValue: theme.colorScheme.primaryForeground,
            widgetValue: iconColor,
            themeValue: compTheme?.iconColor,
          ),
        ),
        child: icon,
      ),
    );
  }
}
