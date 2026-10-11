// The `sidebar-02` block, part 2: the inset sidebar panel.
//
// Imported by `sidebar_02.dart`; a block never imports another block.

import 'package:flutter/widgets.dart';

import '../../components/avatar/avatar.dart';
import '../../components/divider/divider.dart';
import '../../components/input/input.dart';
import '../../foundation/gap.dart';
import '../../foundation/icons/lucide_icons.dart';
import '../../theme/theme.dart';

/// The inset sidebar panel: product mark, live-filter search, grouped
/// navigation and the user row. Shared by the desktop layout and the mobile
/// drawer, so both stay identical.
class Sidebar02Panel extends StatefulWidget {
  /// Creates the panel.
  const Sidebar02Panel({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  /// Index of the selected link across both groups.
  final int selected;

  /// Called with the tapped link index.
  final ValueChanged<int> onSelected;

  @override
  State<Sidebar02Panel> createState() => _Sidebar02PanelState();
}

class _Sidebar02PanelState extends State<Sidebar02Panel> {
  static const List<String> _platform = <String>[
    'Playground',
    'Models',
    'Documentation',
  ];
  static const List<String> _projects = <String>[
    'Design system',
    'Marketing site',
  ];

  String _query = '';

  List<String> get _links => <String>[..._platform, ..._projects];

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    final String needle = _query.trim().toLowerCase();
    List<String> match(List<String> items) => needle.isEmpty
        ? items
        : items
              .where((String item) => item.toLowerCase().contains(needle))
              .toList();
    final List<String> platform = match(_platform);
    final List<String> projects = match(_projects);
    return Container(
      decoration: BoxDecoration(
        color: theme.colors.sidebar,
        borderRadius: theme.borderRadiusXl,
        border: Border.all(color: theme.colors.sidebarBorder),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(theme.spacing.lg),
            child: Row(
              children: <Widget>[
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: theme.colors.sidebarPrimary,
                    borderRadius: theme.borderRadiusSm,
                  ),
                  child: Icon(
                    LucideIcons.command,
                    size: 16,
                    color: theme.colors.sidebarPrimaryForeground,
                  ),
                ),
                Gap(theme.spacing.sm),
                Text(
                  'Acme Inc',
                  style: theme.typography.textSmall.copyWith(
                    color: theme.colors.sidebarForeground,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Text(
                  'v1.2',
                  style: theme.typography.xSmall.copyWith(
                    color: theme.colors.mutedForeground,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: theme.spacing.lg),
            child: _Sidebar02Search(
              onChanged: (String value) => setState(() => _query = value),
            ),
          ),
          Gap(theme.spacing.lg),
          if (platform.isNotEmpty)
            _Sidebar02Group(
              label: 'Platform',
              items: platform,
              links: _links,
              selected: widget.selected,
              onSelected: widget.onSelected,
            ),
          if (platform.isNotEmpty && projects.isNotEmpty) Gap(theme.spacing.md),
          if (projects.isNotEmpty)
            _Sidebar02Group(
              label: 'Projects',
              items: projects,
              links: _links,
              selected: widget.selected,
              onSelected: widget.onSelected,
            ),
          if (platform.isEmpty && projects.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: theme.spacing.lg),
              child: Text(
                'No matches for "$_query".',
                style: theme.typography.textSmall.copyWith(
                  color: theme.colors.mutedForeground,
                ),
              ),
            ),
          Gap(theme.spacing.lg),
          const Divider(),
          Gap(theme.spacing.lg),
          const _Sidebar02User(),
        ],
      ),
    );
  }
}

class _Sidebar02Search extends StatelessWidget {
  const _Sidebar02Search({required this.onChanged});

  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Input(hintText: 'Search', onChanged: onChanged);
  }
}

class _Sidebar02Group extends StatelessWidget {
  const _Sidebar02Group({
    required this.label,
    required this.items,
    required this.links,
    required this.selected,
    required this.onSelected,
  });

  final String label;
  final List<String> items;

  /// Every link in order; the index is the selection identity.
  final List<String> links;
  final int selected;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: theme.spacing.lg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            label,
            style: theme.typography.xSmall.copyWith(
              color: theme.colors.mutedForeground,
              fontWeight: FontWeight.w600,
            ),
          ),
          Gap(theme.spacing.sm),
          for (var i = 0; i < items.length; i++) ...<Widget>[
            _Sidebar02NavItem(
              label: items[i],
              selected: links.indexOf(items[i]) == selected,
              onPressed: () => onSelected(links.indexOf(items[i])),
            ),
            if (i != items.length - 1) Gap(theme.spacing.xs),
          ],
        ],
      ),
    );
  }
}

class _Sidebar02NavItem extends StatelessWidget {
  const _Sidebar02NavItem({
    required this.label,
    required this.selected,
    required this.onPressed,
  });

  final String label;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: theme.spacing.sm,
          vertical: theme.spacing.xs,
        ),
        decoration: BoxDecoration(
          color: selected ? theme.colors.sidebarAccent : null,
          borderRadius: theme.borderRadiusSm,
        ),
        child: Text(
          label,
          style: theme.typography.textSmall.copyWith(
            color: selected
                ? theme.colors.sidebarAccentForeground
                : theme.colors.sidebarForeground,
            fontWeight: selected ? FontWeight.w500 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

class _Sidebar02User extends StatelessWidget {
  const _Sidebar02User();

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return Padding(
      padding: EdgeInsets.all(theme.spacing.lg),
      child: Row(
        children: <Widget>[
          const Avatar(initials: 'SD'),
          Gap(theme.spacing.sm),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'shadcn',
                  style: theme.typography.textSmall.copyWith(
                    color: theme.colors.sidebarForeground,
                  ),
                ),
                Gap(theme.spacing.xs),
                Text(
                  'm@example.com',
                  style: theme.typography.xSmall.copyWith(
                    color: theme.colors.mutedForeground,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
