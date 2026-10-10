// The `sidebar-02` block: an inset sidebar with grouped navigation.
//
// The sidebar is inset (rounded, with a gutter to the page background) and its
// navigation is grouped by section, the way shadcn's `sidebar-01` is. Below
// 840px the sidebar moves above the content instead of squeezing it.

import 'package:flutter/widgets.dart';

import '../../components/avatar/avatar.dart';
import '../../components/badge/badge.dart';
import '../../components/button/button.dart';
import '../../components/card/card.dart';
import '../../components/divider/divider.dart';
import '../../components/input/input.dart';
import '../../components/progress/progress.dart';
import '../../foundation/gap.dart';
import '../../foundation/icons/lucide_icons.dart';
import '../../theme/theme.dart';

/// A grouped, inset sidebar shell around a sample content area.
class Sidebar02 extends StatelessWidget {
  /// Creates the block.
  const Sidebar02({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    final spacing = theme.spacing;
    return ColoredBox(
      color: theme.colors.background,
      child: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final bool inset = constraints.maxWidth >= 840;
            final Widget sidebar = const _Sidebar02Panel();
            final Widget content = const Sidebar02Content();
            if (!inset) {
              return SingleChildScrollView(
                padding: EdgeInsets.all(spacing.md),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[sidebar, Gap(spacing.lg), content],
                ),
              );
            }
            return Padding(
              padding: EdgeInsets.all(spacing.md),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(width: 260, child: sidebar),
                  Gap(spacing.md),
                  Expanded(child: SingleChildScrollView(child: content)),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _Sidebar02Panel extends StatelessWidget {
  const _Sidebar02Panel();

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    final spacing = theme.spacing;
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
            padding: EdgeInsets.all(spacing.lg),
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
                Gap(spacing.sm),
                Text('Acme Inc', style: theme.typography.textSmall),
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
            padding: EdgeInsets.symmetric(horizontal: spacing.lg),
            child: const Input(hintText: 'Search'),
          ),
          Gap(spacing.lg),
          const _Sidebar02Group(
            label: 'Platform',
            first: true,
            items: ['Playground', 'Models', 'Documentation'],
          ),
          Gap(spacing.md),
          const _Sidebar02Group(
            label: 'Projects',
            first: false,
            items: ['Design system', 'Marketing site'],
          ),
          Gap(spacing.lg),
          const Divider(),
          Gap(spacing.lg),
          const _Sidebar02User(),
        ],
      ),
    );
  }
}

class _Sidebar02Group extends StatelessWidget {
  const _Sidebar02Group({
    required this.label,
    required this.first,
    required this.items,
  });

  final String label;
  final bool first;
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    final spacing = theme.spacing;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: spacing.lg),
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
          Gap(spacing.sm),
          for (var i = 0; i < items.length; i++) ...<Widget>[
            if (first && i == 0)
              const _Sidebar02ActiveItem(label: 'Playground')
            else
              _Sidebar02NavItem(label: items[i]),
            if (i != items.length - 1) Gap(spacing.xs),
          ],
        ],
      ),
    );
  }
}

class _Sidebar02NavItem extends StatelessWidget {
  const _Sidebar02NavItem({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: theme.spacing.sm,
        vertical: theme.spacing.xs,
      ),
      child: Text(label, style: theme.typography.textSmall),
    );
  }
}

class _Sidebar02ActiveItem extends StatelessWidget {
  const _Sidebar02ActiveItem({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    final spacing = theme.spacing;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: spacing.sm,
        vertical: spacing.xs,
      ),
      decoration: BoxDecoration(
        color: theme.colors.sidebarAccent,
        borderRadius: theme.borderRadiusSm,
      ),
      child: Text(
        label,
        style: theme.typography.textSmall.copyWith(
          color: theme.colors.sidebarAccentForeground,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _Sidebar02User extends StatelessWidget {
  const _Sidebar02User();

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    final spacing = theme.spacing;
    return Padding(
      padding: EdgeInsets.all(spacing.lg),
      child: Row(
        children: <Widget>[
          const Avatar(initials: 'SD'),
          Gap(spacing.sm),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('shadcn', style: theme.typography.textSmall),
                Gap(spacing.xs),
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

/// The sample content area.
class Sidebar02Content extends StatelessWidget {
  /// Creates the content area.
  const Sidebar02Content({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    final spacing = theme.spacing;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text('Playground', style: theme.typography.h2),
        Gap(spacing.xs),
        Text(
          'Experiment with the API before you ship it.',
          style: theme.typography.textMuted.copyWith(
            color: theme.colors.mutedForeground,
          ),
        ),
        Gap(spacing.lg),
        Wrap(
          spacing: spacing.md,
          runSpacing: spacing.md,
          children: const <Widget>[
            Badge(variant: BadgeVariant.secondary, child: Text('Stable')),
            Badge(variant: BadgeVariant.outline, child: Text('Beta channel')),
            Badge(variant: BadgeVariant.primary, child: Text('New: batches')),
          ],
        ),
        Gap(spacing.lg),
        Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Usage this month', style: theme.typography.textLarge),
              Gap(spacing.lg),
              const Progress(value: 0.68),
              Gap(spacing.sm),
              Text(
                '2,040,000 of 3,000,000 tokens',
                style: theme.typography.textSmall.copyWith(
                  color: theme.colors.mutedForeground,
                ),
              ),
              Gap(spacing.lg),
              const Divider(),
              Gap(spacing.lg),
              const Button(child: Text('Upgrade plan')),
            ],
          ),
        ),
      ],
    );
  }
}
