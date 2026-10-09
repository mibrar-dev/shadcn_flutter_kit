// `BasicLayout`: the unstyled variant of `Basic`.
//
// Ported from `shared/primitives/_impl/core/basic_layout.dart`.

import 'package:flutter/widgets.dart';

import '../foundation/style_value.dart';
import '../theme/theme.dart';
import 'layout.dart';

/// Same structure as [Basic] but without applying default text styles.
class BasicLayout extends StatelessWidget {
  /// Leading widget (icon/avatar).
  final Widget? leading;

  /// Primary title.
  final Widget? title;

  /// Secondary subtitle below the title.
  final Widget? subtitle;

  /// Content below title/subtitle.
  final Widget? content;

  /// Trailing widget (icon/action).
  final Widget? trailing;

  /// Alignment for [leading].
  final AlignmentGeometry? leadingAlignment;

  /// Alignment for [trailing].
  final AlignmentGeometry? trailingAlignment;

  /// Alignment for [title].
  final AlignmentGeometry? titleAlignment;

  /// Alignment for [subtitle].
  final AlignmentGeometry? subtitleAlignment;

  /// Alignment for [content].
  final AlignmentGeometry? contentAlignment;

  /// Spacing between content elements.
  final double? contentSpacing;

  /// Spacing between title and subtitle.
  final double? titleSpacing;

  /// Optional constraints around the row.
  final BoxConstraints? constraints;

  /// Creates a [BasicLayout].
  const BasicLayout({
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
    this.contentSpacing,
    this.titleSpacing,
    this.constraints,
  });

  @override
  Widget build(BuildContext context) {
    final scaling = ShadcnTheme.of(context).scaling;
    final componentTheme = resolveComponentStyle<BasicTheme, BasicTheme>(
      context,
      select: (t) => t,
      defaults: const BasicTheme(),
    );
    final contentSpacing = styleValue(
      widgetValue: this.contentSpacing,
      themeValue: componentTheme.contentSpacing,
      defaultValue: 16 * scaling,
    );
    final titleSpacing = styleValue(
      widgetValue: this.titleSpacing,
      themeValue: componentTheme.titleSpacing,
      defaultValue: 4 * scaling,
    );
    final leadingAlignment = styleValue(
      widgetValue: this.leadingAlignment,
      themeValue: componentTheme.leadingAlignment,
      defaultValue: Alignment.topCenter,
    );
    final trailingAlignment = styleValue(
      widgetValue: this.trailingAlignment,
      themeValue: componentTheme.trailingAlignment,
      defaultValue: Alignment.topCenter,
    );
    final titleAlignment = styleValue(
      widgetValue: this.titleAlignment,
      themeValue: componentTheme.titleAlignment,
      defaultValue: Alignment.topLeft,
    );
    final subtitleAlignment = styleValue(
      widgetValue: this.subtitleAlignment,
      themeValue: componentTheme.subtitleAlignment,
      defaultValue: Alignment.topLeft,
    );
    final contentAlignment = styleValue(
      widgetValue: this.contentAlignment,
      themeValue: componentTheme.contentAlignment,
      defaultValue: Alignment.topLeft,
    );
    Widget child = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (leading != null)
          Align(alignment: leadingAlignment, child: leading!),
        if (leading != null &&
            (title != null || content != null || subtitle != null))
          SizedBox(width: contentSpacing),
        if (title != null || content != null || subtitle != null)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (title != null)
                  Align(alignment: titleAlignment, child: title!),
                if (title != null && subtitle != null)
                  SizedBox(height: 2 * scaling),
                if (subtitle != null)
                  Align(alignment: subtitleAlignment, child: subtitle!),
                if ((title != null || subtitle != null) && content != null)
                  SizedBox(height: titleSpacing),
                if (content != null)
                  Align(alignment: contentAlignment, child: content!),
              ],
            ),
          ),
        if (trailing != null &&
            (title != null ||
                content != null ||
                leading != null ||
                subtitle != null))
          SizedBox(width: contentSpacing),
        if (trailing != null)
          Align(alignment: trailingAlignment, child: trailing!),
      ],
    );
    if (constraints != null) {
      child = ConstrainedBox(constraints: constraints!, child: child);
    }
    return child;
  }
}
