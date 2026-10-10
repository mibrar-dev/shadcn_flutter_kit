// The Blocks pages (P6-B3), loaded as one deferred library so the block
// catalog, the block sources and the block widgets stay out of the landing
// route's chunk.
//
// `/blocks` and `/blocks/<category>` — the index: hero, the family pill strip
// (Featured + every block family) and one [BlockCard] per block, exactly like
// the reference `/blocks` page.
// `/blocks/<id>` — the full-page view of one block.

import 'package:flutter/widgets.dart';

import '../generated/docs_blocks.dart';
import '../routing/docs_nav.dart';
import '../routing/docs_router.dart';
import '../ui/shadcn/components/badge/badge.dart';
import '../ui/shadcn/components/button/button.dart';
import '../ui/shadcn/foundation/gap.dart';
import '../ui/shadcn/foundation/icons/lucide_icons.dart';
import '../ui/shadcn/primitives/clickable.dart';
import '../ui/shadcn/theme/theme.dart';
import '../widgets/announcement.dart';
import '../widgets/block_card.dart';
import '../widgets/copy_button.dart';
import '../widgets/docs_tokens.dart';

/// Outer padding + max width of the blocks section (the reference's
/// `.container`: 1400 px, 16 px gutters, 32 px from `lg`).
const double kBlocksMaxWidth = 1400;

/// `/blocks` and `/blocks/<category>` — the blocks index.
class BlocksIndexPage extends StatelessWidget {
  /// Creates the index page.
  const BlocksIndexPage({super.key, this.categorySlug});

  /// The selected family slug (`dashboard`), or null for Featured.
  final String? categorySlug;

  @override
  Widget build(BuildContext context) {
    final List<DocsBlock> blocks = _visibleBlocks(categorySlug);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const _BlocksHero(),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 64),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: kBlocksMaxWidth),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    _FamilyStrip(activeSlug: categorySlug),
                    const Gap(24),
                    for (final DocsBlock block in blocks) ...<Widget>[
                      BlockCard(key: ValueKey<String>(block.id), block: block),
                      const Gap(24),
                    ],
                    if (blocks.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 64),
                        child: Center(
                          child: Text(
                            'No blocks in this family yet.',
                            style: docsText(
                              context,
                              size: 15,
                              color: ShadcnTheme.of(
                                context,
                              ).colors.mutedForeground,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// The blocks of [slug], in `kBlocks` order; every block when null.
  static List<DocsBlock> visibleBlocks(String? slug) => _visibleBlocks(slug);
}

List<DocsBlock> _visibleBlocks(String? slug) {
  if (slug == null || slug.isEmpty) {
    return kBlocks;
  }
  return <DocsBlock>[
    for (final DocsBlockCategory category in kBlockCategories)
      if (category.slug == slug) ...category.blocks,
  ];
}

class _BlocksHero extends StatelessWidget {
  const _BlocksHero();

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    final double width = MediaQuery.sizeOf(context).width;
    final bool wide = width >= 1024;
    return Padding(
      padding: EdgeInsets.fromLTRB(24, wide ? 64 : 32, 24, 32),
      child: Column(
        children: <Widget>[
          Announcement(
            label: '${kBlocks.length} blocks ready to install',
            onPressed: () =>
                DocsRouterScope.of(context).go(context, '/docs/components'),
          ),
          Gap(wide ? 16 : 8),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 896),
            child: Text(
              'Building Blocks for the Web',
              textAlign: TextAlign.center,
              style: docsText(
                context,
                size: wide ? 40 : 30,
                weight: FontWeight.w600,
                height: 1.15,
                letterSpacing: wide ? -1 : 0,
                color: theme.colors.foreground,
              ),
            ),
          ),
          const Gap(12),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Text(
              'Composed, page-level layouts built from the kit components. '
              'Install one with a single command and make every pixel yours.',
              textAlign: TextAlign.center,
              style: docsText(
                context,
                size: width >= 640 ? 17 : 15,
                height: 1.6,
              ),
            ),
          ),
          const Gap(20),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: <Widget>[
              Button(
                variant: ButtonVariant.primary,
                size: ButtonSize.md,
                onPressed: () =>
                    DocsRouterScope.of(context).go(context, '/docs/components'),
                child: const Text('View Components'),
              ),
              Button(
                variant: ButtonVariant.secondary,
                size: ButtonSize.md,
                leading: const Icon(LucideIcons.terminal, size: 16),
                onPressed: () =>
                    DocsRouterScope.of(context).go(context, '/docs/cli'),
                child: const Text('CLI reference'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// The family pill strip: Featured + every block family, as route links.
class _FamilyStrip extends StatelessWidget {
  const _FamilyStrip({required this.activeSlug});

  final String? activeSlug;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: <Widget>[
          _FamilyPill(
            label: 'Featured',
            location: '/blocks',
            active: activeSlug == null,
          ),
          for (final DocsBlockCategory category
              in kBlockCategories) ...<Widget>[
            const Gap(8),
            _FamilyPill(
              label: category.id,
              location: '/blocks/${category.slug}',
              active: activeSlug == category.slug,
            ),
          ],
        ],
      ),
    );
  }
}

class _FamilyPill extends StatelessWidget {
  const _FamilyPill({
    required this.label,
    required this.location,
    required this.active,
  });

  final String label;
  final String location;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return Clickable(
      onPressed: () => DocsRouterScope.of(context).go(context, location),
      decoration: WidgetStateProperty.resolveWith<Decoration?>((
        Set<WidgetState> states,
      ) {
        return BoxDecoration(
          color: active
              ? theme.colors.secondary
              : (states.contains(WidgetState.hovered)
                    ? theme.colors.muted
                    : theme.colors.background),
          border: Border.all(
            color: active ? theme.colors.input : const Color(0x00000000),
          ),
          borderRadius: theme.borderRadiusMd,
        );
      }),
      padding: const WidgetStatePropertyAll<EdgeInsetsGeometry>(
        EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      ),
      textStyle: WidgetStatePropertyAll<TextStyle?>(
        docsText(
          context,
          size: 13,
          weight: FontWeight.w500,
          color: active
              ? theme.colors.secondaryForeground
              : theme.colors.mutedForeground,
        ),
      ),
      child: Text(label),
    );
  }
}

/// `/blocks/<id>` — one block, full page: title row, install command, the
/// block card and its manifest dependencies.
class BlockPage extends StatelessWidget {
  /// Creates the page for [blockId].
  const BlockPage({super.key, required this.blockId});

  /// The block id (`dashboard-01`).
  final String blockId;

  @override
  Widget build(BuildContext context) {
    final DocsBlock? block = kBlocks
        .where((DocsBlock b) => b.id == blockId)
        .firstOrNull;
    if (block == null) {
      return _MissingBlock(blockId: blockId);
    }
    final ({String? previousId, String? nextId}) neighbors = blockNeighbors(
      blockId,
    );
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 64),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: kBlocksMaxWidth),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                _BlockPageHeader(block: block),
                const Gap(24),
                BlockCard(
                  key: ValueKey<String>('${block.id}-page'),
                  block: block,
                  showOpenInNewTab: false,
                ),
                const Gap(32),
                _Dependencies(block: block),
                const Gap(32),
                _BlockPager(
                  previousId: neighbors.previousId,
                  nextId: neighbors.nextId,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BlockPageHeader extends StatelessWidget {
  const _BlockPageHeader({required this.block});

  final DocsBlock block;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Badge(variant: BadgeVariant.secondary, child: Text(block.category)),
            const Gap(8),
            Badge(variant: BadgeVariant.outline, child: Text(block.viewport)),
            const Spacer(),
            CopyButton(text: block.install, showLabel: true),
          ],
        ),
        const Gap(12),
        Text(
          block.name,
          style: docsText(
            context,
            size: 30,
            weight: FontWeight.w600,
            height: 36 / 30,
            letterSpacing: -0.75,
          ),
        ),
        const Gap(8),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: Text(
            block.description,
            style: docsText(
              context,
              size: 16,
              height: 1.5,
              color: theme.colors.mutedForeground,
            ),
          ),
        ),
      ],
    );
  }
}

/// The block's manifest dependencies, as badges (generated facts).
class _Dependencies extends StatelessWidget {
  const _Dependencies({required this.block});

  final DocsBlock block;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Installed with this block',
          style: docsText(
            context,
            size: 14,
            weight: FontWeight.w600,
            color: theme.colors.foreground,
          ),
        ),
        const Gap(8),
        Text(
          block.deps.isEmpty
              ? 'This block uses no other components.'
              : 'Components: ${block.deps.join(', ')}',
          style: docsText(
            context,
            size: 13,
            height: 1.5,
            color: theme.colors.mutedForeground,
          ),
        ),
      ],
    );
  }
}

/// Previous/next block pager in [kBlocks] order.
class _BlockPager extends StatelessWidget {
  const _BlockPager({required this.previousId, required this.nextId});

  final String? previousId;
  final String? nextId;

  @override
  Widget build(BuildContext context) {
    // Both buttons are labelled, so a 375 px article cannot hold them side by
    // side: the Wrap stacks them, and each button ellipsises its own label.
    final Widget previous = previousId == null
        ? const SizedBox.shrink()
        : Button(
            variant: ButtonVariant.secondary,
            size: ButtonSize.sm,
            leading: const Icon(LucideIcons.arrowLeft, size: 16),
            onPressed: () =>
                DocsRouterScope.of(context).go(context, '/blocks/$previousId'),
            child: Text(_labelOf(previousId!), overflow: TextOverflow.ellipsis),
          );
    final Widget next = nextId == null
        ? const SizedBox.shrink()
        : Button(
            variant: ButtonVariant.secondary,
            size: ButtonSize.sm,
            trailing: const Icon(LucideIcons.arrowRight, size: 16),
            onPressed: () =>
                DocsRouterScope.of(context).go(context, '/blocks/$nextId'),
            child: Text(_labelOf(nextId!), overflow: TextOverflow.ellipsis),
          );
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth < 560) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Align(alignment: Alignment.centerLeft, child: previous),
              const Gap(8),
              Align(alignment: Alignment.centerRight, child: next),
            ],
          );
        }
        return Row(children: <Widget>[previous, const Spacer(), next]);
      },
    );
  }

  String _labelOf(String id) =>
      kBlocks.firstWhere((DocsBlock b) => b.id == id).name;
}

class _MissingBlock extends StatelessWidget {
  const _MissingBlock({required this.blockId});

  final String blockId;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              'No block named `$blockId`.',
              style: docsText(context, size: 16, weight: FontWeight.w600),
            ),
            const Gap(12),
            Button(
              variant: ButtonVariant.secondary,
              size: ButtonSize.sm,
              onPressed: () =>
                  DocsRouterScope.of(context).go(context, '/blocks'),
              child: const Text('Back to Blocks'),
            ),
          ],
        ),
      ),
    );
  }
}
