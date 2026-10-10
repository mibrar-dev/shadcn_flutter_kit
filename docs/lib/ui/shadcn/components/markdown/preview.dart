// Named examples for the `markdown` component (P6-F3 preview contract).
//
// One focused demo per example; the first entry is the default. The fixed
// width is inherent: tables and images need a bounded box. Images render
// through `imageBuilder` (a local placeholder), so no network is touched.

import 'package:flutter/widgets.dart';

import '../../foundation/component_preview.dart';
import '../../theme/theme.dart';
import 'markdown.dart';

const String _sample = '''
## Release notes

Build 482 ships **faster cold start** and a *smaller bundle*.

- faster cold start
- smaller bundle

> Quoted from the changelog.

![build graph](https://example.com/graph.png "Build graph")
''';

/// Headings, emphasis, a list, a quote and a local image placeholder.
Widget _default(BuildContext context) {
  final ShadcnThemeData theme = ShadcnTheme.of(context);
  return SizedBox(
    width: 320,
    child: Markdown(
      data: _sample,
      imageBuilder: (imageContext, url, alt) => SizedBox(
        height: 64,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: theme.colors.muted,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
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
    ),
  );
}

/// A mid-stream snapshot: only the stable prefix parses, followed by the
/// streaming cursor. No timers; the settled text is derived with
/// `computeStableMarkdownPrefixLength`, the helper the streaming
/// `text_animate` component shares with this parser.
const String _streamSource = '''
Drafting the release notes:

- faster cold start
- smaller bundle

```dart
void main() => print(''';

Widget _streamingTail(BuildContext context) {
  final String settled = _streamSource.substring(
    0,
    computeStableMarkdownPrefixLength(_streamSource),
  );
  final ShadcnThemeData theme = ShadcnTheme.of(context);
  return SizedBox(
    width: 320,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Markdown(data: settled),
        Text('▍', style: TextStyle(color: theme.colors.primary)),
      ],
    ),
  );
}

/// Named docs examples for `markdown`; the first entry is the default.
const List<ComponentPreview> markdownPreviews = <ComponentPreview>[
  ComponentPreview('Default', _default),
  ComponentPreview('Streaming tail', _streamingTail),
];
