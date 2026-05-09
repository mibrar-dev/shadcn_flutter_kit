// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../../multiple_choice.dart';

/// Theme data for [MultipleChoice] and [MultipleAnswer].
class MultipleChoiceTheme extends ComponentThemeData {
  /// Whether selections can be unselected.
  final bool? allowUnselect;

  /// Creates a [MultipleChoiceTheme].
  const MultipleChoiceTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.allowUnselect,
  });

  /// Returns a copy of this theme with the given fields replaced by the
  /// non-null parameters.
  MultipleChoiceTheme copyWith({ValueGetter<bool?>? allowUnselect}) {
    return MultipleChoiceTheme(
      allowUnselect: allowUnselect == null
          ? this.allowUnselect
          : allowUnselect(),
    );
  }

  /// Compares this object with another for value equality.
  @override
  bool operator ==(Object other) =>
      other is MultipleChoiceTheme && other.allowUnselect == allowUnselect;

  /// Flag indicating whether `hashCode` is enabled/active.
  @override
  int get hashCode => allowUnselect.hashCode;

  /// Returns a debug-friendly string representation.
  @override
  String toString() => 'MultipleChoiceTheme(allowUnselect: $allowUnselect)';
}
