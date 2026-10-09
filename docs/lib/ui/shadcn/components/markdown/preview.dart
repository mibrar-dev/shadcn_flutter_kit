// Gallery preview for the `markdown` component: blocks, inline emphasis,
// lists, code, quotes, tables, images (via `imageBuilder`, so no network),
// reference links, footnotes, details disclosures, link taps, the dark
// palette and a themed override.
// Widgets-only; the docs app embeds [MarkdownPreview] directly.

import 'package:flutter/widgets.dart';

import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';
import 'markdown.dart';

const String _sample = '''
# Heading 1
## Heading 2

A paragraph with **bold**, *italic*, `code`, ~~strike~~ and a [link](https://example.com).

- unordered item one
- unordered item two
1. ordered item one
2. ordered item two
- [x] done task
- [ ] open task

> A quote with **emphasis**.
> Second line of the quote.

```dart
void main() => print('hello');
```

| Name | Value |
| :--- | ----: |
| alpha | 1 |
| beta | 2 |

![alt text](https://example.com/image.png "An image")

A [reference link][docs] and a footnote[^1].

[docs]: https://example.com "Docs"

[^1]: The footnote text.

<details>
<summary>More info</summary>
Hidden body text.
</details>

---
''';

/// Renders the markdown gallery.
class MarkdownPreview extends StatelessWidget {
  /// Creates the preview.
  const MarkdownPreview({super.key});

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return Directionality(
      textDirection: TextDirection.ltr,
      child: DefaultTextStyle(
        style: TextStyle(color: theme.colors.foreground, fontSize: 13),
        child: ColoredBox(
          color: theme.colors.background,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _section(
                  'Blocks',
                  Markdown(
                    data: _sample,
                    imageBuilder: (context, url, alt) => Container(
                      height: 72,
                      width: double.infinity,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: theme.colors.muted,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        alt,
                        style: TextStyle(
                          color: theme.colors.mutedForeground,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                _section(
                  'Link taps',
                  Markdown(
                    data: 'Read the [docs](https://example.com).',
                    onTapLink: (text, url) {},
                  ),
                ),
                const SizedBox(height: 24),
                _section(
                  'Themed override',
                  ComponentTheme<MarkdownTheme>(
                    data: const MarkdownTheme(blockSpacing: 12),
                    child: const Markdown(
                      data: '# Spaced\n\nFirst.\n\nSecond.',
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                _section(
                  'Dark',
                  ShadcnTheme(
                    data: const ShadcnThemeData(
                      colors: ShadcnColors.darkFallback,
                    ),
                    child: Markdown(
                      data: '# Dark\n\nBody with a [link](https://e.com).',
                      imageBuilder: (context, url, alt) =>
                          const SizedBox(height: 24),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _section(String title, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}
