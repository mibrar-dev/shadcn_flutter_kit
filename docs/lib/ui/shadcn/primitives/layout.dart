// Layout helpers: `Basic`/`BasicLayout` (leading / title / subtitle / content
// / trailing rows) and `Label` (leading + child + trailing).
//
// Ported from `shared/primitives/basic.dart` + `_impl/core/{basic,basic_layout,
// label}.dart` and `_impl/themes/basic_theme.dart`. The `layout/basic`
// component copy imports this primitive.

import 'package:flutter/widgets.dart';

import '../foundation/style_value.dart';
import '../theme/color_tokens.dart';
import '../theme/theme.dart';
import 'text/text_extension.dart';

/// Alignment, spacing and padding defaults for [Basic]/[BasicLayout].
class BasicTheme extends ComponentThemeData implements Mergeable<BasicTheme> {
  /// Alignment for the leading widget.
  final AlignmentGeometry? leadingAlignment;

  /// Alignment for the trailing widget.
  final AlignmentGeometry? trailingAlignment;

  /// Alignment for the title widget.
  final AlignmentGeometry? titleAlignment;

  /// Alignment for the subtitle widget.
  final AlignmentGeometry? subtitleAlignment;

  /// Alignment for the content widget.
  final AlignmentGeometry? contentAlignment;

  /// Spacing between content elements. Defaults to `16 * scaling`.
  final double? contentSpacing;

  /// Spacing between title and subtitle. Defaults to `4 * scaling`.
  final double? titleSpacing;

  /// Main axis alignment for the overall layout.
  final MainAxisAlignment? mainAxisAlignment;

  /// Padding around the whole widget.
  final EdgeInsetsGeometry? padding;

  /// Creates a [BasicTheme].
  const BasicTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.leadingAlignment,
    this.trailingAlignment,
    this.titleAlignment,
    this.subtitleAlignment,
    this.contentAlignment,
    this.contentSpacing,
    this.titleSpacing,
    this.mainAxisAlignment,
    this.padding,
  });

  /// Returns a copy with the given fields replaced.
  BasicTheme copyWith({
    ValueGetter<AlignmentGeometry?>? leadingAlignment,
    ValueGetter<AlignmentGeometry?>? trailingAlignment,
    ValueGetter<AlignmentGeometry?>? titleAlignment,
    ValueGetter<AlignmentGeometry?>? subtitleAlignment,
    ValueGetter<AlignmentGeometry?>? contentAlignment,
    ValueGetter<double?>? contentSpacing,
    ValueGetter<double?>? titleSpacing,
    ValueGetter<MainAxisAlignment?>? mainAxisAlignment,
    ValueGetter<EdgeInsetsGeometry?>? padding,
  }) {
    return BasicTheme(
      leadingAlignment: leadingAlignment == null
          ? this.leadingAlignment
          : leadingAlignment(),
      trailingAlignment: trailingAlignment == null
          ? this.trailingAlignment
          : trailingAlignment(),
      titleAlignment: titleAlignment == null
          ? this.titleAlignment
          : titleAlignment(),
      subtitleAlignment: subtitleAlignment == null
          ? this.subtitleAlignment
          : subtitleAlignment(),
      contentAlignment: contentAlignment == null
          ? this.contentAlignment
          : contentAlignment(),
      contentSpacing: contentSpacing == null
          ? this.contentSpacing
          : contentSpacing(),
      titleSpacing: titleSpacing == null ? this.titleSpacing : titleSpacing(),
      mainAxisAlignment: mainAxisAlignment == null
          ? this.mainAxisAlignment
          : mainAxisAlignment(),
      padding: padding == null ? this.padding : padding(),
    );
  }

  /// First-non-null-wins merge; the receiver (higher-priority leg) wins.
  @override
  BasicTheme merge(BasicTheme? fallback) {
    if (fallback == null) return this;
    return BasicTheme(
      themeDensity: themeDensity ?? fallback.themeDensity,
      themeSpacing: themeSpacing ?? fallback.themeSpacing,
      themeShadows: themeShadows ?? fallback.themeShadows,
      leadingAlignment: leadingAlignment ?? fallback.leadingAlignment,
      trailingAlignment: trailingAlignment ?? fallback.trailingAlignment,
      titleAlignment: titleAlignment ?? fallback.titleAlignment,
      subtitleAlignment: subtitleAlignment ?? fallback.subtitleAlignment,
      contentAlignment: contentAlignment ?? fallback.contentAlignment,
      contentSpacing: contentSpacing ?? fallback.contentSpacing,
      titleSpacing: titleSpacing ?? fallback.titleSpacing,
      mainAxisAlignment: mainAxisAlignment ?? fallback.mainAxisAlignment,
      padding: padding ?? fallback.padding,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is BasicTheme &&
        other.leadingAlignment == leadingAlignment &&
        other.trailingAlignment == trailingAlignment &&
        other.titleAlignment == titleAlignment &&
        other.subtitleAlignment == subtitleAlignment &&
        other.contentAlignment == contentAlignment &&
        other.contentSpacing == contentSpacing &&
        other.titleSpacing == titleSpacing &&
        other.mainAxisAlignment == mainAxisAlignment &&
        other.padding == padding;
  }

  @override
  int get hashCode => Object.hash(
    leadingAlignment,
    trailingAlignment,
    titleAlignment,
    subtitleAlignment,
    contentAlignment,
    contentSpacing,
    titleSpacing,
    mainAxisAlignment,
    padding,
  );
}

/// Leading / title / subtitle / content / trailing row with default text
/// styles applied to title and subtitle.
class Basic extends StatelessWidget {
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

  /// Main axis alignment for the overall layout.
  final MainAxisAlignment? mainAxisAlignment;

  /// Padding around the whole widget.
  final EdgeInsetsGeometry? padding;

  /// Creates a [Basic] layout.
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
    this.contentSpacing,
    this.titleSpacing,
    this.mainAxisAlignment,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final scaling = ShadcnTheme.of(context).scaling;
    final componentTheme = resolveComponentStyle<BasicTheme, BasicTheme>(
      context,
      select: (t) => t,
      defaults: const BasicTheme(),
    );
    final padding = styleValue(
      widgetValue: this.padding,
      themeValue: componentTheme.padding,
      defaultValue: EdgeInsets.zero,
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
    final mainAxisAlignment = styleValue(
      widgetValue: this.mainAxisAlignment,
      themeValue: componentTheme.mainAxisAlignment,
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
                Align(alignment: leadingAlignment, child: leading!),
              if (leading != null &&
                  (title != null || content != null || subtitle != null))
                SizedBox(width: contentSpacing),
              if (title != null || content != null || subtitle != null)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: mainAxisAlignment,
                    children: [
                      if (title != null)
                        Align(
                          alignment: titleAlignment,
                          child: title!,
                        ).small().medium(),
                      if (title != null && subtitle != null)
                        SizedBox(height: 2 * scaling),
                      if (subtitle != null)
                        Align(
                          alignment: subtitleAlignment,
                          child: subtitle!,
                        ).xSmall().muted(),
                      if ((title != null || subtitle != null) &&
                          content != null)
                        SizedBox(height: titleSpacing),
                      if (content != null)
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
                SizedBox(width: contentSpacing),
              if (trailing != null)
                Align(alignment: trailingAlignment, child: trailing!),
            ],
          ),
        ),
      ),
    );
  }
}
