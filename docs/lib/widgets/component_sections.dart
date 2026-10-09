// The content sections for component pages (spec §2.4): Usage (README
// snippets), API Reference (constructor/function params), Theme (theme
// fields), and Accessibility (keyboard rows, hidden when empty). Every fact
// comes from the generated data.

import 'package:flutter/widgets.dart';

import '../generated/docs_api.dart';
import '../generated/docs_snippets.dart';
import '../generated/docs_tables.dart';
import '../ui/shadcn/components/button/button.dart';
import '../ui/shadcn/foundation/gap.dart';
import '../ui/shadcn/theme/theme.dart';
import 'copy_button.dart';
import 'docs_tokens.dart';
import 'heading_anchor.dart';
import 'typeset.dart';
import 'typeset_tables.dart';

/// The Usage section: README snippets as code figures.
class ComponentUsageSection extends StatelessWidget {
  /// Creates the section for [componentId].
  const ComponentUsageSection({super.key, required this.componentId});

  final String componentId;

  @override
  Widget build(BuildContext context) {
    final List<DocsSnippet> snippets =
        kDocsSnippets[componentId] ?? const <DocsSnippet>[];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const HeadingAnchor(id: 'usage', title: 'Usage'),
        const TypesetParagraph(
          'Install the component, then use it in your widget tree. The '
          'examples below are extracted from the component README.',
        ),
        for (int i = 0; i < snippets.length; i++) ...<Widget>[
          _SnippetBlock(snippet: snippets[i]),
        ],
      ],
    );
  }
}

class _SnippetBlock extends StatelessWidget {
  const _SnippetBlock({required this.snippet});

  final DocsSnippet snippet;

  @override
  Widget build(BuildContext context) {
    final DocsSiteColors site = DocsSiteColors.of(context);
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    final bool dark = site.codeSurface == const Color(0xFF161616);
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Container(
        decoration: BoxDecoration(
          color: site.codeSurface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: theme.colors.border.withValues(alpha: 0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
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
            CopyButton(
              text: snippet.code,
              variant: ButtonVariant.ghost,
              size: ButtonSize.sm,
            ),
          ],
        ),
      ),
    );
  }
}

/// The API Reference section: constructor/function params as a typeset table.
class ComponentApiSection extends StatelessWidget {
  /// Creates the section for [componentId].
  const ComponentApiSection({super.key, required this.componentId});

  final String componentId;

  @override
  Widget build(BuildContext context) {
    final DocsApiTable table = kApiTables[componentId]!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const HeadingAnchor(id: 'api-reference', title: 'API Reference'),
        if (table.hasApiTable) ...<Widget>[
          if (table.summary != null) TypesetParagraph(table.summary!),
          const Gap(16),
          TypesetTable(
            headers: const <String>[
              'Parameter',
              'Type',
              'Default',
              'Description',
            ],
            rows: <TypesetRow>[
              for (final DocsApiParam param in table.params)
                TypesetRow(<TypesetCell>[
                  TypesetCell(text: param.name, mono: true),
                  TypesetCell(text: param.type, mono: true),
                  TypesetCell(text: param.defaultValue ?? '—'),
                  TypesetCell(text: param.doc ?? ''),
                ]),
            ],
          ),
        ] else
          const TypesetParagraph(
            'This component has no constructor API table.',
          ),
      ],
    );
  }
}

/// The Members section: the declared static methods, factories, constants and
/// functions of a static/factory-first component.
///
/// The rows come from the generated `table.members` list (the codegen reads the
/// manifest's `api.methods` / `api.constants` / `api.functions` entries), so
/// components like `formatter`, `anchor`, `overlay_configuration` and `color`
/// show their real entry points instead of an empty parameter table.
class ComponentMembersSection extends StatelessWidget {
  /// Creates the section for [componentId].
  const ComponentMembersSection({super.key, required this.componentId});

  /// The registry component id.
  final String componentId;

  @override
  Widget build(BuildContext context) {
    final DocsApiTable table = kApiTables[componentId]!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const HeadingAnchor(id: 'members', title: 'Members'),
        TypesetParagraph(
          '${table.members.length} declared '
          '${table.members.length == 1 ? 'entry point' : 'entry points'} on '
          '${table.symbol}.',
        ),
        const Gap(16),
        TypesetTable(
          headers: const <String>[
            'Member',
            'Kind',
            'Parameters',
            'Description',
          ],
          rows: <TypesetRow>[
            for (final DocsApiMember member in table.members)
              TypesetRow(<TypesetCell>[
                TypesetCell(text: member.name, mono: true),
                TypesetCell(text: _kindLabel(member)),
                TypesetCell(
                  text: member.params.isEmpty
                      ? '—'
                      : member.params
                            .map(
                              (DocsApiParam param) =>
                                  '${param.name}${param.isRequired ? '' : '?'}',
                            )
                            .join(', '),
                  mono: true,
                ),
                TypesetCell(text: member.doc ?? ''),
              ]),
          ],
        ),
      ],
    );
  }

  static String _kindLabel(DocsApiMember member) {
    final String kind = member.kind;
    return member.isStatic && kind != 'constructor' ? 'static $kind' : kind;
  }
}

/// The Theme section: theme fields as a typeset table.
class ComponentThemeSection extends StatelessWidget {
  /// Creates the section for [componentId].
  const ComponentThemeSection({super.key, required this.componentId});

  final String componentId;

  @override
  Widget build(BuildContext context) {
    final DocsThemeTable table = kThemeTables[componentId]!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const HeadingAnchor(id: 'theme', title: 'Theme'),
        TypesetParagraph(
          'The ${table.themeClass} fields resolved by the theme layer. '
          'User-owned ${table.userFile} is never overwritten by CLI updates.',
        ),
        const Gap(16),
        TypesetTable(
          headers: const <String>['Field', 'Type', 'Description'],
          rows: <TypesetRow>[
            for (final DocsThemeField field in table.fields)
              TypesetRow(<TypesetCell>[
                TypesetCell(text: field.name, mono: true),
                TypesetCell(text: field.type, mono: true),
                TypesetCell(text: field.description),
              ]),
          ],
        ),
      ],
    );
  }
}

/// The Accessibility section: keyboard rows as a typeset table.
class ComponentAccessibilitySection extends StatelessWidget {
  /// Creates the section for [componentId].
  const ComponentAccessibilitySection({super.key, required this.componentId});

  final String componentId;

  @override
  Widget build(BuildContext context) {
    final List<DocsKeyboardRow> rows = kKeyboardRows[componentId]!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const HeadingAnchor(id: 'accessibility', title: 'Accessibility'),
        const Gap(16),
        TypesetTable(
          headers: const <String>['Key', 'Action'],
          rows: <TypesetRow>[
            for (final DocsKeyboardRow row in rows)
              TypesetRow(<TypesetCell>[
                TypesetCell(text: row.keys, mono: true),
                TypesetCell(text: row.action),
              ]),
          ],
        ),
      ],
    );
  }
}
