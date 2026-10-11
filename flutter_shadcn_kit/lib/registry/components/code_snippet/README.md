# CodeSnippet

Scrollable code block with optional top-right action buttons (copy, run).
The content renders in the ambient monospace small style on a bordered card
surface. Widgets-only; it imports no other component.

## When to use

- Displaying a command, config or code sample with actions.
- Read-only output blocks (logs, diffs use their own components).

## Snippets

Minimal:

```dart
const CodeSnippet(code: Text('flutter run -d chrome'));
```

With actions and bounds:

```dart
CodeSnippet(
  constraints: const BoxConstraints(maxWidth: 480, maxHeight: 200),
  actions: [
    Button(
      size: ButtonSize.sm,
      variant: ButtonVariant.ghost,
      onPressed: copy,
      child: const Text('Copy'),
    ),
  ],
  code: const Text('dart format .'),
);
```

## `CodeSnippet` API

| Parameter | Type | Default | Notes |
|---|---|---|---|
| `code` | `Widget` | required | code content, usually `Text` |
| `actions` | `List<Widget>` | `[]` | top-right buttons |
| `constraints` | `BoxConstraints?` | null | bounds of the snippet area |
| `theme` | `CodeSnippetTheme?` | null | widget-leg override |

## Differences from old `code_snippet`

- Stateless: the old state class held no state.
- The `gap` package spacer is the foundation `Gap`.
- The right padding stays wider (room for the actions row); border width
  scales with the ambient scaling as before.
