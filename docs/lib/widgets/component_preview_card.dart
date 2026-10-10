// The component preview card (P6-F4): one named example at a time.
//
// A `Select` of example names (labels from codegen `kComponentPreviews`, first
// entry is the default) plus a per-preview light/dark toggle above the bounded
// stage, and the code teaser below it. The selection lives in `DocsState` so it
// survives navigation; the stage inherits the site theme (no nested default
// `ShadcnApp`/`ShadcnTheme`), so preset and mode switches re-theme it. The
// toggle wraps only the stage in the opposite brightness of the same preset
// document.
//
// Split out of `pages/component_page.dart` for the ~400-line rule.

import 'package:flutter/widgets.dart';

import '../generated/docs_previews.dart';
import '../generated/docs_snippets.dart';
import '../previews/component_previews.dart';
import '../routing/docs_router.dart';
import '../state/docs_state.dart';
import '../ui/shadcn/components/button/button.dart';
import '../ui/shadcn/components/select/select.dart';
import '../ui/shadcn/foundation/gap.dart';
import '../ui/shadcn/foundation/icons/lucide_icons.dart';
import '../ui/shadcn/theme/theme.dart';
import 'code_teaser.dart';
import 'docs_tokens.dart';
import 'preview_stage.dart';
import 'selectable_code.dart';

/// The preview card: example `Select` + brightness toggle + stage + teaser.
class ComponentPreviewCard extends StatelessWidget {
  /// Creates the card for [componentId].
  const ComponentPreviewCard({super.key, required this.componentId});

  /// The registry component id.
  final String componentId;

  @override
  Widget build(BuildContext context) {
    final DocsState state = DocsRouterScope.of(context).state;
    return ListenableBuilder(
      listenable: state,
      builder: (BuildContext context, Widget? _) {
        final List<String> names =
            kComponentPreviews[componentId] ?? const <String>[];
        final String selected =
            state.previewExampleFor(componentId) ??
            (names.isNotEmpty ? names.first : '');
        int index = names.indexOf(selected);
        if (index < 0) {
          index = 0;
        }
        final bool inverted = state.isPreviewInverted(componentId);
        final Brightness site = state.brightness;
        final Brightness stageBrightness = inverted
            ? (site == Brightness.dark ? Brightness.light : Brightness.dark)
            : site;
        final List<DocsSnippet> snippets =
            kDocsSnippets[componentId] ?? const <DocsSnippet>[];
        final Widget stage = PreviewStage(
          child: PreviewExampleLoader(
            componentId: componentId,
            exampleIndex: index,
          ),
        );
        return PreviewFrame(
          child: Column(
            children: <Widget>[
              // Always shown: the toggle matters even for single-example
              // components, and the Select appears when names > 1.
              PreviewExampleControls(
                componentId: componentId,
                names: names,
                selected: names.isNotEmpty ? names[index] : selected,
                stageBrightness: stageBrightness,
              ),
              if (inverted)
                ShadcnTheme(
                  data: state.themeModel.themeFor(stageBrightness),
                  child: stage,
                )
              else
                stage,
              if (snippets.isNotEmpty)
                CodeTeaser(
                  code: PreviewSnippetCode(snippet: snippets.first),
                  copyText: snippets.first.code,
                  language: snippets.first.language,
                ),
            ],
          ),
        );
      },
    );
  }
}

/// The row above the stage: the example `Select` plus the brightness toggle.
///
/// Stacks vertically on narrow phones instead of overflowing (the 375 px
/// article leaves ~295 px for this row; the 220 px Select plus the toggle do
/// not fit side by side).
class PreviewExampleControls extends StatelessWidget {
  /// Creates the controls row.
  const PreviewExampleControls({
    super.key,
    required this.componentId,
    required this.names,
    required this.selected,
    required this.stageBrightness,
  });

  /// The registry component id (selection + toggle live in `DocsState`).
  final String componentId;

  /// Example labels in declaration order.
  final List<String> names;

  /// The selected label.
  final String selected;

  /// The brightness the stage currently shows.
  final Brightness stageBrightness;

  @override
  Widget build(BuildContext context) {
    final DocsState state = DocsRouterScope.of(context).state;
    final bool inverted = state.isPreviewInverted(componentId);
    final bool multi = names.length > 1;
    final Widget select = multi
        ? SizedBox(
            width: 220,
            child: Select<String>(
              key: const ValueKey<String>('preview-example-select'),
              value: selected.isEmpty ? null : selected,
              onChanged: (String? value) {
                if (value != null) {
                  state.setPreviewExample(componentId, value);
                }
              },
              placeholder: Text(names.first, overflow: TextOverflow.ellipsis),
              itemBuilder: (BuildContext context, String value) =>
                  Text(value, overflow: TextOverflow.ellipsis),
              items: <Widget>[
                for (final String name in names)
                  SelectItem<String>(value: name, child: Text(name)),
              ],
            ),
          )
        : Text(
            names.isNotEmpty ? names.first : 'Preview',
            style: docsText(
              context,
              size: 13,
              weight: FontWeight.w500,
              color: ShadcnTheme.of(context).colors.mutedForeground,
            ),
            overflow: TextOverflow.ellipsis,
          );
    final Widget toggle = Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Button(
          key: const ValueKey<String>('preview-theme-toggle'),
          variant: ButtonVariant.outline,
          size: ButtonSize.sm,
          leading: Icon(
            stageBrightness == Brightness.dark
                ? LucideIcons.moon
                : LucideIcons.sun,
            size: 14,
          ),
          onPressed: () => state.togglePreviewInverted(componentId),
          child: Text(stageBrightness == Brightness.dark ? 'Dark' : 'Light'),
        ),
        if (inverted) const Gap(8),
        if (inverted)
          Text(
            'preview',
            style: docsText(
              context,
              size: 12,
              color: ShadcnTheme.of(context).colors.mutedForeground,
            ),
          ),
      ],
    );
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final double width = constraints.maxWidth;
          if (!width.isFinite || width >= 360) {
            return Row(
              children: <Widget>[
                if (multi) ...<Widget>[select, const Gap(12)] else
                  Expanded(child: select),
                const Spacer(),
                toggle,
              ],
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (multi) ...<Widget>[select, const Gap(8)] else select,
              Align(alignment: Alignment.centerRight, child: toggle),
            ],
          );
        },
      ),
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

/// The highlighted snippet inside the preview card's code teaser.
class PreviewSnippetCode extends StatelessWidget {
  /// Creates the code block for [snippet].
  const PreviewSnippetCode({super.key, required this.snippet});

  /// The README snippet (spans keep the syntax colours).
  final DocsSnippet snippet;

  @override
  Widget build(BuildContext context) {
    final DocsSiteColors site = DocsSiteColors.of(context);
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    final bool dark = site.codeSurface == const Color(0xFF161616);
    return Container(
      color: site.codeSurface,
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SelectableCode(
          child: Text.rich(
            TextSpan(
              children: snippet.spans(
                plain: theme.typography.mono.copyWith(
                  fontSize: 14,
                  height: 24.5 / 14,
                  color: dark
                      ? const Color(0xFFE5E5E5)
                      : const Color(0xFF262626),
                ),
                comment: theme.typography.mono.copyWith(
                  fontSize: 14,
                  height: 24.5 / 14,
                  color: site.codeNumber,
                ),
                keyword: theme.typography.mono.copyWith(
                  fontSize: 14,
                  height: 24.5 / 14,
                  color: const Color(0xFF79C0FF),
                ),
                string: theme.typography.mono.copyWith(
                  fontSize: 14,
                  height: 24.5 / 14,
                  color: const Color(0xFFA5D6FF),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
