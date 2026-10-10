// Registry-owned theme data for the `autocomplete` component: the
// [AutoCompleteMode] text-replacement strategies, the popover/suggestion-list
// rows and the token-derived `autocompleteDefaults`.
//
// The mode enum and the theme live here (not in `autocomplete.dart`) so the
// style layer never imports the widget layer; `autocomplete.dart` re-exports
// them. `copyWith`/`lerp` are deliberately absent: nothing animates a component
// theme (QA_LOG P4-B07, calendar).

import 'package:flutter/widgets.dart';

import '../../foundation/text_input.dart';
import '../../primitives/overlay.dart';
import '../../theme/color_tokens.dart';
import '../../theme/density.dart';
import '../../theme/theme.dart';

/// How an accepted suggestion is written into the field.
enum AutoCompleteMode {
  /// Inserts the suggestion at the caret, keeping the rest of the text.
  append,

  /// Replaces the word around the caret. The default.
  replaceWord,

  /// Replaces the whole field content.
  replaceAll,
}

/// Signature for post-processing a suggestion before it is applied: takes the
/// raw suggestion and returns the text to insert.
typedef AutoCompleteCompleter = String Function(String suggestion);

/// Moves the highlight inside the suggestion list by [direction] rows.
class AutoCompleteNavigateIntent extends Intent {
  /// Creates a navigation intent.
  const AutoCompleteNavigateIntent(this.direction);

  /// `1` for the next row, `-1` for the previous one.
  final int direction;
}

/// Applies the highlighted suggestion to the field.
class AutoCompleteAcceptIntent extends Intent {
  /// Creates an accept intent.
  const AutoCompleteAcceptIntent();
}

/// Closes the suggestion list without applying anything.
class AutoCompleteDismissIntent extends Intent {
  /// Creates a dismiss intent.
  const AutoCompleteDismissIntent();
}

/// Returns [suggestion] unchanged; the default [AutoCompleteCompleter].
const AutoCompleteCompleter identityAutoCompleteCompleter = _identityCompleter;

String _identityCompleter(String suggestion) => suggestion;

/// Builds one suggestion row of the list.
typedef SuggestionRowBuilder =
    Widget Function(BuildContext context, String suggestion, bool selected);

/// Characters that end a word when the current one is replaced.
bool isAutoCompleteWordSeparator(String character) =>
    character == ' ' || character == '\n' || character == '\t';

/// Writes [text] into [controller] the way [mode] asks for.
///
/// `append` inserts at the caret (the old code appended at the end of the text,
/// which moved the caret out from under the user), `replaceWord` replaces the
/// word around the caret and `replaceAll` replaces everything.
void applyAutoCompleteSuggestion(
  TextEditingController controller,
  String text,
  AutoCompleteMode mode,
) {
  final TextEditingValue value = controller.value;
  final TextSelection selection = value.selection;
  final int caret = selection.isValid
      ? selection.baseOffset.clamp(0, value.text.length)
      : value.text.length;
  switch (mode) {
    case AutoCompleteMode.append:
      controller.value = TextEditingValue(
        text: value.text.replaceRange(caret, caret, text),
        selection: TextSelection.collapsed(offset: caret + text.length),
      );
    case AutoCompleteMode.replaceWord:
      final (int start, String replaced) = replaceWordAtCaret(
        value.text,
        caret,
        text,
        isAutoCompleteWordSeparator,
      );
      controller.value = TextEditingValue(
        text: replaced,
        selection: TextSelection.collapsed(offset: start + text.length),
      );
    case AutoCompleteMode.replaceAll:
      controller.value = TextEditingValue(
        text: text,
        selection: TextSelection.collapsed(offset: text.length),
      );
  }
}

/// Default height cap of the suggestion list (shadcn `max-h-60` = 240).
const double autocompleteDefaultMaxHeight = 240;

/// Fallback text style of a suggestion row (shadcn `text-sm` = 14).
const TextStyle autocompleteDefaultTextStyle = TextStyle(fontSize: 14);

/// Fallback row padding: shadcn `px-2 py-1.5` as density multipliers,
/// resolved by `AutoCompleteFeature` against
/// `density.baseContentPadding * scaling`.
const EdgeInsetsGeometry autocompleteDefaultItemPadding =
    EdgeInsetsDensity.pxSymmetric(horizontal: 8, vertical: 6);

/// Popover presentation and per-row styling of the suggestion list.
///
/// Every field is nullable: an override leg sets only what it changes and
/// [merge] keeps the lower leg's remaining fields.
class AutoCompleteTheme extends ComponentThemeData
    implements Mergeable<AutoCompleteTheme> {
  /// Creates an autocomplete theme.
  const AutoCompleteTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.mode,
    this.popoverConstraints,
    this.popoverWidthConstraint,
    this.popoverAlignment,
    this.popoverAnchorAlignment,
    this.containerBackground,
    this.containerForeground,
    this.containerBorderColor,
    this.containerBorderWidth,
    this.containerBorderRadius,
    this.containerPadding,
    this.itemBackground,
    this.itemForeground,
    this.itemPadding,
    this.itemRadius,
    this.itemTextStyle,
    this.gap,
    this.maxHeight,
  });

  /// Default replacement strategy; null falls back to
  /// [AutoCompleteMode.replaceWord].
  final AutoCompleteMode? mode;

  /// Size constraints of the suggestion popover.
  final BoxConstraints? popoverConstraints;

  /// How the popover width relates to the anchor.
  final PopoverConstraint? popoverWidthConstraint;

  /// Where the popover sits relative to itself.
  final AlignmentGeometry? popoverAlignment;

  /// Which edge of the field the popover attaches to.
  final AlignmentGeometry? popoverAnchorAlignment;

  /// Surface fill of the popover container.
  final ThemedColor? containerBackground;

  /// Label colour inherited by the popover content.
  final ThemedColor? containerForeground;

  /// Border colour of the popover container; null draws no border.
  final ThemedColor? containerBorderColor;

  /// Border width used when [containerBorderColor] resolves non-null.
  final double? containerBorderWidth;

  /// Corner radius of the popover container.
  final BorderRadiusGeometry? containerBorderRadius;

  /// Inner padding of the popover container; cmdk `p-1` (4) as density
  /// multipliers. Resolved by the `Card` that paints the popover.
  final EdgeInsetsGeometry? containerPadding;

  /// Per-state fill of a suggestion row.
  final StateValue<ThemedColor>? itemBackground;

  /// Per-state label colour of a suggestion row.
  final StateValue<ThemedColor>? itemForeground;

  /// Padding of a suggestion row (shadcn `px-2 py-1.5` as density
  /// multipliers); null resolves [autocompleteDefaultItemPadding]. The row is
  /// painted by `Clickable`, so `AutoCompleteFeature` resolves it.
  final EdgeInsetsGeometry? itemPadding;

  /// Corner radius of a suggestion row.
  final BorderRadiusGeometry? itemRadius;

  /// Text style of a suggestion row; its colour comes from
  /// [itemForeground].
  final TextStyle? itemTextStyle;

  /// Vertical space between two suggestion rows.
  final double? gap;

  /// Height cap of the scrollable list; null resolves
  /// [autocompleteDefaultMaxHeight].
  final double? maxHeight;

  /// First-non-null-wins merge; the receiver (higher-priority leg) wins.
  @override
  AutoCompleteTheme merge(AutoCompleteTheme? fallback) {
    if (fallback == null) {
      return this;
    }
    return AutoCompleteTheme(
      themeDensity: themeDensity ?? fallback.themeDensity,
      themeSpacing: themeSpacing ?? fallback.themeSpacing,
      themeShadows: themeShadows ?? fallback.themeShadows,
      mode: mode ?? fallback.mode,
      popoverConstraints: popoverConstraints ?? fallback.popoverConstraints,
      popoverWidthConstraint:
          popoverWidthConstraint ?? fallback.popoverWidthConstraint,
      popoverAlignment: popoverAlignment ?? fallback.popoverAlignment,
      popoverAnchorAlignment:
          popoverAnchorAlignment ?? fallback.popoverAnchorAlignment,
      containerBackground: containerBackground ?? fallback.containerBackground,
      containerForeground: containerForeground ?? fallback.containerForeground,
      containerBorderColor:
          containerBorderColor ?? fallback.containerBorderColor,
      containerBorderWidth:
          containerBorderWidth ?? fallback.containerBorderWidth,
      containerBorderRadius:
          containerBorderRadius ?? fallback.containerBorderRadius,
      containerPadding: containerPadding ?? fallback.containerPadding,
      itemBackground:
          itemBackground?.merge(fallback.itemBackground) ??
          fallback.itemBackground,
      itemForeground:
          itemForeground?.merge(fallback.itemForeground) ??
          fallback.itemForeground,
      itemPadding: itemPadding ?? fallback.itemPadding,
      itemRadius: itemRadius ?? fallback.itemRadius,
      itemTextStyle: itemTextStyle == null
          ? fallback.itemTextStyle
          : (fallback.itemTextStyle?.merge(itemTextStyle) ?? itemTextStyle),
      gap: gap ?? fallback.gap,
      maxHeight: maxHeight ?? fallback.maxHeight,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is AutoCompleteTheme &&
        other.themeDensity == themeDensity &&
        other.themeSpacing == themeSpacing &&
        other.themeShadows == themeShadows &&
        other.mode == mode &&
        other.popoverConstraints == popoverConstraints &&
        other.popoverWidthConstraint == popoverWidthConstraint &&
        other.popoverAlignment == popoverAlignment &&
        other.popoverAnchorAlignment == popoverAnchorAlignment &&
        other.containerBackground == containerBackground &&
        other.containerForeground == containerForeground &&
        other.containerBorderColor == containerBorderColor &&
        other.containerBorderWidth == containerBorderWidth &&
        other.containerBorderRadius == containerBorderRadius &&
        other.containerPadding == containerPadding &&
        other.itemBackground == itemBackground &&
        other.itemForeground == itemForeground &&
        other.itemPadding == itemPadding &&
        other.itemRadius == itemRadius &&
        other.itemTextStyle == itemTextStyle &&
        other.gap == gap &&
        other.maxHeight == maxHeight;
  }

  // `Object.hash` tops out at 20 positional arguments.
  @override
  int get hashCode => Object.hashAll(<Object?>[
    themeDensity,
    themeSpacing,
    themeShadows,
    mode,
    popoverConstraints,
    popoverWidthConstraint,
    popoverAlignment,
    popoverAnchorAlignment,
    containerBackground,
    containerForeground,
    containerBorderColor,
    containerBorderWidth,
    containerBorderRadius,
    containerPadding,
    itemBackground,
    itemForeground,
    itemPadding,
    itemRadius,
    itemTextStyle,
    gap,
    maxHeight,
  ]);
}

// ---------------------------------------------------------------------------
// Defaults (registry-owned, tokens only).
//
// The rows follow shadcn's `Command` list: a `popover` surface with a `border`
// at `radiusMd` and rows that fill `accent` while highlighted. Hover/press
// duplicate the highlight row because `StateValue.resolve` never falls back
// from one state to another.
// ---------------------------------------------------------------------------

const _itemBg = StateValue(
  hovered: ThemedColor.ref(ColorRef.accent),
  pressed: ThemedColor.ref(ColorRef.accent),
  selected: ThemedColor.ref(ColorRef.accent),
);
const _itemFg = StateValue(
  hovered: ThemedColor.ref(ColorRef.accentForeground),
  pressed: ThemedColor.ref(ColorRef.accentForeground),
  selected: ThemedColor.ref(ColorRef.accentForeground),
);

/// Token-derived baseline values; every unset override field falls through
/// here.
///
/// `containerPadding` is the cmdk command-list surface's `p-1` (4) and
/// `itemPadding` a row's `px-2 py-1.5` (8/6), both stored as density
/// multipliers: the popover is painted by `Card` (which resolves them against
/// `density.baseContentPadding * scaling`) and the rows by `AutoCompleteFeature`,
/// so neither is resolved twice.
const AutoCompleteTheme autocompleteDefaults = AutoCompleteTheme(
  mode: AutoCompleteMode.replaceWord,
  popoverWidthConstraint: PopoverConstraint.anchorFixedSize,
  popoverAnchorAlignment: AlignmentDirectional.bottomStart,
  popoverAlignment: AlignmentDirectional.topStart,
  containerBackground: ThemedColor.ref(ColorRef.popover),
  containerForeground: ThemedColor.ref(ColorRef.popoverForeground),
  containerBorderColor: ThemedColor.ref(ColorRef.border),
  containerBorderWidth: 1,
  containerPadding: EdgeInsetsDensity.pxAll(4),
  itemBackground: _itemBg,
  itemForeground: _itemFg,
  itemPadding: autocompleteDefaultItemPadding,
  itemTextStyle: autocompleteDefaultTextStyle,
  gap: 0,
  maxHeight: autocompleteDefaultMaxHeight,
);
