// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../basic.dart';

/// BasicTheme defines a reusable type for this registry module.
class BasicTheme extends ComponentThemeData {
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

  /// Spacing between content elements.
  final double? contentSpacing;

  /// Spacing between title and subtitle.
  final double? titleSpacing;

  /// Main axis alignment for the overall layout.
  final MainAxisAlignment? mainAxisAlignment;

  /// Padding around the entire Basic widget.
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

  /// Creates a copy of this theme with the given fields replaced.
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

  @override
  /// Executes `operator ==` behavior for this component/composite.
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

/// A versatile layout widget for arranging leading, title, subtitle, content, and trailing elements.
///
/// Provides a flexible row-based layout commonly used for list items, cards, or
/// any UI requiring a structured arrangement of multiple content sections. Each
/// section can be independently aligned and spaced.
///
/// Example:
/// ```dart
/// Basic(
///   leading: Icon(Icons.person),
///   title: Text('John Doe'),
///   subtitle: Text('john@example.com'),
///   trailing: Icon(Icons.chevron_right),
/// )
/// ```
