// The component page template (spec §2.4): one route for all 118 components.
// Title row + typeset description, a live preview card (deferred preview.dart),
// an install block, then typeset H2 sections: Usage (snippets), API
// Reference, Theme, and Accessibility (keyboard rows, hidden when empty).
// Prev/next pager at the bottom. Every fact comes from the generated data.

import 'package:flutter/widgets.dart';

import '../generated/docs_api.dart';
import '../generated/docs_data.dart';
import '../generated/docs_snippets.dart';
import '../generated/docs_tables.dart';
import '../previews/component_previews.dart';
import '../routing/docs_nav.dart';
import '../ui/shadcn/components/badge/badge.dart';
import '../ui/shadcn/theme/theme.dart';
import '../widgets/code_teaser.dart';
import '../widgets/component_install_block.dart';
import '../widgets/component_sections.dart';
import '../widgets/docs_article.dart';
import '../widgets/docs_shell.dart';
import '../widgets/docs_tokens.dart';
import '../widgets/preview_stage.dart';

/// `/docs/components/<id>` — the component template.
class ComponentPage extends StatefulWidget {
  /// Creates the page for [componentId].
  const ComponentPage({super.key, required this.componentId});

  /// The registry component id.
  final String componentId;

  @override
  State<ComponentPage> createState() => _ComponentPageState();
}

class _ComponentPageState extends State<ComponentPage> {
  Widget? _preview;

  @override
  void initState() {
    super.initState();
    _loadPreview();
  }

  Future<void> _loadPreview() async {
    final Widget preview = await loadComponentPreview(widget.componentId);
    if (mounted) {
      setState(() => _preview = preview);
    }
  }

  @override
  Widget build(BuildContext context) {
    final DocsComponent component = kComponents.firstWhere(
      (DocsComponent c) => c.id == widget.componentId,
    );
    final ({String? previousId, String? nextId}) neighbors = componentNeighbors(
      widget.componentId,
    );
    return DocsLayout(
      child: DocsArticle(
        title: component.name,
        description: component.description,
        previous: neighbors.previousId != null
            ? DocsNavLink(
                label: kComponentLinks
                    .firstWhere(
                      (DocsComponentLink l) => l.id == neighbors.previousId,
                    )
                    .name,
                location: '/docs/components/${neighbors.previousId}',
              )
            : null,
        next: neighbors.nextId != null
            ? DocsNavLink(
                label: kComponentLinks
                    .firstWhere(
                      (DocsComponentLink l) => l.id == neighbors.nextId,
                    )
                    .name,
                location: '/docs/components/${neighbors.nextId}',
              )
            : null,
        titleActions: <Widget>[
          Badge(
            variant: BadgeVariant.secondary,
            child: Text('${component.fileCount} files'),
          ),
          Badge(
            variant: BadgeVariant.outline,
            child: Text(component.stability),
          ),
        ],
        children: <Widget>[
          _PreviewCard(componentId: widget.componentId, preview: _preview),
          ComponentInstallBlock(componentId: widget.componentId),
          ComponentUsageSection(componentId: widget.componentId),
          ComponentApiSection(componentId: widget.componentId),
          if (_hasThemeTable(widget.componentId))
            ComponentThemeSection(componentId: widget.componentId),
          if (_hasKeyboardRows(widget.componentId))
            ComponentAccessibilitySection(componentId: widget.componentId),
        ],
      ),
    );
  }

  static bool _hasThemeTable(String id) {
    final DocsThemeTable table = kThemeTables[id]!;
    return table.hasTheme && table.fields.isNotEmpty;
  }

  static bool _hasKeyboardRows(String id) {
    return (kKeyboardRows[id] ?? const <DocsKeyboardRow>[]).isNotEmpty;
  }
}

// ---------------------------------------------------------------------------
// Preview card
// ---------------------------------------------------------------------------

class _PreviewCard extends StatelessWidget {
  const _PreviewCard({required this.componentId, required this.preview});

  final String componentId;
  final Widget? preview;

  @override
  Widget build(BuildContext context) {
    final DocsComponent component = kComponents.firstWhere(
      (DocsComponent c) => c.id == componentId,
    );
    final List<DocsSnippet> snippets =
        kDocsSnippets[componentId] ?? const <DocsSnippet>[];
    return PreviewFrame(
      child: Column(
        children: <Widget>[
          PreviewStage(child: preview),
          if (preview != null && snippets.isNotEmpty)
            CodeTeaser(
              code: _SnippetCode(snippet: snippets.first),
              copyText: component.install,
            ),
        ],
      ),
    );
  }
}

class _SnippetCode extends StatelessWidget {
  const _SnippetCode({required this.snippet});

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
        child: Text.rich(
          TextSpan(
            children: snippet.spans(
              plain: theme.typography.mono.copyWith(
                fontSize: 14,
                height: 24.5 / 14,
                color: dark ? const Color(0xFFE5E5E5) : const Color(0xFF262626),
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
    );
  }
}
