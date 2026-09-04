# Asset Markdown Example

This document is loaded from **Flutter assets**.

## Inline formatting
- **Bold**
- *Italic*
- ~~Strikethrough~~
- `Inline code`

## Task list
- [x] Asset loading works
- [x] Custom parser renders markdown blocks
- [ ] Add app-specific styles

## Ordered and nested lists
1. First
2. Second
   - Nested A
   - Nested B

## Table
| Mode | Input shape | Best for |
| :-- | :-- | :-- |
| Character | 1 char per update | token-level simulation |
| Word | 1 word per update | readable chat style |
| Chunk | fixed text chunk | transport buffering |
| Part | section based | staged UI updates |

```dart
Markdown.asset(asset: 'assets/markdown/advanced_markdown.md')
```

> Asset markdown enables shipping docs and templates inside your app build.

[Open Flutter docs](https://flutter.dev)
