// The `FileUploadRow` theme slice, shared by the file components.
//
// Ported from `form/file_picker/_impl/core/file_item.dart` (`FileItem`) and
// `_impl/core/file_input/file_input.dart` (the icon mapping). The widget is
// called `FileUploadRow` because `FileItem` is the value type. It lives in the
// `file_value` primitive (P4-B22, Q7) so the `file_picker` component fits its
// three-file folder; `progress` is a slot so a layer-2 file never imports a
// component.
//
// Fixed (not ported): the old row's `LinearProgressIndicator` was a Material
// widget; the caller passes the `progress` component instead.

import 'package:flutter/widgets.dart';

import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';

/// Styling of a [FileUploadRow].
class FileUploadRowTheme extends ComponentThemeData
    implements Mergeable<FileUploadRowTheme> {
  /// Creates a row theme.
  const FileUploadRowTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.background,
    this.borderColor,
    this.borderRadius,
    this.padding,
    this.gap,
    this.iconColor,
    this.iconSize,
    this.thumbnailSize,
    this.thumbnailBackground,
    this.labelStyle,
    this.metaStyle,
    this.successColor,
    this.errorColor,
    this.mutedColor,
  });

  /// Row fill; null draws no fill.
  final ThemedColor? background;

  /// Row border; null draws no border.
  final ThemedColor? borderColor;

  /// Corner radius; null resolves the ambient `radiusMd`.
  final BorderRadiusGeometry? borderRadius;

  /// Row padding; null resolves 12.
  final double? padding;

  /// Space between the thumbnail and the text block; null resolves 12.
  final double? gap;

  /// Thumbnail/action colour; null resolves `mutedForeground`.
  final ThemedColor? iconColor;

  /// Thumbnail icon side; null resolves 20.
  final double? iconSize;

  /// Thumbnail box side; null resolves 40.
  final double? thumbnailSize;

  /// Thumbnail box fill; null resolves `muted` at 40% alpha.
  final ThemedColor? thumbnailBackground;

  /// File-name style; its colour is the ambient foreground.
  final TextStyle? labelStyle;

  /// Meta-line style; its colour falls back to the status colour.
  final TextStyle? metaStyle;

  /// Success status colour; null resolves `accent`.
  final ThemedColor? successColor;

  /// Error status colour; null resolves `destructive`.
  final ThemedColor? errorColor;

  /// Queued/uploading colour; null resolves `mutedForeground`.
  final ThemedColor? mutedColor;

  /// First-non-null-wins merge; the receiver (higher-priority leg) wins.
  @override
  FileUploadRowTheme merge(FileUploadRowTheme? fallback) {
    if (fallback == null) {
      return this;
    }
    return FileUploadRowTheme(
      themeDensity: themeDensity ?? fallback.themeDensity,
      themeSpacing: themeSpacing ?? fallback.themeSpacing,
      themeShadows: themeShadows ?? fallback.themeShadows,
      background: background ?? fallback.background,
      borderColor: borderColor ?? fallback.borderColor,
      borderRadius: borderRadius ?? fallback.borderRadius,
      padding: padding ?? fallback.padding,
      gap: gap ?? fallback.gap,
      iconColor: iconColor ?? fallback.iconColor,
      iconSize: iconSize ?? fallback.iconSize,
      thumbnailSize: thumbnailSize ?? fallback.thumbnailSize,
      thumbnailBackground: thumbnailBackground ?? fallback.thumbnailBackground,
      labelStyle: labelStyle == null
          ? fallback.labelStyle
          : (fallback.labelStyle?.merge(labelStyle) ?? labelStyle),
      metaStyle: metaStyle == null
          ? fallback.metaStyle
          : (fallback.metaStyle?.merge(metaStyle) ?? metaStyle),
      successColor: successColor ?? fallback.successColor,
      errorColor: errorColor ?? fallback.errorColor,
      mutedColor: mutedColor ?? fallback.mutedColor,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is FileUploadRowTheme &&
        other.themeDensity == themeDensity &&
        other.themeSpacing == themeSpacing &&
        other.themeShadows == themeShadows &&
        other.background == background &&
        other.borderColor == borderColor &&
        other.borderRadius == borderRadius &&
        other.padding == padding &&
        other.gap == gap &&
        other.iconColor == iconColor &&
        other.iconSize == iconSize &&
        other.thumbnailSize == thumbnailSize &&
        other.thumbnailBackground == thumbnailBackground &&
        other.labelStyle == labelStyle &&
        other.metaStyle == metaStyle &&
        other.successColor == successColor &&
        other.errorColor == errorColor &&
        other.mutedColor == mutedColor;
  }

  @override
  int get hashCode => Object.hashAll(<Object?>[
    Object.hash(themeDensity, themeSpacing, themeShadows),
    background,
    borderColor,
    borderRadius,
    padding,
    gap,
    iconColor,
    iconSize,
    thumbnailSize,
    thumbnailBackground,
    labelStyle,
    metaStyle,
    successColor,
    errorColor,
    mutedColor,
  ]);
}

/// Token-derived baseline values; unset override fields fall through here.
const FileUploadRowTheme fileUploadRowDefaults = FileUploadRowTheme(
  borderRadius: BorderRadius.all(Radius.circular(8)),
  padding: 12,
  gap: 12,
  iconColor: ThemedColor.ref(ColorRef.mutedForeground),
  iconSize: 20,
  thumbnailSize: 40,
  thumbnailBackground: ThemedColor.ref(ColorRef.muted, alpha: 0.4),
  labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
  metaStyle: TextStyle(fontSize: 12),
  successColor: ThemedColor.ref(ColorRef.accent),
  errorColor: ThemedColor.ref(ColorRef.destructive),
  mutedColor: ThemedColor.ref(ColorRef.mutedForeground),
);

/// One file row: thumbnail, name, type/size/status, actions and an optional
/// progress slot.
///
/// ```dart
/// FileUploadRow(
///   item: item,
///   progress: item.status.isBusy ? Progress(value: item.progress) : null,
///   onRemove: () => remove(item.file),
/// )
/// ```
