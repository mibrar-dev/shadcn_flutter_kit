// Registry-owned theme data for the `multiple_choice` component.
//
// The old `MultipleChoiceTheme` carried one field (`allowUnselect`) and was
// read with `widget.theme ?? ComponentTheme.maybeOf(...)`, so the app leg was
// unreachable and a widget override replaced the whole theme. This is the new
// mergeable container; the resolver reads all four legs per field.
//
// User-owned overrides live in `multiple_choice_theme.dart`.

import 'package:flutter/widgets.dart';

import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';

/// Whether re-selecting the current choice clears it, per widget kind.
///
/// A single [MultipleChoice] keeps a selection once made (shadcn radio
/// behaviour), while a [MultipleAnswer] toggles items off.
class MultipleChoiceTheme extends ComponentThemeData
    implements Mergeable<MultipleChoiceTheme> {
  /// Creates a selection theme.
  const MultipleChoiceTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.allowUnselect,
  });

  /// Whether picking the current choice again clears it; null keeps the
  /// widget kind's default (`false` for choice, `true` for answer).
  final bool? allowUnselect;

  /// Returns a copy with the given field replaced.
  MultipleChoiceTheme copyWith({ValueGetter<bool?>? allowUnselect}) {
    return MultipleChoiceTheme(
      themeDensity: themeDensity,
      themeSpacing: themeSpacing,
      themeShadows: themeShadows,
      allowUnselect: allowUnselect == null
          ? this.allowUnselect
          : allowUnselect(),
    );
  }

  /// First-non-null-wins merge; the receiver (higher-priority leg) wins.
  @override
  MultipleChoiceTheme merge(MultipleChoiceTheme? fallback) {
    if (fallback == null) {
      return this;
    }
    return MultipleChoiceTheme(
      themeDensity: themeDensity ?? fallback.themeDensity,
      themeSpacing: themeSpacing ?? fallback.themeSpacing,
      themeShadows: themeShadows ?? fallback.themeShadows,
      allowUnselect: allowUnselect ?? fallback.allowUnselect,
    );
  }

  /// Steps at t < 0.5; booleans do not interpolate.
  static MultipleChoiceTheme lerp(
    MultipleChoiceTheme a,
    MultipleChoiceTheme b,
    double t,
  ) {
    return MultipleChoiceTheme(
      themeDensity: t < 0.5 ? a.themeDensity : b.themeDensity,
      themeSpacing: t < 0.5 ? a.themeSpacing : b.themeSpacing,
      themeShadows: t < 0.5 ? a.themeShadows : b.themeShadows,
      allowUnselect: t < 0.5 ? a.allowUnselect : b.allowUnselect,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is MultipleChoiceTheme &&
        other.themeDensity == themeDensity &&
        other.themeSpacing == themeSpacing &&
        other.themeShadows == themeShadows &&
        other.allowUnselect == allowUnselect;
  }

  @override
  int get hashCode =>
      Object.hash(themeDensity, themeSpacing, themeShadows, allowUnselect);
}

/// Defaults for [MultipleChoice]: a chosen value stays chosen.
const MultipleChoiceTheme multipleChoiceDefaults = MultipleChoiceTheme(
  allowUnselect: false,
);

/// Defaults for [MultipleAnswer]: picking an item again removes it.
const MultipleChoiceTheme multipleAnswerDefaults = MultipleChoiceTheme(
  allowUnselect: true,
);
