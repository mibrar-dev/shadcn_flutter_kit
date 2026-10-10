// Collage display cards: buttons, install, tooltip, pages, table (P6-P1).
//
// Split from `collage_cards.dart` to keep every docs widget file under the
// ~400-line rule. Shares the [CollageCard] shell from that file.

import 'package:flutter/widgets.dart';

import '../generated/docs_data.dart';
import '../routing/docs_nav.dart';
import '../ui/shadcn/components/badge/badge.dart';
import '../ui/shadcn/components/button/button.dart';
import '../ui/shadcn/components/table/table.dart';
import '../ui/shadcn/components/tooltip/tooltip.dart';
import '../ui/shadcn/foundation/gap.dart';
import '../ui/shadcn/foundation/icons/lucide_icons.dart';
import '../ui/shadcn/theme/theme.dart';
import 'collage_cards.dart';
import 'copy_button.dart';
import 'docs_tokens.dart';

class CollageButtonsCard extends StatelessWidget {
  const CollageButtonsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return CollageCard(
      title: 'Buttons',
      children: <Widget>[
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: <Widget>[
            Button(
              size: ButtonSize.sm,
              trailing: const Icon(LucideIcons.arrowRight, size: 14),
              onPressed: () {},
              child: const Text('Button'),
            ),
            Button(
              variant: ButtonVariant.secondary,
              size: ButtonSize.sm,
              onPressed: () {},
              child: const Text('Secondary'),
            ),
            Button(
              variant: ButtonVariant.outline,
              size: ButtonSize.sm,
              onPressed: () {},
              child: const Text('Outline'),
            ),
          ],
        ),
        const Gap(12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: <Widget>[
            Button(
              variant: ButtonVariant.outline,
              size: ButtonSize.sm,
              onPressed: () {},
              child: const Text('Alert Dialog'),
            ),
            Button(
              variant: ButtonVariant.ghost,
              size: ButtonSize.sm,
              onPressed: () {},
              child: const Text('Button Group'),
            ),
          ],
        ),
        const Gap(16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: const <Widget>[
            Badge(variant: BadgeVariant.primary, child: Text('Badge')),
            Badge(variant: BadgeVariant.secondary, child: Text('Secondary')),
            Badge(variant: BadgeVariant.outline, child: Text('Outline')),
            Badge(
              variant: BadgeVariant.primary,
              showAsDot: true,
              child: SizedBox.shrink(),
            ),
          ],
        ),
      ],
    );
  }
}

class CollageInstallCard extends StatelessWidget {
  const CollageInstallCard({super.key});

  @override
  Widget build(BuildContext context) {
    final DocsSiteColors site = DocsSiteColors.of(context);
    final String install = kComponents
        .firstWhere((DocsComponent component) => component.id == 'button')
        .install;
    return CollageCard(
      title: 'Install',
      subtitle: 'One command copies the source in',
      children: <Widget>[
        DecoratedBox(
          decoration: BoxDecoration(
            color: site.codeSurface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    install,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: ShadcnTheme.of(
                      context,
                    ).typography.mono.copyWith(fontSize: 12.5),
                  ),
                ),
                CopyButton(text: install),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class CollageTooltipCard extends StatelessWidget {
  const CollageTooltipCard({super.key});

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return CollageCard(
      title: 'Tooltips',
      children: <Widget>[
        Tooltip(
          tooltip: (BuildContext context) => const Text('Adds the component'),
          child: Button(
            variant: ButtonVariant.outline,
            size: ButtonSize.sm,
            onPressed: collageNoop,
            child: const Text('Hover me'),
          ),
        ),
        const Gap(12),
        Text(
          'Accessible by default.',
          style: docsText(
            context,
            size: 12.5,
            color: theme.colors.mutedForeground,
          ),
        ),
      ],
    );
  }
}

class CollagePagesCard extends StatelessWidget {
  const CollagePagesCard({super.key});

  static const List<IconData> _icons = <IconData>[
    LucideIcons.fileText,
    LucideIcons.component,
    LucideIcons.palette,
    LucideIcons.terminal,
  ];

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    final List<DocsNavLink> links = kDocsSections.take(4).toList();
    return CollageCard(
      title: 'Pages',
      children: <Widget>[
        for (int i = 0; i < links.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: <Widget>[
                Icon(_icons[i], size: 14, color: theme.colors.mutedForeground),
                const Gap(8),
                Text(
                  links[i].label,
                  style: docsText(
                    context,
                    size: 13,
                    weight: FontWeight.w500,
                    color: theme.colors.cardForeground,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

/// The collage table card (spec §4 collage list includes `R:table`).
class CollageTableCard extends StatelessWidget {
  /// Creates the table card.
  const CollageTableCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const CollageCard(
      title: 'Table',
      subtitle: 'Rows, columns and widths from one widget',
      children: <Widget>[
        ShadcnTable(
          defaultColumnWidth: FlexTableSize(),
          rows: <ShadcnTableRow>[
            ShadcnTableHeader(
              cells: <ShadcnTableCell>[
                ShadcnTableCell(child: Text('Name')),
                ShadcnTableCell(child: Text('Role')),
                ShadcnTableCell(child: Text('Status')),
              ],
            ),
            ShadcnTableRow(
              cells: <ShadcnTableCell>[
                ShadcnTableCell(child: Text('Maya')),
                ShadcnTableCell(child: Text('Admin')),
                ShadcnTableCell(child: Text('Active')),
              ],
            ),
            ShadcnTableRow(
              cells: <ShadcnTableCell>[
                ShadcnTableCell(child: Text('Leo')),
                ShadcnTableCell(child: Text('Editor')),
                ShadcnTableCell(child: Text('Invited')),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
