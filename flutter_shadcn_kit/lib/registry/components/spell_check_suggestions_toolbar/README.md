# SpellCheckSuggestionsToolbar

A shadcn styled toolbar with the spell check replacements for the misspelled
word under an editable text cursor. Rows and surface come from the `menu`
component: up to three suggestion rows inside `MenuPopup`.

## When to use

Wire it from an `EditableText` that enables spell checking. The registry
`input` component does not enable spell check itself; use this toolbar when
an app opts into `EditableText`'s `spellCheckConfiguration` and needs a
widgets-only toolbar instead of the Material one.

## Snippets

```dart
// Inside an editable text toolbar builder:
SpellCheckSuggestionsToolbar.editableText(editableTextState: state);
```

```dart
// Explicit items (the same shape EditableText hands over):
SpellCheckSuggestionsToolbar(
  anchors: state.contextMenuAnchors,
  buttonItems: SpellCheckSuggestionsToolbar.buildButtonItems(state),
);
```

## API

| Member | Signature |
|---|---|
| `SpellCheckSuggestionsToolbar.editableText` | `({required EditableTextState editableTextState})` |
| `SpellCheckSuggestionsToolbar` | `({required TextSelectionToolbarAnchors anchors, required List<ContextMenuButtonItem> buttonItems})` — at most 3 items |
| `buildButtonItems` | `List<ContextMenuButtonItem> buildButtonItems(EditableTextState)` |
| `kMaxSpellCheckSuggestions` | `3` |

## Theme fields

None of its own. Suggestion rows resolve `MenuTheme` and the surface
resolves `MenuPopupTheme` (both owned by `menu`).

## Differences from old `spell_check_suggestions_toolbar`

- Material/Cupertino are gone (`TextFieldTapRegion` was and stays widgets).
- The two-old-module split (barrel + `_impl` + `part`) is one file.
- The no-suggestions row is back: `buildButtonItems` returns a disabled
  placeholder item and the toolbar labels it with
  `ShadcnLocalizations.spellCheckNoSuggestions` (`No suggestions`; English
  fallback because Flutter's ARBs have no equivalent).
- Rows are plain `MenuButton`s inside a `MenuGroup` (the old module relied on
  an ambient `MenuGroupData` it did not provide).
