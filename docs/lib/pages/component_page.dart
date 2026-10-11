// The component page template (spec §2.4, P7-D1 shadcn docs layout): one
// route for all 118 components.
//
// Title row + typeset description, the main demo card (the first named
// example), an install block, then typeset H2 sections: Usage (snippets),
// Examples (every remaining example as `### <Name>` + its own Preview |
// Code card), API Reference, Theme, and Accessibility (keyboard rows, hidden
// when empty). Prev/next pager at the bottom. Every fact comes from the
// generated data.
//
// The example cards live in `widgets/example_preview_card.dart` (P7-D1: one
// card per named example instead of P6-F4's single preview + Select).

import 'package:flutter/widgets.dart';

import '../generated/docs_api.dart';
import '../generated/docs_data.dart';
import '../generated/docs_tables.dart';
import '../routing/docs_nav.dart';
import '../ui/shadcn/components/badge/badge.dart';
import '../widgets/component_examples_section.dart';
import '../widgets/component_install_block.dart';
import '../widgets/component_preview_card.dart';
import '../widgets/component_sections.dart';
import '../widgets/docs_article.dart';
import '../widgets/docs_shell.dart';

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
          ComponentPreviewCard(componentId: widget.componentId),
          ComponentInstallBlock(componentId: widget.componentId),
          ComponentUsageSection(componentId: widget.componentId),
          ComponentExamplesSection(componentId: widget.componentId),
          ComponentApiSection(componentId: widget.componentId),
          if (_hasMembers(widget.componentId))
            ComponentMembersSection(componentId: widget.componentId),
          if (_hasThemeTable(widget.componentId))
            ComponentThemeSection(componentId: widget.componentId),
          if (_hasKeyboardRows(widget.componentId))
            ComponentAccessibilitySection(componentId: widget.componentId),
        ],
      ),
    );
  }

  static bool _hasMembers(String id) {
    return kApiTables[id]!.members.isNotEmpty;
  }

  static bool _hasThemeTable(String id) {
    final DocsThemeTable table = kThemeTables[id]!;
    return table.hasTheme && table.fields.isNotEmpty;
  }

  static bool _hasKeyboardRows(String id) {
    return (kKeyboardRows[id] ?? const <DocsKeyboardRow>[]).isNotEmpty;
  }
}
