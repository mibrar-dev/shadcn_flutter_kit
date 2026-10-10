// Registry-owned theme data for the `file_picker` component: the
// [FileUploadTheme] surface and the token-derived [fileUploadDefaults].
//
// The widget-facing enums live here (not in `file_picker.dart`) so the style
// layer never imports the widget layer; `file_picker.dart` re-exports them.
// Row styling lives in the reusable `FileUploadRowTheme`
// (`primitives/file_value/file_upload_row_theme.dart`), themed through
// `ComponentThemes`/tree like any primitive. User-owned overrides live in
// `file_picker_theme.dart`.

import 'package:flutter/widgets.dart';

import '../../theme/color_tokens.dart';
import '../../theme/density.dart';
import '../../theme/theme.dart';

/// The surface a [FileUpload] renders.
enum FileUploadVariant {
  /// Drag-and-drop surface; a drag needs a caller-supplied `dropTargetBuilder`.
  dragDrop,

  /// One-line picker tile (label + chosen file name).
  tile,

  /// Compact trigger for small layouts.
  mobile,
}

/// Styling of the file surfaces.
///
/// Every field is nullable: an override leg sets only what it changes and
/// [merge] keeps the lower leg's remaining fields.
class FileUploadTheme extends ComponentThemeData
    implements Mergeable<FileUploadTheme> {
  /// Creates a file upload theme.
  const FileUploadTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.background,
    this.borderColor,
    this.borderWidth,
    this.borderRadius,
    this.padding,
    this.minHeight,
    this.gap,
  });

  /// Tile fill; null draws no fill (the ambient background shows through).
  final ThemedColor? background;

  /// Tile border; null falls back to the `input` token.
  final ThemedColor? borderColor;

  /// Border width; null resolves 1.
  final double? borderWidth;

  /// Corner radius; null resolves the ambient `radiusMd`.
  final BorderRadiusGeometry? borderRadius;

  /// Tile padding; null resolves `px-4 py-3` (16x12), density-scaled.
  final EdgeInsetsGeometry? padding;

  /// Tile minimum height; null resolves 48.
  final double? minHeight;

  /// Vertical rhythm between the surface, the rows and the errors.
  final double? gap;

  /// First-non-null-wins merge; the receiver (higher-priority leg) wins.
  @override
  FileUploadTheme merge(FileUploadTheme? fallback) {
    if (fallback == null) {
      return this;
    }
    return FileUploadTheme(
      themeDensity: themeDensity ?? fallback.themeDensity,
      themeSpacing: themeSpacing ?? fallback.themeSpacing,
      themeShadows: themeShadows ?? fallback.themeShadows,
      background: background ?? fallback.background,
      borderColor: borderColor ?? fallback.borderColor,
      borderWidth: borderWidth ?? fallback.borderWidth,
      borderRadius: borderRadius ?? fallback.borderRadius,
      padding: padding ?? fallback.padding,
      minHeight: minHeight ?? fallback.minHeight,
      gap: gap ?? fallback.gap,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is FileUploadTheme &&
        other.themeDensity == themeDensity &&
        other.themeSpacing == themeSpacing &&
        other.themeShadows == themeShadows &&
        other.background == background &&
        other.borderColor == borderColor &&
        other.borderWidth == borderWidth &&
        other.borderRadius == borderRadius &&
        other.padding == padding &&
        other.minHeight == minHeight &&
        other.gap == gap;
  }

  @override
  int get hashCode => Object.hash(
    Object.hash(themeDensity, themeSpacing, themeShadows),
    background,
    borderColor,
    borderWidth,
    borderRadius,
    padding,
    minHeight,
    gap,
  );
}

/// Tile padding: shadcn `px-4 py-3`, density-scaled.
const EdgeInsetsGeometry fileUploadDefaultPadding =
    EdgeInsetsDensity.pxSymmetric(horizontal: 16, vertical: 12);

/// Token-derived baseline values; unset override fields fall through here.
const FileUploadTheme fileUploadDefaults = FileUploadTheme(
  borderColor: ThemedColor.ref(ColorRef.input),
  borderWidth: 1,
  padding: fileUploadDefaultPadding,
  minHeight: 48,
  gap: 12,
);
