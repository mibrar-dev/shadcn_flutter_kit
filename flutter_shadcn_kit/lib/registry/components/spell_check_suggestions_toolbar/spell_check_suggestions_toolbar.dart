// The `spell_check_suggestions_toolbar` component: a menu-backed toolbar
// with the spell check replacements for the misspelled word under the
// cursor. Ported from the old module of the same name; the rows and the
// surface are the `menu` component's, so this file is only the EditableText
// wiring.

import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart'
    show SelectionChangedCause, SuggestionSpan;
import 'package:flutter/widgets.dart';

import '../../primitives/localizations/localizations.dart';
import '../menu/menu.dart';

/// The number of spell check suggestions the toolbar offers at once.
///
/// Kept at three to match the platform convention on iOS and Android; longer
/// lists turn the toolbar into a menu the user has to read rather than a
/// quick correction they can hit.
const int kMaxSpellCheckSuggestions = 3;

/// A shadcn styled toolbar offering replacement suggestions for the
/// misspelled word under the cursor.
///
/// Build it from an [EditableTextState] with the `.editableText` constructor
/// and return it from an editable text toolbar builder; the framework places
/// it at [anchors]. The registry `input` component does not enable spell
/// check itself, so this toolbar is wired by apps that opt into
/// `EditableText`'s `spellCheckConfiguration`.
class SpellCheckSuggestionsToolbar extends StatelessWidget {
  /// Creates a toolbar from explicit button items.
  ///
  /// [buttonItems] must not contain more than three items, mirroring the
  /// platform convention.
  const SpellCheckSuggestionsToolbar({
    super.key,
    required this.anchors,
    required this.buttonItems,
  }) : assert(buttonItems.length <= kMaxSpellCheckSuggestions);

  /// Creates a toolbar for [editableTextState].
  ///
  /// Reads the misspelled span under the cursor from [editableTextState] and
  /// turns its suggestions into replacement rows. When there is no misspelled
  /// span, or the service offers no suggestion for it, the toolbar builds to
  /// nothing.
  SpellCheckSuggestionsToolbar.editableText({
    super.key,
    required EditableTextState editableTextState,
  }) : buttonItems = buildButtonItems(editableTextState),
       anchors = editableTextState.contextMenuAnchors;

  /// Where the toolbar is anchored relative to the text field.
  final TextSelectionToolbarAnchors anchors;

  /// The replacement suggestions to display, at most three.
  final List<ContextMenuButtonItem> buttonItems;

  /// Replacement rows for the misspelled word under the cursor.
  ///
  /// Returns an empty list when the cursor is not inside a misspelled span.
  /// A misspelled span without suggestions returns one disabled placeholder
  /// row; the toolbar labels it with
  /// `ShadcnLocalizations.spellCheckNoSuggestions`.
  static List<ContextMenuButtonItem> buildButtonItems(
    EditableTextState editableTextState,
  ) {
    final SuggestionSpan? span = editableTextState
        .findSuggestionSpanAtCursorIndex(
          editableTextState.currentTextEditingValue.selection.baseOffset,
        );
    if (span == null) {
      return const <ContextMenuButtonItem>[];
    }
    if (span.suggestions.isEmpty) {
      return const <ContextMenuButtonItem>[
        ContextMenuButtonItem(onPressed: null),
      ];
    }
    return <ContextMenuButtonItem>[
      for (final String suggestion in span.suggestions.take(
        kMaxSpellCheckSuggestions,
      ))
        ContextMenuButtonItem(
          onPressed: () {
            if (!editableTextState.mounted) {
              return;
            }
            _replaceText(editableTextState, suggestion, span.range);
          },
          label: suggestion,
        ),
    ];
  }

  static void _replaceText(
    EditableTextState editableTextState,
    String text,
    TextRange replacementRange,
  ) {
    // Replacement cannot be performed if the text is read only or obscured.
    assert(
      !editableTextState.widget.readOnly &&
          !editableTextState.widget.obscureText,
    );
    final TextEditingValue newValue = editableTextState.textEditingValue
        .replaced(replacementRange, text)
        .copyWith(
          selection: TextSelection.collapsed(
            offset: replacementRange.start + text.length,
          ),
        );
    editableTextState.userUpdateTextEditingValue(
      newValue,
      SelectionChangedCause.toolbar,
    );
    // The caret moved to the end of the replacement, which may sit outside
    // the visible region; scroll to it once renderEditable has laid out.
    SchedulerBinding.instance.addPostFrameCallback((Duration duration) {
      if (editableTextState.mounted) {
        editableTextState.bringIntoView(
          editableTextState.textEditingValue.selection.extent,
        );
      }
    }, debugLabel: 'SpellCheckSuggestions.bringIntoView');
    editableTextState.hideToolbar();
  }

  @override
  Widget build(BuildContext context) {
    if (buttonItems.isEmpty) {
      return const SizedBox.shrink();
    }
    final ShadcnLocalizations localizations = ShadcnLocalizations.of(context);
    final position = anchors.primaryAnchor + const Offset(8, -8);
    return TextFieldTapRegion(
      child: Stack(
        children: <Widget>[
          Positioned(
            left: position.dx,
            top: position.dy,
            child: MenuPopup(
              children: <Widget>[
                MenuGroup(
                  autofocus: false,
                  children: <Widget>[
                    for (final ContextMenuButtonItem item in buttonItems)
                      MenuButton(
                        enabled: item.onPressed != null,
                        onPressed: (context) => item.onPressed?.call(),
                        autoClose: false,
                        child: Text(
                          item.label ?? localizations.spellCheckNoSuggestions,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
