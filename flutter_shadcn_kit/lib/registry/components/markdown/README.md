# Markdown

Text-only markdown renderer with a shadcn theme, tap callbacks and a
widgets-only image preview overlay. This is the `markdown` display component;
the id stays `markdown` to match the component directory.

## When to use

- Rendering chat messages, docs or comments from a markdown string.
- Streaming LLM output together with `text_animate` (it shares the parser in
  `primitives/markdown_parser` and `computeStableMarkdownPrefixLength`).

## Snippets

```dart
const Markdown(data: '# Hello\n\nSome **bold** text.');
```

Links (open URLs yourself; taps only fire callbacks):

```dart
Markdown(
  data: 'Read the [docs](https://example.com).',
  onTapLink: (text, url) => launchUrl(Uri.parse(url)),
)
```

Themed:

```dart
ComponentTheme<MarkdownTheme>(
  data: const MarkdownTheme(linkColor: ThemedColor.ref(ColorRef.accent)),
  child: const Markdown(data: '[accent link](https://example.com)'),
)
```

## `Markdown` API

| Parameter | Type | Default | Notes |
|---|---|---|---|
| `data` | `String` | required | the markdown source (text only) |
| `selectable` | `bool` | `true` | wraps in a `SelectableRegion` with shadcn handles |
| `style` | `TextStyle?` | null | base body style; color falls back to `foreground` |
| `onTapLink` / `onTapLinkDetails` | callbacks | null | link taps; no automatic URL opening |
| `onTapImage` / `onTapHeading` / `onTapElement` | callbacks | null | image, heading and generic element taps |
| `blockBuilder` | `MarkdownBlockBuilder?` | null | per-block override; `details.buildDefault()` renders the default |
| `onDocumentReady` | `MarkdownDocumentReadyCallback?` | null | block/heading/image/table counts after parsing |
| `viewportStorageId` | `Object?` | null | scroll-position key when `shrinkWrap` is false |
| `shrinkWrap` | `bool` | `true` | `Column` when true, scrolling `ListView` when false |
| `htmlSanitizationStrategy` | `MarkdownHtmlSanitizationStrategy` | `stripDangerousHtml` | raw-HTML policy before parsing |
| `imagePreviewBehavior` | `MarkdownImagePreviewBehavior` | `dialog` | `none` disables the preview overlay |
| `imagePreviewBuilder` | `MarkdownImagePreviewBuilder?` | null | custom preview; `close` dismisses it |
| `imageBuilder` | `MarkdownImageWidgetBuilder?` | null | custom image widget for a URL/alt pair |
| `theme` | `MarkdownTheme?` | null | widget leg of the resolver |

## Theme resolution

`widget theme > ComponentTheme<MarkdownTheme> in tree > app overrides
in markdown_theme.dart > markdownDefaults`. Every color is a `ThemedColor`
token reference; style colors are ignored in favor of tokens. Geometry
(paddings, radii, indents, image bounds) is fixed at shadcn values.

## Supported syntax

Paragraphs, headings, unordered/ordered/task lists, quotes (nesting without
a depth limit), fenced and indented code, GFM tables, standalone images,
horizontal rules, inline emphasis/code/links/autolinks, reference-style
links (`[text][ref]`, `[text][]`, `[ref]` with `[ref]: url "title"`
definitions), GFM footnotes (`[^id]` markers with a trailing section), and
`<details><summary>` disclosures (rendered with the `collapsible`
component, collapsed by default). Footnote markers link to their section
via anchor scrolling; reference links resolve case-insensitively.

## Differences from old `markdown`

- Text source only: `Markdown.asset` / `Markdown.file` are gone, with them
  the `loading` / `errorBuilder` states. Read the file yourself (`rootBundle`
  or `File.readAsString`) and pass the string.
- `followLinks` is gone with the platform-channel URL opener (`MethodChannel`,
  `Process`, `dart:html` cannot be widgets-only). Open URLs in `onTapLink`.
- The editor pieces are gone: `MarkdownEditingBar`,
  `MarkdownEditingController`, `MarkdownEditingHelpers`, `MarkdownLivePreview`
  (zero importers outside this component; editing is a separate component's
  job under PLAN §4 rule 2).
- Dropped blocks: definition lists, math, raw HTML output (sanitized, then
  stripped). Inline images render as their alt text. Tables keep alignments
  but cells hold inline runs only. Reference and footnote definitions inside
  quote or details bodies are ignored (inline references still resolve).
  Footnote markers have no return backlink.
- Dropped theme knobs (fixed at shadcn consts in the renderer): quote/cell
  text styles (inherit body), paddings, radii, indents, image bounds.
- Dropped machinery: chunked progressive rendering (parses synchronously),
  `compute` isolate, static failed-image cache (now per-state),
  `MarkdownTheme.htmlDefaults` / `chatBubbleDefaults` statics (replaced by
  token-derived `markdownDefaults`), hardcoded `GeistMono` (now the ambient
  `fontMono`), hardcoded link blue (now the `primary` token), Material
  `Dialog` / `IconButton` / `TextButton` / `CircularProgressIndicator` /
  `Divider` / `SelectionArea` (widgets `showGeneralDialog`, `SelectableRegion`
  with shadcn handles, painted rule).
- `MarkdownTapElementKind` covers every rendered block; anchor scrolling
  keeps slug deduplication but no chunk warmup.
