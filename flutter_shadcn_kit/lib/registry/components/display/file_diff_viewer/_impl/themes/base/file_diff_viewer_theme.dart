part of '../../../file_diff_viewer.dart';

/// Theme configuration for [FileDiffViewer].
class FileDiffViewerTheme extends ComponentThemeData {
  /// Viewer background color.
  final Color? backgroundColor;

  /// Border color.
  final Color? borderColor;

  /// Header background color.
  final Color? headerBackgroundColor;

  /// Added line background color.
  final Color? additionBackgroundColor;

  /// Deleted line background color.
  final Color? deletionBackgroundColor;

  /// Hunk header background color.
  final Color? hunkBackgroundColor;

  /// Gutter background color.
  final Color? gutterBackgroundColor;

  /// Border radius.
  final BorderRadiusGeometry? borderRadius;

  /// Padding inside each line.
  final EdgeInsetsGeometry? linePadding;

  /// Creates a theme for [FileDiffViewer].
  const FileDiffViewerTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.backgroundColor,
    this.borderColor,
    this.headerBackgroundColor,
    this.additionBackgroundColor,
    this.deletionBackgroundColor,
    this.hunkBackgroundColor,
    this.gutterBackgroundColor,
    this.borderRadius,
    this.linePadding,
  });

  /// Returns a copy with replaced values.
  FileDiffViewerTheme copyWith({
    ValueGetter<Color?>? backgroundColor,
    ValueGetter<Color?>? borderColor,
    ValueGetter<Color?>? headerBackgroundColor,
    ValueGetter<Color?>? additionBackgroundColor,
    ValueGetter<Color?>? deletionBackgroundColor,
    ValueGetter<Color?>? hunkBackgroundColor,
    ValueGetter<Color?>? gutterBackgroundColor,
    ValueGetter<BorderRadiusGeometry?>? borderRadius,
    ValueGetter<EdgeInsetsGeometry?>? linePadding,
  }) {
    return FileDiffViewerTheme(
      backgroundColor: backgroundColor == null
          ? this.backgroundColor
          : backgroundColor(),
      borderColor: borderColor == null ? this.borderColor : borderColor(),
      headerBackgroundColor: headerBackgroundColor == null
          ? this.headerBackgroundColor
          : headerBackgroundColor(),
      additionBackgroundColor: additionBackgroundColor == null
          ? this.additionBackgroundColor
          : additionBackgroundColor(),
      deletionBackgroundColor: deletionBackgroundColor == null
          ? this.deletionBackgroundColor
          : deletionBackgroundColor(),
      hunkBackgroundColor: hunkBackgroundColor == null
          ? this.hunkBackgroundColor
          : hunkBackgroundColor(),
      gutterBackgroundColor: gutterBackgroundColor == null
          ? this.gutterBackgroundColor
          : gutterBackgroundColor(),
      borderRadius: borderRadius == null ? this.borderRadius : borderRadius(),
      linePadding: linePadding == null ? this.linePadding : linePadding(),
    );
  }

  /// Compares two file diff viewer themes for structural equality.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FileDiffViewerTheme &&
        other.backgroundColor == backgroundColor &&
        other.borderColor == borderColor &&
        other.headerBackgroundColor == headerBackgroundColor &&
        other.additionBackgroundColor == additionBackgroundColor &&
        other.deletionBackgroundColor == deletionBackgroundColor &&
        other.hunkBackgroundColor == hunkBackgroundColor &&
        other.gutterBackgroundColor == gutterBackgroundColor &&
        other.borderRadius == borderRadius &&
        other.linePadding == linePadding;
  }

  @override
  int get hashCode => Object.hash(
    backgroundColor,
    borderColor,
    headerBackgroundColor,
    additionBackgroundColor,
    deletionBackgroundColor,
    hunkBackgroundColor,
    gutterBackgroundColor,
    borderRadius,
    linePadding,
  );
}
