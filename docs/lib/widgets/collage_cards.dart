// The landing collage card set (spec §2.1): the individual live registry
// compositions used by [DocsCollage]. Split from `collage.dart` to keep both
// files under the ~400-line rule.

import 'package:flutter/widgets.dart';

import '../generated/docs_data.dart';
import '../routing/docs_nav.dart';
import '../ui/shadcn/components/badge/badge.dart';
import '../ui/shadcn/components/button/button.dart';
import '../ui/shadcn/components/card/card.dart';
import '../ui/shadcn/components/input/input.dart';
import '../ui/shadcn/components/radio_group/radio_group.dart';
import '../ui/shadcn/components/switch/switch.dart';
import '../ui/shadcn/components/table/table.dart';
import '../ui/shadcn/components/tabs/tabs.dart';
import '../ui/shadcn/components/tooltip/tooltip.dart';
import '../ui/shadcn/foundation/gap.dart';
import '../ui/shadcn/foundation/icons/lucide_icons.dart';
import '../ui/shadcn/theme/color_tokens.dart';
import '../ui/shadcn/theme/theme.dart';
import 'copy_button.dart';
import 'docs_tokens.dart';

/// Base card: 24 px radius, card fill, `shadow-sm` + 5 % foreground ring.
/// The shared collage card shell (24 px radius, card fill, soft ring).
class CollageCard extends StatelessWidget {
  const CollageCard({
    super.key,
    this.title,
    this.subtitle,
    required this.children,
  });

  final String? title;
  final String? subtitle;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return Card(
      padding: const EdgeInsets.all(20),
      background: ThemedColor.ref(ColorRef.card),
      borderColor: ThemedColor.value(
        theme.colors.foreground.withValues(alpha: 0.05),
      ),
      borderWidth: 1,
      borderRadius: BorderRadius.circular(24),
      shadows: theme.tokens.shadows.shadowSm,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (title != null)
            Text(
              title!,
              style: docsText(
                context,
                size: 16,
                weight: FontWeight.w600,
                color: theme.colors.cardForeground,
              ),
            ),
          if (subtitle != null) ...<Widget>[
            const Gap(4),
            Text(
              subtitle!,
              style: docsText(
                context,
                size: 14,
                height: 1.4,
                color: theme.colors.mutedForeground,
              ),
            ),
          ],
          if (title != null || subtitle != null) const Gap(12),
          ...children,
        ],
      ),
    );
  }
}

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

class CollageInputsCard extends StatelessWidget {
  const CollageInputsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const CollageCard(
      children: <Widget>[
        Input(hintText: 'Name'),
        Gap(12),
        Input(hintText: 'Message', maxLines: 3),
      ],
    );
  }
}

class CollageGoalCard extends StatelessWidget {
  const CollageGoalCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const CollageCard(
      title: 'Set a goal',
      subtitle: 'Small forms built from the same primitives',
      children: <Widget>[
        Input(hintText: 'Goal name'),
        Gap(8),
        Row(
          children: <Widget>[
            Expanded(child: Input(hintText: 'Target')),
            Gap(8),
            Expanded(child: Input(hintText: 'Date')),
          ],
        ),
        Gap(12),
        SizedBox(
          width: double.infinity,
          child: Button(
            size: ButtonSize.sm,
            onPressed: collageNoop,
            child: Text('Create Goal'),
          ),
        ),
        Gap(8),
        SizedBox(
          width: double.infinity,
          child: Button(
            variant: ButtonVariant.outline,
            size: ButtonSize.sm,
            onPressed: collageNoop,
            child: Text('Cancel'),
          ),
        ),
      ],
    );
  }
}

void collageNoop() {}

class CollageTabsCard extends StatefulWidget {
  const CollageTabsCard({super.key});

  @override
  State<CollageTabsCard> createState() => CollageTabsCardState();
}

class CollageTabsCardState extends State<CollageTabsCard> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return CollageCard(
      children: <Widget>[
        Tabs(
          index: _index,
          onChanged: (int index) => setState(() => _index = index),
          children: const <TabItem>[
            TabItem(child: Text('Preview')),
            TabItem(child: Text('Code')),
            TabItem(child: Text('Usage')),
          ],
        ),
        const Gap(12),
        Text(
          switch (_index) {
            0 => 'Live component preview.',
            1 => 'Copy the source you install.',
            _ => 'Compose it with your own data.',
          },
          style: docsText(
            context,
            size: 13,
            color: theme.colors.mutedForeground,
          ),
        ),
      ],
    );
  }
}

class CollageSwitchesCard extends StatefulWidget {
  const CollageSwitchesCard({super.key});

  @override
  State<CollageSwitchesCard> createState() => CollageSwitchesCardState();
}

class CollageSwitchesCardState extends State<CollageSwitchesCard> {
  bool _first = true;
  bool _second = false;
  bool _third = true;

  @override
  Widget build(BuildContext context) {
    return CollageCard(
      title: 'Switches',
      children: <Widget>[
        Switch(
          value: _first,
          onChanged: (bool value) => setState(() => _first = value),
          label: const Text('Notifications'),
        ),
        const Gap(8),
        Switch(
          value: _second,
          onChanged: (bool value) => setState(() => _second = value),
          label: const Text('Weekly digest'),
        ),
        const Gap(8),
        Switch(
          value: _third,
          onChanged: (bool value) => setState(() => _third = value),
          label: const Text('Beta features'),
        ),
      ],
    );
  }
}

class CollageRadioCard extends StatefulWidget {
  const CollageRadioCard({super.key});

  @override
  State<CollageRadioCard> createState() => CollageRadioCardState();
}

class CollageRadioCardState extends State<CollageRadioCard> {
  String _value = 'pro';

  @override
  Widget build(BuildContext context) {
    return CollageCard(
      title: 'Choose a plan',
      children: <Widget>[
        ShadcnRadioGroup<String>(
          value: _value,
          onChanged: (String value) => setState(() => _value = value),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              RadioItem<String>(value: 'free', label: Text('Free')),
              RadioItem<String>(value: 'pro', label: Text('Pro')),
              RadioItem<String>(value: 'team', label: Text('Team')),
            ],
          ),
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
