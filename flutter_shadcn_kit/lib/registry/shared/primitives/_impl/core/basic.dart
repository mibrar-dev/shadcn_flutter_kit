// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../basic.dart';

/// Basic defines a reusable type for this registry module.
class Basic extends StatelessWidget {
  /// Leading widget, typically an icon or avatar.
  final Widget? leading;

  /// Primary title widget.
  final Widget? title;

  /// Secondary subtitle widget, displayed below title.
  final Widget? subtitle;

  /// Main content widget, displayed below title/subtitle.
  final Widget? content;

  /// Trailing widget, typically an icon or action button.
  final Widget? trailing;

  /// Alignment for the [leading] widget.
  final AlignmentGeometry? leadingAlignment;

  /// Alignment for the [trailing] widget.
  final AlignmentGeometry? trailingAlignment;

  /// Alignment for the [title] widget.
  final AlignmentGeometry? titleAlignment;

  /// Alignment for the [subtitle] widget.
  final AlignmentGeometry? subtitleAlignment;

  /// Alignment for the [content] widget.
  final AlignmentGeometry? contentAlignment;

  /// Spacing between content elements (default: 16).
  final double? contentSpacing;

  /// Spacing between title and subtitle (default: 4).
  final double? titleSpacing;

  /// Main axis alignment for the overall layout.
  final MainAxisAlignment? mainAxisAlignment;

  /// Padding around the entire widget.
  final EdgeInsetsGeometry? padding;

  /// Creates a [Basic] layout widget.
  const Basic({
    super.key,
    this.leading,
    this.title,
    this.subtitle,
    this.content,
    this.trailing,
    this.leadingAlignment,
    this.trailingAlignment,
    this.titleAlignment,
    this.subtitleAlignment,
    this.contentAlignment,
    this.contentSpacing, // 16
    this.titleSpacing, //4
    this.mainAxisAlignment,
    this.padding,
  });

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    /// Stores `scaling` state/configuration for this implementation.
    final scaling = theme.scaling;
    final compTheme = ComponentTheme.maybeOf<BasicTheme>(context);
    final padding = styleValue(
      widgetValue: this.padding,
      themeValue: compTheme?.padding,
      defaultValue: EdgeInsets.zero,
    );
    final contentSpacing = styleValue(
      widgetValue: this.contentSpacing,
      themeValue: compTheme?.contentSpacing,
      defaultValue: 16 * scaling,
    );
    final titleSpacing = styleValue(
      widgetValue: this.titleSpacing,
      themeValue: compTheme?.titleSpacing,
      defaultValue: 4 * scaling,
    );
    final leadingAlignment = styleValue(
      widgetValue: this.leadingAlignment,
      themeValue: compTheme?.leadingAlignment,
      defaultValue: Alignment.topCenter,
    );
    final trailingAlignment = styleValue(
      widgetValue: this.trailingAlignment,
      themeValue: compTheme?.trailingAlignment,
      defaultValue: Alignment.topCenter,
    );
    final titleAlignment = styleValue(
      widgetValue: this.titleAlignment,
      themeValue: compTheme?.titleAlignment,
      defaultValue: Alignment.topLeft,
    );
    final subtitleAlignment = styleValue(
      widgetValue: this.subtitleAlignment,
      themeValue: compTheme?.subtitleAlignment,
      defaultValue: Alignment.topLeft,
    );
    final contentAlignment = styleValue(
      widgetValue: this.contentAlignment,
      themeValue: compTheme?.contentAlignment,
      defaultValue: Alignment.topLeft,
    );
    final mainAxisAlignment = styleValue(
      widgetValue: this.mainAxisAlignment,
      themeValue: compTheme?.mainAxisAlignment,
      defaultValue: MainAxisAlignment.center,
    );
    return Padding(
      padding: padding,
      child: IntrinsicWidth(
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: mainAxisAlignment,
            children: [
              if (leading != null)
                /// Creates a `Align` instance.
                Align(alignment: leadingAlignment, child: leading!),
              if (leading != null &&
                  (title != null || content != null || subtitle != null))
                /// Creates a `SizedBox` instance.
                SizedBox(width: contentSpacing),
              if (title != null || content != null || subtitle != null)
                /// Creates a `Expanded` instance.
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: mainAxisAlignment,
                    children: [
                      if (title != null)
                        /// Creates a `Align` instance.
                        Align(
                          alignment: titleAlignment,
                          child: title!,
                        ).small().medium(),
                      if (title != null && subtitle != null)
                        /// Creates a `SizedBox` instance.
                        SizedBox(height: 2 * scaling),
                      if (subtitle != null)
                        /// Creates a `Align` instance.
                        Align(
                          alignment: subtitleAlignment,
                          child: subtitle!,
                        ).xSmall().muted(),
                      if ((title != null || subtitle != null) &&
                          content != null)
                        /// Creates a `SizedBox` instance.
                        SizedBox(height: titleSpacing),
                      if (content != null)
                        /// Creates a `Align` instance.
                        Align(
                          alignment: contentAlignment,
                          child: content!,
                        ).small(),
                    ],
                  ),
                ),
              if (trailing != null &&
                  (title != null ||
                      content != null ||
                      leading != null ||
                      subtitle != null))
                /// Creates a `SizedBox` instance.
                SizedBox(width: contentSpacing),
              // if (trailing != null) trailing!,
              if (trailing != null)
                /// Creates a `Align` instance.
                Align(alignment: trailingAlignment, child: trailing!),
            ],
          ),
        ),
      ),
    );
  }
}

/// Same as [Basic], but without forcing text styles.
///
/// Provides the same layout structure as [Basic] but doesn't apply default
/// text styling to title and subtitle elements. Use this when you need full
/// control over text appearance.
///
/// Example:
/// ```dart
/// BasicLayout(
///   leading: Icon(Icons.star),
///   title: Text('Custom styled title', style: myStyle),
///   subtitle: Text('Custom styled subtitle', style: myStyle),
/// )
/// ```
