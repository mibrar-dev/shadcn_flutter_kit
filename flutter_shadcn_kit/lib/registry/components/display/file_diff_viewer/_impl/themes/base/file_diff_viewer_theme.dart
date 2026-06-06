part of '../../../file_diff_viewer.dart';

/// Theme configuration for [FileDiffViewer].
class FileDiffViewerTheme extends ComponentThemeData {
  /// Viewer background color.
  final Color? backgroundColor;

  /// Border color.
  final Color? borderColor;

  /// Header background color.
  final Color? headerBackgroundColor;

  /// Header file icon color.
  final Color? headerIconColor;

  /// Added line background color.
  final Color? additionBackgroundColor;

  /// Deleted line background color.
  final Color? deletionBackgroundColor;

  /// Hunk header background color.
  final Color? hunkBackgroundColor;

  /// Gutter background color.
  final Color? gutterBackgroundColor;

  /// Gutter line number foreground color.
  final Color? gutterForegroundColor;

  /// Added-line marker background color.
  final Color? additionMarkerColor;

  /// Deleted-line marker background color.
  final Color? deletionMarkerColor;

  /// Foreground color for compact change markers.
  final Color? markerForegroundColor;

  /// Border radius.
  final BorderRadiusGeometry? borderRadius;

  /// Border radius for changed line bands.
  final BorderRadiusGeometry? lineBorderRadius;

  /// Monospace font family used by code rows and gutters.
  final String? codeFontFamily;

  /// Font size used by code rows and gutters.
  final double? codeFontSize;

  /// Width of each line number gutter.
  final double? gutterWidth;

  /// Width reserved for line markers.
  final double? markerWidth;

  /// Size of circular change markers.
  final double? markerSize;

  /// Opacity applied to addition/deletion row backgrounds.
  final double? lineBackgroundOpacity;

  /// Opacity applied to inline changed segments.
  final double? segmentHighlightOpacity;

  /// Padding inside the file header.
  final EdgeInsetsGeometry? headerPadding;

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
    this.headerIconColor,
    this.additionBackgroundColor,
    this.deletionBackgroundColor,
    this.hunkBackgroundColor,
    this.gutterBackgroundColor,
    this.gutterForegroundColor,
    this.additionMarkerColor,
    this.deletionMarkerColor,
    this.markerForegroundColor,
    this.borderRadius,
    this.lineBorderRadius,
    this.codeFontFamily,
    this.codeFontSize,
    this.gutterWidth,
    this.markerWidth,
    this.markerSize,
    this.lineBackgroundOpacity,
    this.segmentHighlightOpacity,
    this.headerPadding,
    this.linePadding,
  });

  /// Returns a copy with replaced values.
  FileDiffViewerTheme copyWith({
    ValueGetter<Color?>? backgroundColor,
    ValueGetter<Color?>? borderColor,
    ValueGetter<Color?>? headerBackgroundColor,
    ValueGetter<Color?>? headerIconColor,
    ValueGetter<Color?>? additionBackgroundColor,
    ValueGetter<Color?>? deletionBackgroundColor,
    ValueGetter<Color?>? hunkBackgroundColor,
    ValueGetter<Color?>? gutterBackgroundColor,
    ValueGetter<Color?>? gutterForegroundColor,
    ValueGetter<Color?>? additionMarkerColor,
    ValueGetter<Color?>? deletionMarkerColor,
    ValueGetter<Color?>? markerForegroundColor,
    ValueGetter<BorderRadiusGeometry?>? borderRadius,
    ValueGetter<BorderRadiusGeometry?>? lineBorderRadius,
    ValueGetter<String?>? codeFontFamily,
    ValueGetter<double?>? codeFontSize,
    ValueGetter<double?>? gutterWidth,
    ValueGetter<double?>? markerWidth,
    ValueGetter<double?>? markerSize,
    ValueGetter<double?>? lineBackgroundOpacity,
    ValueGetter<double?>? segmentHighlightOpacity,
    ValueGetter<EdgeInsetsGeometry?>? headerPadding,
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
      headerIconColor: headerIconColor == null
          ? this.headerIconColor
          : headerIconColor(),
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
      gutterForegroundColor: gutterForegroundColor == null
          ? this.gutterForegroundColor
          : gutterForegroundColor(),
      additionMarkerColor: additionMarkerColor == null
          ? this.additionMarkerColor
          : additionMarkerColor(),
      deletionMarkerColor: deletionMarkerColor == null
          ? this.deletionMarkerColor
          : deletionMarkerColor(),
      markerForegroundColor: markerForegroundColor == null
          ? this.markerForegroundColor
          : markerForegroundColor(),
      borderRadius: borderRadius == null ? this.borderRadius : borderRadius(),
      lineBorderRadius: lineBorderRadius == null
          ? this.lineBorderRadius
          : lineBorderRadius(),
      codeFontFamily: codeFontFamily == null
          ? this.codeFontFamily
          : codeFontFamily(),
      codeFontSize: codeFontSize == null ? this.codeFontSize : codeFontSize(),
      gutterWidth: gutterWidth == null ? this.gutterWidth : gutterWidth(),
      markerWidth: markerWidth == null ? this.markerWidth : markerWidth(),
      markerSize: markerSize == null ? this.markerSize : markerSize(),
      lineBackgroundOpacity: lineBackgroundOpacity == null
          ? this.lineBackgroundOpacity
          : lineBackgroundOpacity(),
      segmentHighlightOpacity: segmentHighlightOpacity == null
          ? this.segmentHighlightOpacity
          : segmentHighlightOpacity(),
      headerPadding: headerPadding == null
          ? this.headerPadding
          : headerPadding(),
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
        other.headerIconColor == headerIconColor &&
        other.additionBackgroundColor == additionBackgroundColor &&
        other.deletionBackgroundColor == deletionBackgroundColor &&
        other.hunkBackgroundColor == hunkBackgroundColor &&
        other.gutterBackgroundColor == gutterBackgroundColor &&
        other.gutterForegroundColor == gutterForegroundColor &&
        other.additionMarkerColor == additionMarkerColor &&
        other.deletionMarkerColor == deletionMarkerColor &&
        other.markerForegroundColor == markerForegroundColor &&
        other.borderRadius == borderRadius &&
        other.lineBorderRadius == lineBorderRadius &&
        other.codeFontFamily == codeFontFamily &&
        other.codeFontSize == codeFontSize &&
        other.gutterWidth == gutterWidth &&
        other.markerWidth == markerWidth &&
        other.markerSize == markerSize &&
        other.lineBackgroundOpacity == lineBackgroundOpacity &&
        other.segmentHighlightOpacity == segmentHighlightOpacity &&
        other.headerPadding == headerPadding &&
        other.linePadding == linePadding;
  }

  @override
  int get hashCode => Object.hashAll([
    backgroundColor,
    borderColor,
    headerBackgroundColor,
    headerIconColor,
    additionBackgroundColor,
    deletionBackgroundColor,
    hunkBackgroundColor,
    gutterBackgroundColor,
    gutterForegroundColor,
    additionMarkerColor,
    deletionMarkerColor,
    markerForegroundColor,
    borderRadius,
    lineBorderRadius,
    codeFontFamily,
    codeFontSize,
    gutterWidth,
    markerWidth,
    markerSize,
    lineBackgroundOpacity,
    segmentHighlightOpacity,
    headerPadding,
    linePadding,
  ]);
}
