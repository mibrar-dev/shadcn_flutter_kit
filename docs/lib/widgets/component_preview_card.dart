// The component page's main demo card (P7-D1): the first named example
// ("Default") in its own Preview | Code card.
//
// The remaining examples render below Usage in `ComponentExamplesSection` —
// one `### <Name>` + card each (the shadcn docs layout). Components without
// named examples (building blocks with a gallery preview class) keep a
// bare stage with no toolbar.
//
// The stage inherits the site theme (no nested default `ShadcnApp`/
// `ShadcnTheme`), so preset and mode switches re-theme it. The deferred
// chunk loads once per component and is shared by every card on the page.
//
// Split out of `pages/component_page.dart` for the ~400-line rule.

import 'package:flutter/widgets.dart';

import '../generated/docs_example_sources.dart';
import '../previews/component_previews.dart';
import '../ui/shadcn/theme/theme.dart';
import 'docs_tokens.dart';
import 'example_preview_card.dart';
import 'preview_stage.dart';

/// The main demo card: the first example of [componentId].
class ComponentPreviewCard extends StatelessWidget {
  /// Creates the card for [componentId].
  const ComponentPreviewCard({super.key, required this.componentId});

  /// The registry component id.
  final String componentId;

  @override
  Widget build(BuildContext context) {
    final List<DocsExampleSource> sources =
        kExampleSources[componentId] ?? const <DocsExampleSource>[];
    if (sources.isEmpty) {
      return PreviewFrame(
        child: PreviewStage(
          child: PreviewExampleLoader(
            componentId: componentId,
            exampleIndex: 0,
          ),
        ),
      );
    }
    return ExamplePreviewCard(
      componentId: componentId,
      exampleIndex: 0,
      source: sources.first,
      isMain: true,
    );
  }
}

/// Loads one deferred preview example and rebuilds when it arrives.
///
/// The future is cached per `(componentId, exampleIndex)` so theme switches
/// (which rebuild through `DocsState`) reuse the loaded widget and only
/// re-theme it instead of refetching the chunk.
class PreviewExampleLoader extends StatefulWidget {
  /// Creates the loader for one example.
  const PreviewExampleLoader({
    super.key,
    required this.componentId,
    required this.exampleIndex,
  });

  /// The registry component id.
  final String componentId;

  /// Index into the exported `const List<ComponentPreview>`.
  final int exampleIndex;

  @override
  State<PreviewExampleLoader> createState() => PreviewExampleLoaderState();
}

/// State of [PreviewExampleLoader] (public for the ~400-line rule: the
/// widget file stays small while the state class is discoverable).
class PreviewExampleLoaderState extends State<PreviewExampleLoader> {
  Future<Widget>? _future;
  String? _key;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _maybeLoad();
  }

  @override
  void didUpdateWidget(covariant PreviewExampleLoader oldWidget) {
    super.didUpdateWidget(oldWidget);
    _maybeLoad();
  }

  void _maybeLoad() {
    final String key = '${widget.componentId}@${widget.exampleIndex}';
    if (_key != key) {
      _key = key;
      _future = loadComponentPreview(widget.componentId, widget.exampleIndex);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: _future,
      builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
        if (snapshot.hasData) {
          return snapshot.data!;
        }
        if (snapshot.hasError) {
          return Text(
            'Preview failed to load',
            style: docsText(
              context,
              size: 13,
              color: ShadcnTheme.of(context).colors.mutedForeground,
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
