// Shared style resolution for visible editable text.
//
// `EditableText` ignores the ambient `DefaultTextStyle`, so the theme font
// must be wired explicitly here instead of relying on inheritance like
// `Text` does. Every registry `EditableText` with painted glyphs
// (`input` via `resolveInputSurface`, hence `text_area` too) resolves its
// style through `resolveEditableTextStyle`.

import 'package:flutter/widgets.dart';

import '../../theme/theme.dart';

/// Completes an editable-text style.
///
/// [base] is the size source (usually `theme.typography.small`, i.e.
/// text-sm/14); [overrides] are the merged theme-leg + widget-leg styles and
/// win over [base]. Missing fields are filled, in order, from the ambient
/// `DefaultTextStyle` (galleries wire the theme font there) and then from
/// `theme.typography.sans`, so a bare app with no ambient style still gets
/// the theme font instead of the platform default. [color] is the final
/// fallback (foreground for typed text, mutedForeground for placeholders).
TextStyle resolveEditableTextStyle(
  BuildContext context, {
  TextStyle? base,
  List<TextStyle?> overrides = const <TextStyle?>[],
  required Color color,
}) {
  final ShadcnThemeData theme = ShadcnTheme.of(context);
  final TextStyle ambient = DefaultTextStyle.of(context).style;
  TextStyle merged = base ?? const TextStyle();
  for (final TextStyle? override in overrides) {
    merged = merged.merge(override);
  }
  return merged.copyWith(
    fontFamily:
        merged.fontFamily ??
        ambient.fontFamily ??
        theme.typography.sans.fontFamily,
    fontFamilyFallback:
        merged.fontFamilyFallback ??
        ambient.fontFamilyFallback ??
        theme.typography.sans.fontFamilyFallback,
    height: merged.height ?? ambient.height,
    color: merged.color ?? color,
  );
}
