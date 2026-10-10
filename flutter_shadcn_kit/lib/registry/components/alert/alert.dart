// The `alert` component: [Alert], a callout banner for status, warning and
// info messages.
//
// Ported from `layout/alert/**` (old tree). Clean break: the old
// `Alert.destructive` constructor is `Alert(variant: AlertVariant.destructive)`
// and the old `Styleable<AlertTheme>` hook is the `theme` widget-leg.
//
// Old bugs fixed, not ported:
//  * two `package:flutter/material.dart` imports (banned in the new tree);
//  * destructive text/icon colours were applied from outside the layout with
//    `DefaultTextStyle.merge`/`IconTheme.merge`, so a caller-supplied
//    `DefaultTextStyle` around one slot silently won — the slot styles are now
//    set on the title/content/leading widgets themselves;
//  * the theme never exposed the destructive foreground, so `Alert.destructive`
//    ignored any theme override; both variants are rows now.

import 'package:flutter/widgets.dart';

import '../../primitives/basic_layout.dart';
import '../../theme/color_tokens.dart';
import '../../theme/density.dart';
import '../../theme/theme.dart';
import 'alert_style.dart';

export 'alert_style.dart';

/// A bordered banner that highlights a message.
///
/// ```dart
/// Alert(
///   leading: const Icon(LucideIcons.info),
///   title: const Text('Heads up'),
///   content: const Text('You can add components from the registry.'),
/// )
/// ```
class Alert extends StatelessWidget {
  /// Creates an alert.
  const Alert({
    super.key,
    this.leading,
    this.title,
    this.content,
    this.trailing,
    this.variant = AlertVariant.base,
    this.theme,
  });

  /// Optional leading widget, usually a 16px `Icon`.
  final Widget? leading;

  /// Optional title widget.
  final Widget? title;

  /// Optional descriptive content.
  final Widget? content;

  /// Optional trailing widget (actions/dismissal).
  final Widget? trailing;

  /// Visual variant. Defaults to [AlertVariant.base].
  final AlertVariant variant;

  /// Widget-leg style override, merged on top of the component/app/defaults.
  final AlertTheme? theme;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData ambient = ShadcnTheme.of(context);
    final AlertStyle style = resolveComponentStyle<AlertTheme, AlertStyle>(
      context,
      widget: theme?.forVariant(variant),
      select: (t) => t.forVariant(variant),
      defaults: alertDefaults.forVariant(variant)!,
    );
    final ShadcnColors colors = ambient.colors;
    final Color titleColor =
        style.titleColor?.resolve(colors) ?? colors.foreground;
    final Color contentColor =
        style.contentColor?.resolve(colors) ?? colors.mutedForeground;
    final Color iconColor =
        style.iconColor?.resolve(colors) ?? colors.foreground;
    final BorderRadiusGeometry radius =
        style.borderRadius ?? ambient.borderRadiusLg;
    final Color borderColor =
        style.borderColor?.resolve(colors) ?? colors.border;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: style.background?.resolve(colors),
        border: Border.all(color: borderColor),
        borderRadius: radius,
      ),
      child: Padding(
        // `alertDefaults.base.padding` is shadcn `px-4 py-3` held as density
        // multipliers; a widget-leg literal resolves to itself here.
        padding: resolveEdgeInsets(
          style.padding ?? EdgeInsets.zero,
          ambient.density.baseContentPadding * ambient.scaling,
        ),
        child: BasicLayout(
          leading: leading == null
              ? null
              : IconTheme.merge(
                  data: IconThemeData(
                    size: ambient.iconTheme.small.size,
                    color: iconColor,
                  ),
                  child: leading!,
                ),
          title: title == null
              ? null
              : DefaultTextStyle.merge(
                  style: (style.titleStyle ?? alertDefaultTitleStyle).copyWith(
                    color: titleColor,
                  ),
                  child: title!,
                ),
          content: content == null
              ? null
              : DefaultTextStyle.merge(
                  style: (style.contentStyle ?? alertDefaultContentStyle)
                      .copyWith(color: contentColor),
                  child: content!,
                ),
          trailing: trailing,
          contentSpacing: style.gap,
        ),
      ),
    );
  }
}
