# Multiple Choice

Selection scopes for choice trees: `MultipleChoice<T>` (one value) and
`MultipleAnswer<T>` (many values). Items select through the `Choice` protocol
and the scope reports the selection through `onChanged` (or a controller).

## When to use

- Radio-style option groups (`MultipleChoice`).
- Multi-select option groups, tag pickers, filter lists (`MultipleAnswer`).
- When item look is app-owned: the scope only carries selection state.

## Snippets

```dart
String? selected = 'sm';

MultipleChoice<String>(
  value: selected,
  onChanged: (value) => setState(() => selected = value),
  child: Wrap(
    children: <Widget>[
      ChoiceButton(value: 'sm'), // any widget that calls Choice.choose
      ChoiceButton(value: 'md'),
    ],
  ),
);
```

```dart
Set<String> selected = <String>{'a'};

MultipleAnswer<String>(
  value: selected,
  onChanged: (values) => setState(() => selected = values!.toSet()),
  child: Wrap(children: items),
);
```

A choice item is any widget that reads/writes the scope:

```dart
class ChoiceButton extends StatelessWidget {
  const ChoiceButton({super.key, required this.value});

  final String value;

  @override
  Widget build(BuildContext context) {
    final bool selected =
        Choice.getValue<String>(context)?.contains(value) ?? false;
    return GestureDetector(
      onTap: () => Choice.choose<String>(context, value),
      child: Text('$value${selected ? ' ✓' : ''}'),
    );
  }
}
```

## API

| Member | Type | Notes |
|---|---|---|
| `MultipleChoice<T>` | widget | `value`/`controller`/`onChanged`/`enabled`/`allowUnselect`/`theme` |
| `MultipleAnswer<T>` | widget | same, values are `Iterable<T>` |
| `MultipleChoiceController<T>` | `ValueNotifier<T?>` | controller mode |
| `MultipleAnswerController<T>` | `ValueNotifier<Iterable<T>?>` | controller mode |
| `Choice<T>` | mixin | `selectItem`, `value`; static `choose` / `getValue` |
| `MultipleChoiceTheme` | theme | `allowUnselect` (+ density/spacing/shadows) |

Modes: pass `value` + `onChanged`, or a `controller` (never both — asserted).

## Theme resolution

`widget theme > ComponentTheme<MultipleChoiceTheme> in tree > app overrides
(ComponentThemes) > kind defaults` (`false` for choice, `true` for answer),
per field.

## Differences from the old `multiple_choice`

- `ControlledMultipleChoice` / `ControlledMultipleAnswer` are gone; the two
  scopes handle both controlled and controller modes (assert guards).
- **Fixed:** the single-choice scope never moved off an existing selection
  (`if (widget.value != null && widget.value != item) return;`); selecting
  another item now replaces the value, as a radio group must.
- **Fixed:** `allowUnselect` read `widget.theme ?? tree`, so the app leg was
  dead and an override replaced the whole theme. It resolves through all four
  legs now.
- The two scopes notify their items when the scope rebuilds (`AlwaysUpdateData`
  on the scope state), so const item widgets still repaint on selection.
