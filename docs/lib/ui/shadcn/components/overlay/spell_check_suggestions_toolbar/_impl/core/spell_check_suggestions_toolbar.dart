// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../spell_check_suggestions_toolbar.dart';

/// The number of spell check suggestions the toolbar offers at once.
///
/// Kept at three to match the platform convention on iOS and Android; longer
/// lists turn the toolbar into a menu the user has to read rather than a
/// quick correction they can hit.
const int kMaxSpellCheckSuggestions = 3;

/// A shadcn styled toolbar offering spell check replacements for the
/// misspelled word under the cursor — upstream parity with
/// `shadcn_flutter`'s `SpellCheckSuggestionsToolbar`
/// (`menu/spell_check_suggestions_toolbar.dart`).
///
/// This is the registry replacement for the Material
/// `SpellCheckSuggestionsToolbar` and the Cupertino
/// `CupertinoSpellCheckSuggestionsToolbar` — it carries no dependency on
/// either library and renders through the registry [MenuPopup]/[MenuButton]
/// primitives.
///
/// It is the default for `TextField.spellCheckConfiguration`, and is used
/// automatically whenever a `SpellCheckConfiguration` is enabled on a field:
///
/// ```dart
/// TextField(
///   spellCheckConfiguration: const SpellCheckConfiguration(
///     spellCheckService: DefaultSpellCheckService(),
///   ),
/// );
/// ```
///
/// Adaptation note: upstream positions via its internal `ContextMenuPopup`
/// overlay; this port positions with a lightweight anchor-offset
/// [Stack]/[Positioned] around the same [MenuPopup] chrome, so it works
/// with the registry's `OverlayManager`/`PopoverController` architecture.
///
/// See also:
///  * `buildEditableTextContextMenu`, which builds the ordinary
///    cut/copy/paste context menu for a text field.
class SpellCheckSuggestionsToolbar extends StatelessWidget {
  /// Creates a spell check suggestions toolbar from explicit button items.
  ///
  /// [buttonItems] must not contain more than three items, mirroring the
  /// platform convention.
  const SpellCheckSuggestionsToolbar({
    super.key,
    required this.anchors,
    required this.buttonItems,
  }) : assert(buttonItems.length <= kMaxSpellCheckSuggestions);

  /// Creates a spell check suggestions toolbar for an [EditableText].
  ///
  /// Reads the misspelled span under the cursor from [editableTextState]
  /// and turns its suggestions into replacement buttons. If there is no
  /// misspelled span the toolbar builds to nothing.
  SpellCheckSuggestionsToolbar.editableText({
    super.key,
    required EditableTextState editableTextState,
  })  : buttonItems =
            buildButtonItems(editableTextState) ??
            const <ContextMenuButtonItem>[],
        anchors = editableTextState.contextMenuAnchors;

  /// Where to anchor the toolbar relative to the text field.
  final TextSelectionToolbarAnchors anchors;

  /// The replacement suggestions to display, at most three.
  final List<ContextMenuButtonItem> buttonItems;

  /// Builds the replacement buttons for the misspelled word under the
  /// cursor.
  ///
  /// Returns null when the cursor is not inside a misspelled span, which
  /// the callers treat as "render nothing". Returns a single disabled item
  /// when the word is misspelled but the spell check service has no
  /// suggestion for it.
  static List<ContextMenuButtonItem>? buildButtonItems(
    EditableTextState editableTextState,
  ) {
    final SuggestionSpan? spanAtCursorIndex = editableTextState
        .findSuggestionSpanAtCursorIndex(
          editableTextState.currentTextEditingValue.selection.baseOffset,
        );

    if (spanAtCursorIndex == null) {
      return null;
    }

    if (spanAtCursorIndex.suggestions.isEmpty) {
      return const <ContextMenuButtonItem>[
        ContextMenuButtonItem(
          onPressed: null,
          label: 'No suggestions available',
        ),
      ];
    }

    return <ContextMenuButtonItem>[
      for (final String suggestion
          in spanAtCursorIndex.suggestions.take(kMaxSpellCheckSuggestions))
        ContextMenuButtonItem(
          onPressed: () {
            if (!editableTextState.mounted) {
              return;
            }
            _replaceText(
              editableTextState,
              suggestion,
              spanAtCursorIndex.range,
            );
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

    // The caret has moved to the end of the replacement, which may sit
    // outside the visible region; scroll to it once renderEditable has laid
    // out again.
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
    final theme = Theme.of(context);
    final scaling = theme.scaling;
    final position = anchors.primaryAnchor + const Offset(8, -8) * scaling;
    return TextFieldTapRegion(
      child: Stack(
        children: [
          Positioned(
            left: position.dx,
            top: position.dy,
            child: MenuPopup(
              children: [
                for (final ContextMenuButtonItem buttonItem in buttonItems)
                  MenuButton(
                    enabled: buttonItem.onPressed != null,
                    onPressed: (context) {
                      buttonItem.onPressed?.call();
                    },
                    child: Text(buttonItem.label ?? ''),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
