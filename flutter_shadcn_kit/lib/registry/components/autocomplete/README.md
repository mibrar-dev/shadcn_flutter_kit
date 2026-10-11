# AutoComplete

A suggestion list for a text field: an `InputFeature` that turns the field
text into an anchored popover with keyboard navigation, three replacement
modes and a themed row list. Widgets-only; installable next to `input`.

## When to use

- A text field that completes from a known list (fruit, country, tag).
- A search box that shows matching results as the user types.

Use `command` for a full palette with categories and actions; use a plain
`Input` with no feature when there is nothing to complete.

## Snippets

```dart
Input(
  hintText: 'Fruit',
  features: <InputFeature>[
    AutoCompleteFeature(suggestions: (query) => fruits(query)),
  ],
);
```

Every mode, in one field:

```dart
Input(
  features: <InputFeature>[
    AutoCompleteFeature(
      suggestions: (query) => _filter(query),
      mode: AutoCompleteMode.replaceWord, // append | replaceWord | replaceAll
      completer: (suggestion) => '$suggestion ', // add a trailing space
      onSuggestionSelected: (value) => print(value),
    ),
  ],
);
```

A fully custom row:

```dart
AutoCompleteFeature(
  suggestions: (query) => _filter(query),
  itemBuilder: (context, suggestion, highlighted) => Text(
    suggestion,
    style: TextStyle(fontWeight: highlighted ? FontWeight.w600 : FontWeight.w400),
  ),
)
```

## `AutoCompleteFeature` API

| Parameter | Type | Default | Notes |
|---|---|---|---|
| `suggestions` | `SuggestionBuilder` | required | `FutureOr<Iterable<String>> Function(String query)`; a late answer for a stale query is dropped |
| `mode` | `AutoCompleteMode?` | null | null = `AutoCompleteTheme.mode` = `replaceWord` |
| `completer` | `AutoCompleteCompleter` | identity | post-processes the suggestion before it is written |
| `onSuggestionSelected` | `ValueChanged<String>?` | null | called after the field text changed |
| `itemBuilder` | `SuggestionRowBuilder?` | null | null renders the shadcn row (highlighted text) |
| `theme` | `AutoCompleteTheme?` | null | widget leg of the resolver |

The list opens while typing and closes when the query yields nothing. The field
keeps the focus, so the popover never takes it.

## Keyboard

| Key | Effect |
|---|---|
| ArrowDown / ArrowUp | move the highlight (wraps) |
| Enter | apply the highlighted suggestion |
| Escape | close the list |

Tab is deliberately *not* bound: the old widget used it to accept, which
trapped focus in the field.

## Theme resolution

`widget theme > ComponentTheme<AutoCompleteTheme> in tree > app overrides
(autocomplete_theme.dart) > autocompleteDefaults`, merged per field and per
state.

| `AutoCompleteTheme` field | Default |
|---|---|
| `mode` | `replaceWord` |
| `popoverWidthConstraint` | `anchorFixedSize` (matches the field) |
| `popoverAnchorAlignment` / `popoverAlignment` | `bottomStart` / `topStart` |
| `containerBackground` / `containerForeground` | `popover` / `popoverForeground` |
| `containerBorderColor` / `containerBorderWidth` | `border` / 1 |
| `containerPadding` | 4 all round (shadcn `p-1`) |
| `itemBackground` / `itemForeground` | `accent` / `accentForeground` on hover, press and highlight |
| `itemPadding` | 8 x 6 (shadcn `px-2 py-1.5`) |
| `itemTextStyle` | `text-sm` (14) |
| `maxHeight` | 240 (shadcn `max-h-60`) |

## Differences from the old `form/autocomplete`

- The `AutoComplete` wrapper widget is deleted. It wrapped an opaque `child`
  and re-declared a field surface the `input` component owns; the feature is
  the whole public surface (P3 design I2).
- `AutoCompleteMode` replaces both drifted old copies (one was a bare `enum`
  line with no docs). One documented enum, owned here; `input` keeps only the
  generic `InputAutoCompleteFeature` slot.
- `AutoCompleteTheme.overlayConfiguration` and `.adaptiveOverlay` are deleted.
  Both were `@Deprecated`, stored for parity with an architecture that does not
  exist, and no code path could honour them.
- The `Listenable.merge` + `ValueNotifier` pair is gone: the suggestion list and
  the highlight index live in a per-field slot that the field disposes.

Fixed (not ported):

- The popover content resolved `Theme.of` from inside the overlay, so the theme
  froze at show time. It resolves live now, like the dialog barrier.
- The keyboard map hung off `ListenableBuilder` + `FocusableActionDetector`,
  which is not in the key-event path of an `EditableText`; the arrow keys never
  reached it and the accept action was unreachable from the keyboard. The
  feature now contributes `Shortcuts`/`Actions` through the feature contract.
- `AutoCompleteMode.append` appended at the end of the text even when the caret
  sat in the middle, so the caret jumped. It inserts at the caret now.
- The list opened as soon as the parent handed over a non-empty suggestion list,
  before the user typed anything. It is driven by the query now, and the feature
  also queries when the field takes focus (the new `InputFeature.onFocusGained`
  hook), so a field seeded with text completes too.
- A dismissed list kept its highlight, so Enter applied a row the user could no
  longer see. Closing clears the highlight now.

## Reuse

`applyAutoCompleteSuggestion(controller, text, mode)` is public, so a host that
owns its own field (or the `chip_input` component) can reuse the same
append / replace-word / replace-all surgery.