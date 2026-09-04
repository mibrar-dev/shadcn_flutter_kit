# Markdown Feature Showcase

A comprehensive Markdown sample file for **real-world usage**, covering **CommonMark**, **GitHub Flavored Markdown (GFM)**, and a few widely used optional extensions.

> Notes:
> - This file is written to be practical, not toy-sized.
> - Some features are standard Markdown, some are CommonMark, and some are extensions commonly supported by GitHub, docs sites, and chat renderers.
> - Raw HTML, footnotes, math, and definition lists are not universally supported everywhere.

---

## Table of Contents

- [1. Paragraphs and line breaks](#1-paragraphs-and-line-breaks)
- [2. Headings](#2-headings)
- [3. Emphasis](#3-emphasis)
- [4. Blockquotes](#4-blockquotes)
- [5. Lists](#5-lists)
- [6. Task lists](#6-task-lists)
- [7. Links](#7-links)
- [8. Images](#8-images)
- [9. Code](#9-code)
- [10. Horizontal rules](#10-horizontal-rules)
- [11. Tables](#11-tables)
- [12. Escaping characters](#12-escaping-characters)
- [13. HTML in Markdown](#13-html-in-markdown)
- [14. Footnotes](#14-footnotes)
- [15. Definition lists](#15-definition-lists)
- [16. Autolinks and URLs](#16-autolinks-and-urls)
- [17. Inline combinations](#17-inline-combinations)
- [18. Nested structures](#18-nested-structures)
- [19. Entities and special characters](#19-entities-and-special-characters)
- [20. Details / summary blocks](#20-details--summary-blocks)
- [21. Math](#21-math)
- [22. Real-world README example](#22-real-world-readme-example)
- [23. Chat-oriented patterns](#23-chat-oriented-patterns)
- [24. Compatibility notes](#24-compatibility-notes)

---

## 1. Paragraphs and line breaks

This is a normal paragraph. Markdown treats consecutive lines as part of the same paragraph unless separated by a blank line.

This is another paragraph.

This line ends with an HTML break for a hard line break.<br>
This appears on the next line.

This line
may render as a soft break depending on the renderer.

---

## 2. Headings

# Heading 1
## Heading 2
### Heading 3
#### Heading 4
##### Heading 5
###### Heading 6

---

## 3. Emphasis

This text has *italic* formatting.<br>
This text also has _italic_ formatting.

This text has **bold** formatting.<br>
This text also has __bold__ formatting.

This text has ***bold italic*** formatting.<br>
This text has **bold and _nested italic_ inside**.

This text has ~~strikethrough~~ formatting.

You can also combine styles like **bold**, *italic*, ~~strike~~, and `inline code`.

---

## 4. Blockquotes

> This is a blockquote.
>
> It can span multiple lines.

> Nested quoting:
>
> > This is a nested blockquote.
> >
> > - It can contain lists
> > - And other Markdown content

> A quote with code:
>
> ```dart
> final greeting = "Hello from a quote";
> print(greeting);
> ```

---

## 5. Lists

### Unordered list

- Apple
- Banana
- Cherry

### Alternate unordered markers

* Item with asterisk
* Another item

+ Item with plus
+ Another plus item

### Ordered list

1. First step
2. Second step
3. Third step

### Nested lists

1. Build parser
   - Tokenize input
   - Build AST
   - Render widgets
2. Add features
   - Links
   - Code blocks
   - Tables

### Mixed nested list

- Parent item
  1. Ordered child
  2. Ordered child
     - Deep child
     - Another deep child
- Another parent item

---

## 6. Task lists

- [ ] Write parser
- [x] Add heading support
- [x] Add inline emphasis
- [ ] Add tables
- [ ] Add footnotes

Nested task list:

- [x] Phase 1
  - [x] Tokenizer
  - [x] AST
- [ ] Phase 2
  - [ ] Tables
  - [ ] Images

---

## 7. Links

### Inline link

[OpenAI](https://openai.com)

### Inline link with title

[OpenAI with title](https://openai.com "OpenAI Homepage")

### Reference-style link

This project uses [CommonMark][commonmark-site].

[commonmark-site]: https://commonmark.org

### Collapsed reference link

Visit [GitHub][] for more examples.

[GitHub]: https://github.com

### Angle-bracket autolink

<https://example.com>

### Email autolink

<hello@example.com>

### Relative link

[Local section link](#22-real-world-readme-example)

---

## 8. Images

### Inline image

![Sample placeholder image](https://via.placeholder.com/320x120 "Placeholder")

### Reference-style image

![Reference image][placeholder-image]

[placeholder-image]: https://via.placeholder.com/200 "Reference Placeholder"

> Note: Image rendering depends on the host app. Some chat renderers disable remote images.

---

## 9. Code

### Inline code

Use `MarkdownParser.parse()` to produce an AST.

### Fenced code block

```dart
class MarkdownParser {
  const MarkdownParser();

  DocumentNode parse(String source) {
    // tokenize -> parse -> return AST
    throw UnimplementedError();
  }
}
```

### Fenced code block with another language

```json
{
  "type": "heading",
  "level": 2,
  "children": [
    { "type": "text", "value": "Hello Markdown" }
  ]
}
```

### Indented code block

    This is an indented code block.
    It is created with four leading spaces.
    Not all users prefer this style, but it is valid.

### Code fence with backticks inside

````markdown
```dart
print("Hello");
```
````

---

## 10. Horizontal rules

---

***

___

---

## 11. Tables

| Feature | Standard | Commonly Supported |
|---------|----------|--------------------|
| Headings | Yes | Yes |
| Tables | No | Yes (GFM) |
| Task lists | No | Yes (GFM) |
| Footnotes | No | Sometimes |
| Math | No | Sometimes |

### Alignment

| Left | Center | Right |
|:-----|:------:|------:|
| a    |   b    |     c |
| one  |  two   | three |

### Markdown inside tables

| Syntax | Example |
|--------|---------|
| Bold | **bold** |
| Italic | *italic* |
| Code | `code` |
| Link | [Example](https://example.com) |

> Some renderers have limited support for complex blocks inside tables.

---

## 12. Escaping characters

Use a backslash to escape formatting characters:

\*not italic\*<br>
\_not italic\_<br>
\# not a heading<br>
\[not a link\](https://example.com)<br>
\`not code\`

Escaping pipe characters inside tables can matter: \|

---

## 13. HTML in Markdown

Some renderers allow raw HTML:

<div>
  <strong>Bold via HTML</strong><br>
  <em>Italic via HTML</em>
</div>

Inline HTML example: This has <kbd>Ctrl</kbd> + <kbd>C</kbd>.

A custom line break with HTML:<br>
Next line after explicit HTML break.

> Security note: many Markdown renderers sanitize or disable HTML.

---

## 14. Footnotes

Here is a statement with a footnote.[^1]

You can also reuse the same footnote reference.[^1]

A second footnote goes here.[^long-note]

[^1]: This is a short footnote.
[^long-note]: This is a longer footnote that can contain more text, including **formatting**, `code`, and even multiple sentences.

---

## 15. Definition lists

Term 1
: Definition for term 1

Term 2
: First definition for term 2
: Second definition for term 2

> Definition lists are not part of core CommonMark, but some parsers support them.

---

## 16. Autolinks and URLs

Plain URL in text: https://example.org/docs

Wrapped URL: <https://example.org/docs>

Email address: support@example.org

> Some renderers automatically convert plain URLs and email addresses into clickable links.

---

## 17. Inline combinations

A sentence with **bold**, *italic*, ~~strikethrough~~, `code`, and a [link](https://example.com).

Nested emphasis example: **This has _italic inside bold_ text**.

Another nested example: *This has **bold inside italic** text*.

Complex example: **bold `inline code` and [a link](https://example.com)**.

---

## 18. Nested structures

> Quote level 1
>
> - Item A
> - Item B
>   1. Step one
>   2. Step two
>
> ```bash
> echo "nested code block"
> ```
>
> Final line of the quote.

1. Ordered item
   > Blockquote inside a list item
   >
   > With multiple lines.

   ```dart
   void main() {
     print("code inside a list item");
   }
   ```

2. Second ordered item

---

## 19. Entities and special characters

HTML entities:

- `&amp;` renders as &amp;
- `&lt;` renders as &lt;
- `&gt;` renders as &gt;
- `&copy;` renders as &copy;
- `&mdash;` renders as &mdash;

Literal characters:

- Less than: <
- Greater than: >
- Ampersand: &

---

## 20. Details / summary blocks

<details>
  <summary>Click to expand</summary>

  This content is hidden by default in renderers that support HTML details blocks.

  It can contain:

  - Lists
  - **Formatting**
  - `Code`

</details>

---

## 21. Math

Inline math example: $E = mc^2$

Block math example:

$$
\int_0^1 x^2 \, dx = \frac{1}{3}
$$

> Math is not part of standard Markdown. It is supported by some renderers, usually with LaTeX-style syntax.

---

## 22. Real-world README example

# flutter_markdown_widget

A zero-dependency Markdown widget for Flutter chat and document UIs.

## Features

- CommonMark-style parsing
- GFM tables
- Task lists
- Link taps
- Image rendering hooks
- Syntax-highlight-ready code block API
- AST-based architecture
- Selectable text support

## Installation

```bash
flutter pub add flutter_markdown_widget
```

## Usage

````dart
MarkdownView(
  data: '''
# Hello

This is **Markdown** with a [link](https://example.com).

- [x] Tasks
- [ ] More tasks

```dart
print("Hello");
```
''',
)
````

## Supported syntax

| Category | Supported |
|----------|-----------|
| Headings | Yes |
| Lists | Yes |
| Tables | Yes |
| Task lists | Yes |
| Footnotes | Planned |

## Roadmap

- [x] Parser
- [x] Inline spans
- [x] Block nodes
- [ ] Footnotes
- [ ] HTML sanitization strategy
- [ ] Markdown editing helpers

## License

MIT

---

## 23. Chat-oriented patterns

These are common in chat apps, but not all are official Markdown.

### Mentions

@ibrar please review this.

### Hashtags

#flutter #markdown #chatui

### Emoji shortcodes

:smile: :rocket: :fire:

> Emoji shortcodes require a mapping layer. They are not part of standard Markdown.

### Bare issue or PR references

#123

### User-style references

@team/backend

### Mixed chat message sample

**Ibrar** shared an update:

> Parser v1 is done. Please review the docs at [spec.md](https://example.com/spec).

Checklist:
- [x] Blocks
- [x] Inlines
- [ ] Tables in chat bubbles
- [ ] Rich image preview

Code:
```dart
final message = MarkdownMessage(
  author: "@ibrar",
  body: "Parser is ready 🚀",
);
```

---

## 24. Compatibility notes

### Usually safe across most Markdown renderers

- Paragraphs
- Headings
- Bold / italic
- Blockquotes
- Ordered and unordered lists
- Inline code
- Fenced code blocks
- Links
- Horizontal rules

### Common in GitHub Flavored Markdown

- Tables
- Task lists
- Strikethrough
- Autolink-style behavior

### Optional / renderer-specific

- Raw HTML
- Footnotes
- Definition lists
- Math
- Mentions
- Emoji shortcodes
- Details blocks

---

## Final parser test paragraph

Here is one final realistic paragraph mixing multiple features together: **Flutter Markdown Widget** aims to support *real-world documentation*, `inline code`, clickable [links](https://example.com), GFM task lists, tables, and nested structures. It should also gracefully handle escaped text like \*literal asterisks\*, raw HTML such as <kbd>Cmd</kbd> + <kbd>K</kbd>, and optional features like footnotes.[^1]
