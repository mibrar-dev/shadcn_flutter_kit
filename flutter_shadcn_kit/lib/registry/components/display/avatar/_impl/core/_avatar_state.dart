// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../avatar.dart';

/// _AvatarState holds mutable state for the avatar implementation.
class _AvatarState extends State<Avatar> {
  /// Implements `_build` behavior for avatar.
  Widget _build(BuildContext context) {
    final theme = Theme.of(context);
    final compTheme = ComponentTheme.maybeOf<AvatarTheme>(context);
    final size = styleValue(
      widgetValue: widget.size,
      themeValue: compTheme?.size,
      defaultValue: theme.scaling * 40,
    );
    final borderRadius = styleValue(
      widgetValue: widget.borderRadius,
      themeValue: compTheme?.borderRadius,
      defaultValue: theme.radius * size,
    );
    if (widget.provider != null) {
      return SizedBox(
        width: size,
        height: size,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: Image(
            image: widget.provider!,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return _buildInitials(context, borderRadius);
            },
          ),
        ),
      );
    }
    return SizedBox(
      width: size,
      height: size,
      child: _buildInitials(context, borderRadius),
    );
  }

  /// Implements `_buildInitials` behavior for avatar.
  Widget _buildInitials(BuildContext context, double borderRadius) {
    final theme = Theme.of(context);
    final compTheme = ComponentTheme.maybeOf<AvatarTheme>(context);
    return Container(
      decoration: BoxDecoration(
        color: styleValue(
          widgetValue: widget.backgroundColor,
          themeValue: compTheme?.backgroundColor,
          defaultValue: theme.colorScheme.muted,
        ),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: FittedBox(
        fit: BoxFit.fill,
        child: Padding(
          padding: EdgeInsets.all(
            theme.density.baseContentPadding * theme.scaling * padXs,
          ),
          child: DefaultTextStyle.merge(
            style: styleValue(
              themeValue: compTheme?.textStyle,
              defaultValue: TextStyle(
                color: theme.colorScheme.foreground,
                fontWeight: FontWeight.bold,
              ),
            ),
            child: Center(child: Text(widget.initials)),
          ),
        ),
      ),
    );
  }

  /// Builds the widget tree for avatar.
  @override
  Widget build(BuildContext context) {
    if (widget.badge == null) {
      return _build(context);
    }
    final theme = Theme.of(context);
    final compTheme = ComponentTheme.maybeOf<AvatarTheme>(context);
    final size = styleValue(
      widgetValue: widget.size,
      themeValue: compTheme?.size,
      defaultValue: theme.scaling * 40,
    );
    final borderRadius = styleValue(
      widgetValue: widget.borderRadius,
      themeValue: compTheme?.borderRadius,
      defaultValue: theme.radius * size,
    );

    final badgeSize = widget.badge!.size ?? theme.scaling * 12;

    var offset = size / 2 - badgeSize / 2;
    offset = offset / size;
    final alignment = styleValue(
      widgetValue: widget.badgeAlignment,
      themeValue: compTheme?.badgeAlignment,
      defaultValue: AlignmentDirectional(offset, offset),
    );
    final gap = styleValue(
      widgetValue: widget.badgeGap,
      themeValue: compTheme?.badgeGap,
      defaultValue: theme.density.baseGap * theme.scaling * gapXs,
    );
    return AvatarGroup(
      alignment: alignment,
      gap: gap,
      children: [
        _AvatarWidget(
          size: widget.badge!.size ?? theme.scaling * 12,
          borderRadius: widget.badge!.borderRadius,
          child: widget.badge!,
        ),

        _AvatarWidget(
          size: size,
          borderRadius: borderRadius,
          child: _build(context),
        ),
      ],
    );
  }
}
